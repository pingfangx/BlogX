[安卓应用无响应，你真的了解吗？](https://mp.weixin.qq.com/s?__biz=MzI5NjE3NzA4Mg==&mid=2650359967&idx=1&sn=7d59915254a6a346c4d5eda369141eb6&chksm=f445b44ac3323d5c458405f6500d50e875fd374e629bbc7158a1d7105a581766a28706444764&mpshare=1&scene=1&srcid=&pass_ticket=L9MQbF6uhaOTmPU7yqV4H7YT2ItYKOL0RacATooz4V7SEWvXnButGHwaERsWeKsp#rd)

[Android Broadcast广播机制分析 - Gityuan博客 | 袁辉辉的技术博客](http://gityuan.com/2016/06/04/broadcast-receiver/)

    com.android.server.am.ActivityManagerService#finishReceiver
    
            synchronized(this) {
                BroadcastQueue queue = (flags & Intent.FLAG_RECEIVER_FOREGROUND) != 0
                        ? mFgBroadcastQueue : mBgBroadcastQueue;
                r = queue.getMatchingOrderedReceiver(who);
                if (r != null) {
                    doNext = r.queue.finishReceiverLocked(r, resultCode,
                        resultData, resultExtras, resultAbort, true);
                }
                if (doNext) {
                    r.queue.processNextBroadcastLocked(/*fromMsg=*/ false, /*skipOomAdj=*/ true);
                }
                // updateOomAdjLocked() will be done here
                trimApplicationsLocked();
            }
    
    // How long we allow a receiver to run before giving up on it.
    static final int BROADCAST_FG_TIMEOUT = 10*1000;
    static final int BROADCAST_BG_TIMEOUT = 60*1000;
    
    
        mFgBroadcastQueue = new BroadcastQueue(this, mHandler,
                "foreground", BROADCAST_FG_TIMEOUT, false);
        mBgBroadcastQueue = new BroadcastQueue(this, mHandler,
                "background", BROADCAST_BG_TIMEOUT, true);

# 前后台判断
    com.android.server.am.ActivityManagerService#broadcastQueueForIntent
    
    BroadcastQueue broadcastQueueForIntent(Intent intent) {
        final boolean isFg = (intent.getFlags() & Intent.FLAG_RECEIVER_FOREGROUND) != 0;
        if (DEBUG_BROADCAST_BACKGROUND) Slog.i(TAG_BROADCAST,
                "Broadcast intent " + intent + " on "
                + (isFg ? "foreground" : "background") + " queue");
        return (isFg) ? mFgBroadcastQueue : mBgBroadcastQueue;
    }