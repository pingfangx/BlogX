这是 Executors.newCachedThreadPool() 和 Executors.newFixedThreadPool() 创建线程池时使用的不同队列。

根据需求不同，所以使用的队列不同。

详细文档可查阅 API

# SynchronousQueue
> 一种阻塞队列，其中每个插入操作必须等待另一个线程的对应移除操作 ，反之亦然。同步队列没有任何内部容量，甚至连一个队列的容量都没有。

因为 newCachedThreadPool 创建的线程不限制工作线程数，工作完成后有 60 时间，如果没有获取到新任务则销毁 Worker

# LinkedBlockingQueue
先进先出