只有 Java 层的一部分，更多详见

[Input系统—ANR原理分析 - Gityuan博客 | 袁辉辉的技术博客](http://gityuan.com/2017/01/01/input-anr/)


# InputManagerService 转到 ActivityManagerService
    inputDispatchingTimedOut:13919, ActivityManagerService (com.android.server.am)
    keyDispatchingTimedOut:2146, ActivityRecord (com.android.server.am)
    keyDispatchingTimedOut:753, AppWindowContainerController (com.android.server.wm)
    notifyANR:275, InputMonitor (com.android.server.wm)
    notifyANR:1820, InputManagerService (com.android.server.input)

    com.android.server.input.InputManagerService#notifyANR
    // Native callback.
    private long notifyANR(InputApplicationHandle inputApplicationHandle,
            InputWindowHandle inputWindowHandle, String reason) {
        return mWindowManagerCallbacks.notifyANR(
                inputApplicationHandle, inputWindowHandle, reason);
    }
    
    com.android.server.am.ActivityManagerService#inputDispatchingTimedOut(ProcessRecord, ActivityRecord, ActivityRecord, boolean, java.lang.String)
            mHandler.post(new Runnable() {
                @Override
                public void run() {
                    mAppErrors.appNotResponding(proc, activity, parent, aboveSystem, annotation);
                }
            });
            
    com.android.server.am.AppErrors#appNotResponding
            // Bring up the infamous App Not Responding dialog
            Message msg = Message.obtain();
            msg.what = ActivityManagerService.SHOW_NOT_RESPONDING_UI_MSG;
            msg.obj = new AppNotRespondingDialog.Data(app, activity, aboveSystem);

            mService.mUiHandler.sendMessage(msg);


    com.android.server.am.AppErrors#handleShowAnrUi
    handleShowAnrUi:1112, AppErrors (com.android.server.am)
    handleMessage:2036, ActivityManagerService$UiHandler (com.android.server.am)
    dispatchMessage:106, Handler (android.os)
    loop:193, Looper (android.os)
    run:65, HandlerThread (android.os)
    run:44, ServiceThread (com.android.server)
    run:43, UiThread (com.android.server)