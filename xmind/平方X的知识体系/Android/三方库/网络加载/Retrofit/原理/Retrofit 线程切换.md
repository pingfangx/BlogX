# 子线程加载
    client.dispatcher().enqueue 转到 Dispatcher
    okhttp3.Dispatcher#executorService 创建 ExecutorService 

# 回调线程
与 Glide 一样，callback 还对应 callbackExecutor

在 retrofit2.Retrofit.Builder#build 中声明


    Executor callbackExecutor = this.callbackExecutor;
    if (callbackExecutor == null) {
        callbackExecutor = platform.defaultCallbackExecutor();
    }

    retrofit2.Platform.Android#defaultCallbackExecutor
      
    @Override public Executor defaultCallbackExecutor() {
      return new MainThreadExecutor();
    }
    
    
    static class MainThreadExecutor implements Executor {
      private final Handler handler = new Handler(Looper.getMainLooper());

      @Override public void execute(Runnable r) {
        handler.post(r);
      }
    }
    
    Builder#build 中创建，传递给 CallAdapter.Factory
    
    callAdapterFactories.addAll(platform.defaultCallAdapterFactories(callbackExecutor));
    
    实际是 DefaultCallAdapterFactory
    
    然后创建 Call 时创建 ExecutorCallbackCall
    
    在 enqueue 的 callback 参数中使用 MainThreadExecutor 执行，就回到了主线程。