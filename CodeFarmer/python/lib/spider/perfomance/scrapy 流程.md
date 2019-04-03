[Scrapy源码分析（四）核心抓取流程](http://kaito-kidd.com/2016/12/07/scrapy-code-analyze-core-process/)


# 请求
    scrapy.crawler.Crawler
    
    @defer.inlineCallbacks
    def crawl(self, *args, **kwargs):
        assert not self.crawling, "Crawling already taking place"
        self.crawling = True

        try:
            self.spider = self._create_spider(*args, **kwargs)
            self.engine = self._create_engine()
            start_requests = iter(self.spider.start_requests())
            yield self.engine.open_spider(self.spider, start_requests)
            yield defer.maybeDeferred(self.engine.start)
        except Exception:
            # In Python 2 reraising an exception after yield discards
            # the original traceback (see https://bugs.python.org/issue7563),
            # so sys.exc_info() workaround is used.
            # This workaround also works in Python 3, but it is not needed,
            # and it is slower, so in Python 3 we use native `raise`.
            if six.PY2:
                exc_info = sys.exc_info()

            self.crawling = False
            if self.engine is not None:
                yield self.engine.close()

            if six.PY2:
                six.reraise(*exc_info)
            raise
    
    即其中的 self.spider.start_requests() 方法
    
    scrapy.core.engine.ExecutionEngine#open_spider
    @defer.inlineCallbacks
    def open_spider(self, spider, start_requests=(), close_if_idle=True):
        assert self.has_capacity(), "No free spider slot when opening %r" % \
            spider.name
        logger.info("Spider opened", extra={'spider': spider})
        # 注册 _next_request
        nextcall = CallLaterOnce(self._next_request, spider)
        scheduler = self.scheduler_cls.from_crawler(self.crawler)
        start_requests = yield self.scraper.spidermw.process_start_requests(start_requests, spider)
        slot = Slot(start_requests, close_if_idle, nextcall, scheduler)
        self.slot = slot
        self.spider = spider
        yield scheduler.open(spider)
        yield self.scraper.open_spider(spider)
        self.crawler.stats.open_spider(spider)
        yield self.signals.send_catch_log_deferred(signals.spider_opened, spider=spider)
        slot.nextcall.schedule()
        slot.heartbeat.start(5)
# 循环调度
    scrapy.core.engine.ExecutionEngine#_next_request
    def _next_request(self, spider):
        slot = self.slot
        if not slot:
            return

        if self.paused:
            return

        while not self._needs_backout(spider):
            # 如果不需要等待，则下载请求，在后面介绍
            if not self._next_request_from_scheduler(spider):
                break

        if slot.start_requests and not self._needs_backout(spider):
            try:
                # 获取请求
                request = next(slot.start_requests)
            except StopIteration:
                slot.start_requests = None
            except Exception:
                slot.start_requests = None
                logger.error('Error while obtaining start requests',
                             exc_info=True, extra={'spider': spider})
            else:
                # 放入队列
                self.crawl(request, spider)

        if self.spider_is_idle(spider) and slot.close_if_idle:
            self._spider_idle(spider)

            
    scrapy.core.engine.ExecutionEngine#crawl
    def crawl(self, request, spider):
        assert spider in self.open_spiders, \
            "Spider %r not opened when crawling: %s" % (spider.name, request)
        self.schedule(request, spider)
        self.slot.nextcall.schedule()
        
    scrapy.core.engine.ExecutionEngine#schedule
    def schedule(self, request, spider):
        self.signals.send_catch_log(signal=signals.request_scheduled,
                request=request, spider=spider)
        if not self.slot.scheduler.enqueue_request(request):
            self.signals.send_catch_log(signal=signals.request_dropped,
                                        request=request, spider=spider)
                                        
# 下载请求
加入队列以后，下一次调用 _next_request 会下载请求

    scrapy.core.engine.ExecutionEngine#_next_request_from_scheduler
    
    def _next_request_from_scheduler(self, spider):
        slot = self.slot
        request = slot.scheduler.next_request()
        if not request:
            return
        d = self._download(request, spider)
        d.addBoth(self._handle_downloader_output, request, spider)
        d.addErrback(lambda f: logger.info('Error while handling downloader output',
                                           exc_info=failure_to_exc_info(f),
                                           extra={'spider': spider}))
        d.addBoth(lambda _: slot.remove_request(request))
        d.addErrback(lambda f: logger.info('Error while removing request from slot',
                                           exc_info=failure_to_exc_info(f),
                                           extra={'spider': spider}))
        d.addBoth(lambda _: slot.nextcall.schedule())
        d.addErrback(lambda f: logger.info('Error while scheduling new request',
                                           exc_info=failure_to_exc_info(f),
                                           extra={'spider': spider}))
        return d
        
    scrapy.core.engine.ExecutionEngine#_download
    
    def _download(self, request, spider):
        slot = self.slot
        slot.add_request(request)
        def _on_success(response):
            assert isinstance(response, (Response, Request))
            if isinstance(response, Response):
                response.request = request # tie request to response received
                logkws = self.logformatter.crawled(request, response, spider)
                logger.log(*logformatter_adapter(logkws), extra={'spider': spider})
                self.signals.send_catch_log(signal=signals.response_received, \
                    response=response, request=request, spider=spider)
            return response

        def _on_complete(_):
            # 下载完成下一次调度
            slot.nextcall.schedule()
            return _
        # 获取
        dwld = self.downloader.fetch(request, spider)
        dwld.addCallbacks(_on_success)
        dwld.addBoth(_on_complete)
        return dwld

        
        
    scrapy.core.downloader.Downloader#fetch
    
    def fetch(self, request, spider):
        def _deactivate(response):
            self.active.remove(request)
            return response

        self.active.add(request)
        # 调用中间件，注册成功是 _enqueue_request
        dfd = self.middleware.download(self._enqueue_request, request, spider)
        return dfd.addBoth(_deactivate)
        
    scrapy.core.downloader.Downloader#_enqueue_request
    
    def _enqueue_request(self, request, spider):
        key, slot = self._get_slot(request, spider)
        request.meta['download_slot'] = key

        def _deactivate(response):
            slot.active.remove(request)
            return response

        slot.active.add(request)
        deferred = defer.Deferred().addBoth(_deactivate)
        slot.queue.append((request, deferred))
        # 处理队列
        self._process_queue(spider, slot)
        return deferred

    def _process_queue(self, spider, slot):
        if slot.latercall and slot.latercall.active():
            return

        # Delay queue processing if a download_delay is configured
        now = time()
        delay = slot.download_delay()
        if delay:
            penalty = delay - now + slot.lastseen
            if penalty > 0:
                slot.latercall = reactor.callLater(penalty, self._process_queue, spider, slot)
                return

        # Process enqueued requests if there are free slots to transfer for this slot
        while slot.queue and slot.free_transfer_slots() > 0:
            slot.lastseen = now
            request, deferred = slot.queue.popleft()
            # 下载
            dfd = self._download(slot, request, spider)
            dfd.chainDeferred(deferred)
            # prevent burst if inter-request delays were configured
            if delay:
                self._process_queue(spider, slot)
                break

    def _download(self, slot, request, spider):
        # The order is very important for the following deferreds. Do not change!

        # 1. Create the download deferred
        # 下载使用 self.handlers.download_request
        dfd = mustbe_deferred(self.handlers.download_request, request, spider)

        # 2. Notify response_downloaded listeners about the recent download
        # before querying queue for next request
        def _downloaded(response):
            self.signals.send_catch_log(signal=signals.response_downloaded,
                                        response=response,
                                        request=request,
                                        spider=spider)
            return response
        dfd.addCallback(_downloaded)

        # 3. After response arrives,  remove the request from transferring
        # state to free up the transferring slot so it can be used by the
        # following requests (perhaps those which came from the downloader
        # middleware itself)
        slot.transferring.add(request)

        def finish_transferring(_):
            slot.transferring.remove(request)
            # 下载成功仍调用 _process_queue
            self._process_queue(spider, slot)
            return _

        return dfd.addBoth(finish_transferring)

    接下来下载结果返回到 scrapy.core.engine.ExecutionEngine#_next_request_from_scheduler
    回调 scrapy.core.engine.ExecutionEngine#_handle_downloader_output
    
# 处理下载结果

    def _handle_downloader_output(self, response, request, spider):
        assert isinstance(response, (Request, Response, Failure)), response
        # downloader middleware can return requests (for example, redirects)
        if isinstance(response, Request):
            self.crawl(response, spider)
            return
        # response is a Response or Failure
        d = self.scraper.enqueue_scrape(response, request, spider)
        d.addErrback(lambda f: logger.error('Error while enqueuing downloader output',
                                            exc_info=failure_to_exc_info(f),
                                            extra={'spider': spider}))
        return d
        
    scrapy.core.scraper.Scraper#enqueue_scrape
    
    def enqueue_scrape(self, response, request, spider):
        slot = self.slot
        dfd = slot.add_response_request(response, request)
        def finish_scraping(_):
            slot.finish_response(response, request)
            self._check_if_closing(spider, slot)
            self._scrape_next(spider, slot)
            return _
        dfd.addBoth(finish_scraping)
        dfd.addErrback(
            lambda f: logger.error('Scraper bug processing %(request)s',
                                   {'request': request},
                                   exc_info=failure_to_exc_info(f),
                                   extra={'spider': spider}))
        # 处理下一个
        self._scrape_next(spider, slot)
        return dfd
        
    def _scrape_next(self, spider, slot):
        while slot.queue:
            # 循环取出并处理
            response, request, deferred = slot.next_response_request_deferred()
            self._scrape(response, request, spider).chainDeferred(deferred)

    def _scrape(self, response, request, spider):
        """Handle the downloaded response or failure through the spider
        callback/errback"""
        assert isinstance(response, (Response, Failure))

        dfd = self._scrape2(response, request, spider) # returns spiders processed output
        dfd.addErrback(self.handle_spider_error, request, response, spider)
        # 回调
        dfd.addCallback(self.handle_spider_output, request, response, spider)
        return dfd

    def _scrape2(self, request_result, request, spider):
        """Handle the different cases of request's result been a Response or a
        Failure"""
        if not isinstance(request_result, Failure):
            # 调用爬虫中间件管理器的scrape_response，回调 call_spider
            return self.spidermw.scrape_response(
                self.call_spider, request_result, request, spider)
        else:
            # FIXME: don't ignore errors in spider middleware
            dfd = self.call_spider(request_result, request, spider)
            return dfd.addErrback(
                self._log_download_errors, request_result, request, spider)

    
    def call_spider(self, result, request, spider):
        result.request = request
        dfd = defer_result(result)
        dfd.addCallbacks(request.callback or spider.parse, request.errback)
        return dfd.addCallback(iterate_spider_output)
        
    # 回调上面注册的方法
    
    def handle_spider_output(self, result, request, response, spider):
        if not result:
            return defer_succeed(None)
        it = iter_errback(result, self.handle_spider_error, request, response, spider)
        dfd = parallel(it, self.concurrent_items,
            self._process_spidermw_output, request, response, spider)
        return dfd
        
    def _process_spidermw_output(self, output, request, response, spider):
        """Process each Request/Item (given in the output parameter) returned
        from the given spider
        """
        if isinstance(output, Request):
            self.crawler.engine.crawl(request=output, spider=spider)
        elif isinstance(output, (BaseItem, dict)):
            self.slot.itemproc_size += 1
            # 调用 process_item
            dfd = self.itemproc.process_item(output, spider)
            # 回调 _itemproc_finished
            dfd.addBoth(self._itemproc_finished, output, response, spider)
            return dfd
        elif output is None:
            pass
        else:
            typename = type(output).__name__
            logger.error('Spider must return Request, BaseItem, dict or None, '
                         'got %(typename)r in %(request)s',
                         {'request': request, 'typename': typename},
                         extra={'spider': spider})

    def _itemproc_finished(self, output, item, response, spider):
        """ItemProcessor finished for the given ``item`` and returned ``output``
        """
        self.slot.itemproc_size -= 1
        if isinstance(output, Failure):
            ex = output.value
            if isinstance(ex, DropItem):
                logkws = self.logformatter.dropped(item, ex, response, spider)
                logger.log(*logformatter_adapter(logkws), extra={'spider': spider})
                return self.signals.send_catch_log_deferred(
                    signal=signals.item_dropped, item=item, response=response,
                    spider=spider, exception=output.value)
            else:
                logger.error('Error processing %(item)s', {'item': item},
                             exc_info=failure_to_exc_info(output),
                             extra={'spider': spider})
        else:
            logkws = self.logformatter.scraped(output, response, spider)
            logger.log(*logformatter_adapter(logkws), extra={'spider': spider})
            return self.signals.send_catch_log_deferred(
                signal=signals.item_scraped, item=output, response=response,
                spider=spider)


                
# 记录耗时
scrapy.core.scraper.Scraper#_scrape_next 下载完成开始处理
scrapy.core.scraper.Scraper#handle_spider_output 中 spider 处理完成
scrapy.core.scraper.Scraper#_itemproc_finished 中 pipeline 处理完成