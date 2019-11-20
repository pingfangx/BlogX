由于各类名太绕了，后面不知道有没有写清楚写正确。  
可参考绘制的时序图。  

[Rxjava 2.x 源码系列 - 线程切换 （上）](https://blog.csdn.net/gdutxiaoxu/article/details/80577389)

[Rxjava 2.x 源码系列 - 线程切换 （下）](https://blog.csdn.net/gdutxiaoxu/article/details/80599799)


# subscribeOn

    public final Observable<T> subscribeOn(Scheduler scheduler) {
        ObjectHelper.requireNonNull(scheduler, "scheduler is null");
        return RxJavaPlugins.onAssembly(new ObservableSubscribeOn<T>(this, scheduler));
    }
    
    public ObservableSubscribeOn(ObservableSource<T> source, Scheduler scheduler) {
        super(source);
        this.scheduler = scheduler;
    }
    
    可查看 ObservableSubscribeOn
    主要是创建并调度 SubscribeTask，由 SubscribeTask 再调用 source.subscribe(parent);

# observeOn


    public final Observable<T> observeOn(Scheduler scheduler) {
        return observeOn(scheduler, false, bufferSize());
    }
    public final Observable<T> observeOn(Scheduler scheduler, boolean delayError, int bufferSize) {
        ObjectHelper.requireNonNull(scheduler, "scheduler is null");
        ObjectHelper.verifyPositive(bufferSize, "bufferSize");
        return RxJavaPlugins.onAssembly(new ObservableObserveOn<T>(this, scheduler, delayError, bufferSize));
    }
    可查看 ObservableObserveOn
    主要是将 observer 包装为 ObserveOnObserver
# Scheduler 的实现

Scheduler 有 scheduleDirect 的默认实现，会调用 createWorker() 创建 Worker 再调用 Worker 的 schedule 方法。

所以线程的切换依赖于 Worker 的实现，可查看 Worker 的子类。

常用子类有 NewThreadWorker 、HandlerWorker 等。

NewThreadWorker 的实现持有 executor

    private final ScheduledExecutorService executor; 
    public NewThreadWorker(ThreadFactory threadFactory) {
        executor = SchedulerPoolFactory.create(threadFactory);
    }
    
通过 threadFactory 创建不同的线程实现线程切换。

HandlerWorker 的实现则使用 Handler  
要注意的是 HandlerScheduler 重写了 scheduleDirect（ObservableSubscribeOn 在 subscribeActual 中调用）  
跳过了 HandlerWorker 直接调用 postDelayed(Runnable, long)

而 HandlerWorker 也还有 schedule 方法（ObservableObserveOn 创建的 ObserveOnObserver 在 onNext 中调用）  
调用 Handler#sendMessageDelayed，message 的 callback 依然是 ScheduledRunnable

# 问题
参考的博文中提到了一个问题，多次调用 subscribeOn 或 observeOn 会怎么样？  
subscribeOn 是包装 Observable，多次调用就会多次包装，从后向前依次调用  
所以第一次调用的 subscribeOn 生效。（后面的也是生效的，只是最后回到了第一次调用设置的线程，网上说的只有第一次有用觉重欠妥。）

observeOn 是包装 Observer，收到 onNext 后依次向后传递，所以是最后的 observeOn 生效。（中间的也是生效的，可以切换线程）