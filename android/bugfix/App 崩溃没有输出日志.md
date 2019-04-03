一开始崩溃，没有日志输出。
只有

    com.google.android.googlequicksearchbox:search E/NowController: Failed to access data from EntryProvider. ExecutionException.
    java.util.concurrent.ExecutionException: com.google.android.apps.gsa.sidekick.main.h.n: Could not complete scheduled request to refresh entries. ClientErrorCode: 3

但实际该日志不能定位问题。
  
手动找到异常抛出点，是在 Retrofit 请求时 HttpClient 的拦截器中。  
于是问题变成

# 为什么异常没有抛出或输出

## 堆栈
    2 = {StackTraceElement@15253} "android.util.Log.getStackTraceString(Log.java:352)"
    3 = {StackTraceElement@15254} "com.qiyukf.unicorn.j.d$1.uncaughtException(Unknown Source:0)"
    4 = {StackTraceElement@15255} "cn.jiguang.a.a.c.e.uncaughtException(Unknown Source:62)"
    5 = {StackTraceElement@15256} "java.lang.ThreadGroup.uncaughtException(ThreadGroup.java:1068)"
    6 = {StackTraceElement@15257} "java.lang.ThreadGroup.uncaughtException(ThreadGroup.java:1063)"
    7 = {StackTraceElement@15258} "rx.internal.schedulers.ScheduledAction.signalError(ScheduledAction.java:68)"
    8 = {StackTraceElement@15259} "rx.internal.schedulers.ScheduledAction.run(ScheduledAction.java:59)"
    9 = {StackTraceElement@15260} "java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:458)"
    10 = {StackTraceElement@15261} "java.util.concurrent.FutureTask.run(FutureTask.java:266)"
    11 = {StackTraceElement@15262} "java.util.concurrent.ScheduledThreadPoolExecutor$ScheduledFutureTask.run(ScheduledThreadPoolExecutor.java:301)"
    12 = {StackTraceElement@15263} "java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1167)"
    13 = {StackTraceElement@15264} "java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:641)"
    14 = {StackTraceElement@15265} "java.lang.Thread.run(Thread.java:764)"

    
    rx.internal.schedulers.ScheduledAction#run
    
    public void run() {
        try {
            lazySet(Thread.currentThread());
            action.call();
        } catch (OnErrorNotImplementedException e) {
            signalError(new IllegalStateException("Exception thrown on Scheduler.Worker thread. Add `onError` handling.", e));
        } catch (Throwable e) {
            signalError(new IllegalStateException("Fatal Exception thrown on Scheduler.Worker thread.", e));
        } finally {
            unsubscribe();
        }
    }
    rx.internal.schedulers.ScheduledAction#signalError
    
    void signalError(Throwable ie) {
        RxJavaHooks.onError(ie);
        Thread thread = Thread.currentThread();
        thread.getUncaughtExceptionHandler().uncaughtException(thread, ie);
    }
    接下来就是处理异常的流程
    java.lang.ThreadGroup#uncaughtException
    cn.jiguang.a.a.c.e#uncaughtException
    com.qiyukf.unicorn.j.d$1#uncaughtException
    io.rong.imlib.RongIMClient$2#uncaughtException
    com.umeng.analytics.pro.l#uncaughtException
    com.cloudy.common.log.CrashHandler#uncaughtException
    
    public void uncaughtException(Thread thread, Throwable ex) {
        if (!handleException(ex) && mDefaultHandler != null) {
            //如果用户没有处理则让系统默认的异常处理器来处理
            mDefaultHandler.uncaughtException(thread, ex);
        } else {
            try {
                Thread.sleep(3000);
            } catch (InterruptedException e) {
                Log.e(TAG, "error : ", e);
            }
            //退出程序
            android.os.Process.killProcess(android.os.Process.myPid());
            System.exit(1);
        }
    }
    com.cloudy.common.log.CrashHandler#handleException
    
        //保存日志文件
        if (IsWriteToFile) {
            //仅需写权限
            if (PermissionUtils.checkPermission(mContext, android.Manifest.permission.WRITE_EXTERNAL_STORAGE)) {
                saveCrashInfo2File(ex);
            }
        }

    原来是因为没有权限，所以没有执行后续的输出到文件及 log