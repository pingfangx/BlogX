# IntentService 原理
    android.app.IntentService#onStart
    会发送消息
        mServiceHandler.sendMessage(msg);
        
    之前学过，发送消息，是加入到 Looper 的 MessageQueue 中
    因类 Looper 是在子线程的，所以最后收到消息也就在子线程
    
    android.app.IntentService#onCreate
        super.onCreate();
        HandlerThread thread = new HandlerThread("IntentService[" + mName + "]");
        thread.start();

        mServiceLooper = thread.getLooper();
        mServiceHandler = new ServiceHandler(mServiceLooper);
        
    于是在 onStart 中发送消息，在 ServiceHandler.handleMessage 中调用 onHandleIntent
    
# HandlerThread 原理
    在 run 中准备、持有 Looper 并开始循环
    
    @Override
    public void run() {
        mTid = Process.myTid();
        Looper.prepare();
        synchronized (this) {
            mLooper = Looper.myLooper();
            notifyAll();
        }
        Process.setThreadPriority(mPriority);
        onLooperPrepared();
        Looper.loop();
        mTid = -1;
    }
    通过 getLooper() 可以返回 Looper，外部可以使用 Looper 创建 Handler
    
    要注意 quit 退出