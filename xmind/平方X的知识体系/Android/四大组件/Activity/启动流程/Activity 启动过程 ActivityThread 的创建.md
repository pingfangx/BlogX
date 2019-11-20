[Android应用程序启动过程源代码分析 - 老罗的Android之旅 - CSDN博客](https://blog.csdn.net/luoshengyang/article/details/6689748)

[Activity启动过程分析 - 简书](https://www.jianshu.com/p/13b07beacb1f)


    execStartActivity:1673, Instrumentation (android.app)
            int result = ActivityManager.getService()
                .startActivity(whoThread, who.getBasePackageName(), intent,
                        intent.resolveTypeIfNeeded(who.getContentResolver()),
                        token, target != null ? target.mEmbeddedID : null,
                        requestCode, 0, null, options);
    startActivityForResult:4586, Activity (android.app)
    startActivityForResult:676, FragmentActivity (androidx.fragment.app)
    startActivityForResult:4544, Activity (android.app)
    startActivityForResult:663, FragmentActivity (androidx.fragment.app)
    startActivity:4905, Activity (android.app)
    startActivity:4873, Activity (android.app)
    
    接下来转到
    com.android.server.am.ActivityManagerService#startActivity
    com.android.server.am.ActivityStarter#execute
    ...
    com.android.server.am.ActivityStarter#startActivityUnchecked
        启动模式在这里生效
    com.android.server.am.ActivityStackSupervisor#resumeFocusedStackTopActivityLocked(ActivityStack, ActivityRecord, android.app.ActivityOptions)
    com.android.server.am.ActivityStack#resumeTopActivityUncheckedLocked
    com.android.server.am.ActivityStack#resumeTopActivityInnerLocked
    
    这里好像分开了 ，一
        if (mResumedActivity != null) {
            if (DEBUG_STATES) Slog.d(TAG_STATES,
                    "resumeTopActivityLocked: Pausing " + mResumedActivity);
            pausing |= startPausingLocked(userLeaving, false, next, false);
        }
    二
        com.android.server.am.ActivityStackSupervisor#startSpecificActivityLocked
        
    一
    com.android.server.am.ActivityStack#startPausingLocked
        //改成这样了吗
        mService.getLifecycleManager().scheduleTransaction(prev.app.thread, prev.appToken,
                PauseActivityItem.obtain(prev.finishing, userLeaving,
                        prev.configChangeFlags, pauseImmediately));
    com.android.server.am.ClientLifecycleManager#scheduleTransaction(IApplicationThread, android.os.IBinder, ActivityLifecycleItem)
    com.android.server.am.ClientLifecycleManager#scheduleTransaction(ClientTransaction)
        transaction.schedule();
    android.app.servertransaction.ClientTransaction#schedule
    android.app.ActivityThread.ApplicationThread#scheduleTransaction
    android.app.ClientTransactionHandler#scheduleTransaction
    android.app.ClientTransactionHandler#sendMessage
    android.app.ActivityThread.H#handleMessage
    android.app.servertransaction.TransactionExecutor#execute
    android.app.servertransaction.TransactionExecutor#executeLifecycleState
    android.app.servertransaction.BaseClientRequest#execute
    android.app.servertransaction.PauseActivityItem#execute
        client.handlePauseActivity(token, mFinished, mUserLeaving, mConfigChanges, pendingActions,
                "PAUSE_ACTIVITY_ITEM");
    android.app.ActivityThread#handlePauseActivity
    
    暂停
    android.app.ActivityThread#performPauseActivity(android.app.ActivityThread.ActivityClientRecord, boolean, java.lang.String, PendingTransactionActions)
    android.app.ActivityThread#performPauseActivityIfNeeded
        mInstrumentation.callActivityOnPause(r.activity);
    android.app.Instrumentation#callActivityOnPause
        activity.performPause();
    android.app.Activity#performPause
    
    
    ...迷失
    android.app.ActivityThread#handleLaunchActivity
    android.app.ActivityThread#performLaunchActivity
        创建 Activity 并 attach onCreate 等
    android.app.Instrumentation#callActivityOnCreate(android.app.Activity, android.os.Bundle, android.os.PersistableBundle)
    android.app.Activity#performCreate(android.os.Bundle, android.os.PersistableBundle)
    
    二
    com.android.server.am.ActivityStackSupervisor#startSpecificActivityLocked
        
        mService.startProcessLocked(r.processName, r.info.applicationInfo, true, 0,
                "activity", r.intent.getComponent(), false, false, true);
                
    学习的关键是 startProcessLocked
    com.android.server.am.ActivityManagerService#startProcessLocked(java.lang.String, android.content.pm.ApplicationInfo, boolean, int, java.lang.String, android.content.ComponentName, boolean, boolean, boolean)
    
    com.android.server.am.ActivityManagerService#startProcessLocked(ProcessRecord, java.lang.String, java.lang.String, boolean, java.lang.String)
    
            final String entryPoint = "android.app.ActivityThread";

            return startProcessLocked(hostingType, hostingNameStr, entryPoint, app, uid, gids,
                    runtimeFlags, mountExternal, seInfo, requiredAbi, instructionSet, invokeWith,
                    startTime);
    
    com.android.server.am.ActivityManagerService#startProcess
        
                startResult = Process.start(entryPoint,
                        app.processName, uid, uid, gids, runtimeFlags, mountExternal,
                        app.info.targetSdkVersion, seInfo, requiredAbi, instructionSet,
                        app.info.dataDir, invokeWith,
                        new String[] {PROC_START_SEQ_IDENT + app.startSeq});
                        
    android.os.Process#start
    中间再省略 n 步，然后又到达了 ActivityThread.main
    
    
    
# android.app.ActivityThread#main

        Looper.prepareMainLooper();
        ...
        ActivityThread thread = new ActivityThread();
        thread.attach(false, startSeq);

        if (sMainThreadHandler == null) {
            sMainThreadHandler = thread.getHandler();
        }

        if (false) {
            Looper.myLooper().setMessageLogging(new
                    LogPrinter(Log.DEBUG, "ActivityThread"));
        }

        // End of event ActivityThreadMain.
        Trace.traceEnd(Trace.TRACE_TAG_ACTIVITY_MANAGER);
        Looper.loop();
        
接下来就有了 Looper