类型|前台|后台|声明位置
-|-|-|-
Service|20|200|ActiveServices#SERVICE_TIMEOUT
BroadcastReceiver|10|60|ActivityManagerService#BROADCAST_FG_TIMEOUT
ContentProvider|10||ActivityManagerService#CONTENT_PROVIDER_PUBLISH_TIMEOUT
Input|5||? ActivityManagerService#KEY_DISPATCHING_TIMEOUT

# 总结

服务是后台服务，所以是最长的，20 和 200，并且是在 ActiveServices 中声明的，其余的在 AMS

输入是最短的，5，不过输入要在下一个输入时才判断

广播接收器和内容提供者都是 10，后台广播是 60

# 前后台判断

服务和广播是区分前后台的，服务前后台的判断是判断服务发起者的进程，广播在判断 intent 中的 Flag


## Service 前后台的判断
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
        
    // Activity manager's version of Process.THREAD_GROUP_BG_NONINTERACTIVE
    static final int SCHED_GROUP_BACKGROUND = 0;
    
## BroadcastReceiver 前后台的判断
    com.android.server.am.ActivityManagerService#broadcastQueueForIntent
    BroadcastQueue broadcastQueueForIntent(Intent intent) {
        final boolean isFg = (intent.getFlags() & Intent.FLAG_RECEIVER_FOREGROUND) != 0;
        if (DEBUG_BROADCAST_BACKGROUND) Slog.i(TAG_BROADCAST,
                "Broadcast intent " + intent + " on "
                + (isFg ? "foreground" : "background") + " queue");
        return (isFg) ? mFgBroadcastQueue : mBgBroadcastQueue;
    }