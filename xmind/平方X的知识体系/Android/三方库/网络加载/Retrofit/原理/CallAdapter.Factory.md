用来转换 retrofit2.OkHttpCall

默认的是 DefaultCallAdapterFactory

它创建 ExecutorCallbackCall 用来使用 Executor 将 Callback 切换回主线程，

retrofit2.OkHttpCall 会创建 okhttp3.Call 并执行 enqueue 得到 okhttp3.Response

然后通过 retrofit2.OkHttpCall#parseResponse 将 okhttp3.Response 转为 retrofit2.Response

其中会用到 responseConverter
