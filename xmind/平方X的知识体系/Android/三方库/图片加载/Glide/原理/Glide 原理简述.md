# 原理简述
* 创建 Target 和 Request
* 调用 Engine 的 load 方法，load 方法会查找缓存或启动新的 EngineJob
* EngineJob 在线程池中执行 DecodeJob
* DecodeJob 负责加载资源回调到 EngineJob
* EngineJob 回调到 Request 设置到 Target 上

# 线程切换
使用 Handler，在 Glide 4 版本中，使用 callback 和 callbackExecutor
* RequestBuilder 在 into 时创建 mainThreadExecutor() 构造 Request
* Request 在 begin 时调用 Engine.load 方法传递 callbackExecutor,而 callback 是 Request
* Engine 通过 EngineJob.addCallback 设置 callback 和 callbackExecutor
* Engine 创建了 EngineJob 和 DecodeJob， DecodeJob 的 DecodeJob.Callback 是 EngineJob
* DecodeJob 解码完成后回调到 EngineJob， EngineJob 使用 callbackExecutor 执行 callback
* callback 是 Request 回调到 Request

## mainThreadExecutor

    private static final Executor MAIN_THREAD_EXECUTOR =
      new Executor() {
        private final Handler handler = new Handler(Looper.getMainLooper());

        @Override
        public void execute(@NonNull Runnable command) {
          handler.post(command);
        }
      };
      
