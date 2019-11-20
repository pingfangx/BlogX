[安卓应用无响应，你真的了解吗？](https://mp.weixin.qq.com/s?__biz=MzI5NjE3NzA4Mg==&mid=2650359967&idx=1&sn=7d59915254a6a346c4d5eda369141eb6&chksm=f445b44ac3323d5c458405f6500d50e875fd374e629bbc7158a1d7105a581766a28706444764&mpshare=1&scene=1&srcid=&pass_ticket=L9MQbF6uhaOTmPU7yqV4H7YT2ItYKOL0RacATooz4V7SEWvXnButGHwaERsWeKsp#rd)

[startService启动过程分析 - Gityuan博客 | 袁辉辉的技术博客](http://gityuan.com/2016/03/06/start-service/)
  
# 添加
    com.android.server.am.ActiveServices#scheduleServiceTimeoutLocked
    void scheduleServiceTimeoutLocked(ProcessRecord proc) {
        if (proc.executingServices.size() == 0 || proc.thread == null) {
            return;
        }
        Message msg = mAm.mHandler.obtainMessage(
                ActivityManagerService.SERVICE_TIMEOUT_MSG);
        msg.obj = proc;
        mAm.mHandler.sendMessageDelayed(msg,
                proc.execServicesFg ? SERVICE_TIMEOUT : SERVICE_BACKGROUND_TIMEOUT);
    }
    
# 移除
    com.android.server.am.ActiveServices#serviceDoneExecutingLocked(com.android.server.am.ServiceRecord, boolean, boolean)
        ...
                    mAm.mHandler.removeMessages(ActivityManagerService.SERVICE_TIMEOUT_MSG, r.app);
    
    所以可以得到超时的时间
    
    // How long we wait for a service to finish executing.
    static final int SERVICE_TIMEOUT = 20*1000;

    // How long we wait for a service to finish executing.
    static final int SERVICE_BACKGROUND_TIMEOUT = SERVICE_TIMEOUT * 10;
    
# 前后台的判断
    com.android.server.am.ActiveServices#startServiceLocked
    
        final boolean callerFg;
        if (caller != null) {
            final ProcessRecord callerApp = mAm.getRecordForAppLocked(caller);
            if (callerApp == null) {
                throw new SecurityException(
                        "Unable to find app for caller " + caller
                        + " (pid=" + callingPid
                        + ") when starting service " + service);
            }
            callerFg = callerApp.setSchedGroup != ProcessList.SCHED_GROUP_BACKGROUND;
        } else {
            callerFg = true;
        }
# anr 堆栈
    appNotResponding:887, AppErrors (com.android.server.am)
    serviceTimeout:3609, ActiveServices (com.android.server.am)
    handleMessage:2190, ActivityManagerService$MainHandler (com.android.server.am)
    dispatchMessage:106, Handler (android.os)
    loop:193, Looper (android.os)
    run:65, HandlerThread (android.os)
    run:44, ServiceThread (com.android.server)