# 加载
* 通过 build 创建 Retrofit 实例
* Retrofit.create 动态代理创建 Service 实例
* 调用 Service 方法时， Retrofit 会解析并返回一个 ExecutorCallbackCall
* 调用 enqueue 时会最终调用到 okhttp3.RealCall 的 enqueue
* 创建线程池执行 RealCall$AsyncCall
* 创建 RealInterceptorChain 不同的拦截器拦截及处理(责任链模式)
* okhttp3.Response 返回到 RealCall$AsyncCall，回调到 OkHttpCall 创建的匿名类，再回调到最开始创建的 ExecutorCallbackCall
* ExecutorCallbackCall 在指定的 MainThreadExecutor 中执行