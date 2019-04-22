scrapy 中需要设置 SPIDER_MODULES  
一开始想直接得到类的包名，好像不可以。


查了相关方法

    dir 可以获取所有属性
    __module__  可以获取模块名
    self.spider.__module__ 得到爬虫模块名
    sys.modules[self.spider.__module__] 得到该模块信息
    __file__ 得到路径
    
    os.path.relpath(sys.modules[self.spider.__module__].__file__,__file__)
    得到相对路径，相对路径再处理下就可以得到包名了。