# subscribeOn 和 observeOn
In ReactiveX an observer subscribes to an Observable.

* subscribeOn 用 ObservableSubscribeOn 包装
* ObservableSubscribeOn 在 subscribeActual 用 Scheduler 调度线程
* observeOn 用 ObservableObserveOn 包装
* ObservableObserveOn 创建 ObserveOnObserver
* ObservableObserveOn 的 ObserveOnObserver 在 onNext 中使用 Scheduler 调度

# 调度
* Scheduler 会调用 createWorker() 方法创建 Worker， 调度由 Worker 实现
* Worker 子类有 NewThreadWorker 、HandlerWorker
* IoScheduler 会创建 NewThreadWorker 调度时依赖 ThreadFactory 创建线程
* AndroidSchedulers#mainThread 会创建 HandlerWorker，调度时依赖 Handler 