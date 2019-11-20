[Android应用程序内部启动Activity过程（startActivity）的源代码分析 - 老罗的Android之旅 - CSDN博客](https://blog.csdn.net/Luoshengyang/article/details/6703247)
[Activity启动过程分析 - 简书](https://www.jianshu.com/p/13b07beacb1f)

# 老罗的总结
> 一. Step 1 - Step 10：应用程序的MainActivity通过Binder进程间通信机制通知ActivityManagerService，它要启动一个新的Activity；

> 二. Step 11 - Step 15：ActivityManagerService通过Binder进程间通信机制通知MainActivity进入Paused状态；

> 三. Step 16 - Step 22：MainActivity通过Binder进程间通信机制通知ActivityManagerService，它已经准备就绪进入Paused状态，于是ActivityManagerService就准备要在MainActivity所在的进程和任务中启动新的Activity了；

> 四. Step 23 - Step 29：ActivityManagerService通过Binder进程间通信机制通知MainActivity所在的ActivityThread，现在一切准备就绪，它可以真正执行Activity的启动操作了。

# Activity -> AMS 通知要启动一个 Activity
    obtain:385, Parcel (android.os)
    startActivity:3721, IActivityManager$Stub$Proxy (android.app)
    execStartActivity:1669, Instrumentation (android.app)
    startActivityForResult:4586, Activity (android.app)
    startActivityForResult:676, FragmentActivity (androidx.fragment.app)
    startActivityForResult:4544, Activity (android.app)
    startActivityForResult:663, FragmentActivity (androidx.fragment.app)
    startActivity:4905, Activity (android.app)
    startActivity:4873, Activity (android.app)
    internalStartActivity:119, AnkoInternals (org.jetbrains.anko.internals)
    onClick:31, BaseLifecycleActivity$initViews$$inlined$addButton$1 (com.pingfangx.demo.androidx.activity.android.app.activity)
    performClick:6597, View (android.view)
    performClickInternal:6574, View (android.view)
    access$3100:778, View (android.view)
    run:25885, View$PerformClick (android.view)
    handleCallback:873, Handler (android.os)
    dispatchMessage:99, Handler (android.os)
    loop:193, Looper (android.os)
    main:6669, ActivityThread (android.app)
    invoke:-1, Method (java.lang.reflect)
    run:493, RuntimeInit$MethodAndArgsCaller (com.android.internal.os)
    main:858, ZygoteInit (com.android.internal.os)
    
    学习时可在此处下断
    android.app.Instrumentation#execStartActivity(android.content.Context, android.os.IBinder, android.os.IBinder, android.app.Activity, android.content.Intent, int, android.os.Bundle)
    
            int result = ActivityManager.getService()
                .startActivity(whoThread, who.getBasePackageName(), intent,
                        intent.resolveTypeIfNeeded(who.getContentResolver()),
                        token, target != null ? target.mEmbeddedID : null,
                        requestCode, 0, null, options);
            checkStartActivityResult(result, intent);
            
    public static IActivityManager getService() {
        return IActivityManagerSingleton.get();
    }

    private static final Singleton<IActivityManager> IActivityManagerSingleton =
            new Singleton<IActivityManager>() {
                @Override
                protected IActivityManager create() {
                    final IBinder b = ServiceManager.getService(Context.ACTIVITY_SERVICE);
                    final IActivityManager am = IActivityManager.Stub.asInterface(b);
                    return am;
                }
            };

    这里的 ActivityManager.getService()
    返回的是 android.app.IActivityManager$Stub$Proxy
    通过进程间通信，转了 ActivityManagerService 
    
    public class ActivityManagerService extends IActivityManager.Stub
            implements Watchdog.Monitor, BatteryStatsImpl.BatteryCallback {
            
# AMS -> ApplicationThread-> ActivityThread 通知暂停
    断点下到 android.app.servertransaction.ClientTransaction#schedule
    或 com.android.server.am.ActivityStack#startPausingLocked
    
    obtain:385, Parcel (android.os)
    scheduleTransaction:1767, IApplicationThread$Stub$Proxy (android.app)
    schedule:129, ClientTransaction (android.app.servertransaction)
    scheduleTransaction:47, ClientLifecycleManager (com.android.server.am)
    scheduleTransaction:69, ClientLifecycleManager (com.android.server.am)
    startPausingLocked:1463, ActivityStack (com.android.server.am)
    resumeTopActivityInnerLocked:2455, ActivityStack (com.android.server.am)
    resumeTopActivityUncheckedLocked:2302, ActivityStack (com.android.server.am)
    resumeFocusedStackTopActivityLocked:2229, ActivityStackSupervisor (com.android.server.am)
    startActivityUnchecked:1466, ActivityStarter (com.android.server.am)
    startActivity:1200, ActivityStarter (com.android.server.am)
    startActivity:868, ActivityStarter (com.android.server.am)
    startActivity:544, ActivityStarter (com.android.server.am)
    startActivityMayWait:1099, ActivityStarter (com.android.server.am)
    execute:486, ActivityStarter (com.android.server.am)
    startActivityAsUser:5120, ActivityManagerService (com.android.server.am)
    startActivityAsUser:5094, ActivityManagerService (com.android.server.am)
    startActivity:5085, ActivityManagerService (com.android.server.am)
    onTransact$startActivity$:10084, IActivityManager$Stub (android.app)
    onTransact:122, IActivityManager$Stub (android.app)
    onTransact:3291, ActivityManagerService (com.android.server.am)
    execTransact:731, Binder (android.os)
    
    android.app.ActivityThread.ApplicationThread
    
    private class ApplicationThread extends IApplicationThread.Stub {}
    
    

# ActivityThread -> AMS 通知已进入暂停状态

    ApplicationThread -> ActivityThread
    sendMessage:2757, ActivityThread (android.app)
    scheduleTransaction:45, ClientTransactionHandler (android.app)
    scheduleTransaction:1540, ActivityThread$ApplicationThread (android.app)
    onTransact:822, IApplicationThread$Stub (android.app)
    execTransact:731, Binder (android.os)
    
    ActivityThread -> AMS
    activityPaused:3987, IActivityManager$Stub$Proxy (android.app)
    postExecute:63, PauseActivityItem (android.app.servertransaction)
    executeLifecycleState:146, TransactionExecutor (android.app.servertransaction)
    execute:70, TransactionExecutor (android.app.servertransaction)
    handleMessage:1808, ActivityThread$H (android.app)
    dispatchMessage:106, Handler (android.os)
    loop:193, Looper (android.os)
    main:6669, ActivityThread (android.app)
    invoke:-1, Method (java.lang.reflect)
    run:493, RuntimeInit$MethodAndArgsCaller (com.android.internal.os)
    main:858, ZygoteInit (com.android.internal.os)
    
    android.app.servertransaction.PauseActivityItem#postExecute
    
    public void postExecute(ClientTransactionHandler client, IBinder token,
            PendingTransactionActions pendingActions) {
        if (mDontReport) {
            return;
        }
        try {
            // TODO(lifecycler): Use interface callback instead of AMS.
            ActivityManager.getService().activityPaused(token);
        } catch (RemoteException ex) {
            throw ex.rethrowFromSystemServer();
        }
    }
    
    

# AMS -> ActivityThread 通知启动 Activity
    scheduleTransaction:1767, IApplicationThread$Stub$Proxy (android.app)
    schedule:129, ClientTransaction (android.app.servertransaction)
    scheduleTransaction:47, ClientLifecycleManager (com.android.server.am)
    realStartActivityLocked:1545, ActivityStackSupervisor (com.android.server.am)
    startSpecificActivityLocked:1704, ActivityStackSupervisor (com.android.server.am)
    resumeTopActivityInnerLocked:2764, ActivityStack (com.android.server.am)
    resumeTopActivityUncheckedLocked:2302, ActivityStack (com.android.server.am)
    resumeFocusedStackTopActivityLocked:2229, ActivityStackSupervisor (com.android.server.am)
    completePauseLocked:1606, ActivityStack (com.android.server.am)
    activityPausedLocked:1530, ActivityStack (com.android.server.am)
    activityPaused:8161, ActivityManagerService (com.android.server.am)
    onTransact:224, IActivityManager$Stub (android.app)
    onTransact:3291, ActivityManagerService (com.android.server.am)
    execTransact:731, Binder (android.os)
    
# ActivityThread 启动 Activity

    ApplicationThread -> ActivityThread
    sendMessage:2757, ActivityThread (android.app)
    scheduleTransaction:45, ClientTransactionHandler (android.app)
    scheduleTransaction:1540, ActivityThread$ApplicationThread (android.app)
    onTransact:822, IApplicationThread$Stub (android.app)
    execTransact:731, Binder (android.os)
    
    
    onCreate:1024, Activity (android.app)
    onCreate:147, ComponentActivity (androidx.activity)
    onCreate:313, FragmentActivity (androidx.fragment.app)
    onCreate:106, AppCompatActivity (androidx.appcompat.app)
    onCreate:25, BaseActivity (com.pingfangx.demo.androidx.base)
    onCreate:28, BaseLifecycleActivity (com.pingfangx.demo.androidx.activity.android.app.activity)
    performCreate:7136, Activity (android.app)
    performCreate:7127, Activity (android.app)
    callActivityOnCreate:1271, Instrumentation (android.app)
    performLaunchActivity:2893, ActivityThread (android.app)
    handleLaunchActivity:3048, ActivityThread (android.app)
    execute:78, LaunchActivityItem (android.app.servertransaction)
    executeCallbacks:108, TransactionExecutor (android.app.servertransaction)
    execute:68, TransactionExecutor (android.app.servertransaction)
    handleMessage:1808, ActivityThread$H (android.app)
    dispatchMessage:106, Handler (android.os)
    loop:193, Looper (android.os)
    main:6669, ActivityThread (android.app)
    invoke:-1, Method (java.lang.reflect)
    run:493, RuntimeInit$MethodAndArgsCaller (com.android.internal.os)
    main:858, ZygoteInit (com.android.internal.os)