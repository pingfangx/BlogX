[Android系统启动（五）-ActivityManagerService篇 - 简书](https://www.jianshu.com/p/1e7991d5dc98)

讲 SystemServer 的时候讲到在 com.android.server.SystemServer#run 中将会调用
    
            startBootstrapServices();                
                mActivityManagerService = mSystemServiceManager.startService(
                        ActivityManagerService.Lifecycle.class).getService();
            startCoreServices();
            startOtherServices();
                mActivityManagerService.systemReady()
                    startHomeActivityLocked(currentUserId, "systemReady");
            
启动相关服务。

    com.android.server.SystemServer#startBootstrapServices
    
        traceBeginAndSlog("StartActivityManager");
        mActivityManagerService = mSystemServiceManager.startService(
                ActivityManagerService.Lifecycle.class).getService();
    com.android.server.SystemServiceManager#startService(com.android.server.SystemService)
            service.onStart();
            
    所以是调用 com.android.server.SystemService#onStart
    com.android.server.am.ActivityManagerService.Lifecycle#onStart        
        public Lifecycle(Context context) {
            super(context);
            mService = new ActivityManagerService(context);
        }

        @Override
        public void onStart() {
            mService.start();
        }
于是初始化了  new ActivityManagerService 并调用 start()

# com.android.server.am.ActivityManagerService#systemReady
在 SystemServer.startOtherServices() 中调用
    
    startHomeActivityLocked(currentUserId, "systemReady");
    