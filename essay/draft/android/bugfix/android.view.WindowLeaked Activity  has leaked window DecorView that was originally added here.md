调用 finish 后的堆栈

    closeAllExceptView:471, WindowManagerGlobal (android.view)
    closeAll:458, WindowManagerGlobal (android.view)
    handleDestroyActivity:4568, ActivityThread (android.app)
    -wrap5:-1, ActivityThread (android.app)
    handleMessage:1683, ActivityThread$H (android.app)
    dispatchMessage:105, Handler (android.os)
    loop:173, Looper (android.os)
    main:6698, ActivityThread (android.app)
    invoke:-1, Method (java.lang.reflect)
    run:240, Zygote$MethodAndArgsCaller (com.android.internal.os)
    main:782, ZygoteInit (com.android.internal.os)

    
最后抛出的异常

    
    public void closeAllExceptView(IBinder token, View view, String who, String what) {
        synchronized (mLock) {
            int count = mViews.size();
            for (int i = 0; i < count; i++) {
                if ((view == null || mViews.get(i) != view)
                        && (token == null || mParams.get(i).token == token)) {
                    ViewRootImpl root = mRoots.get(i);

                    if (who != null) {
                        WindowLeaked leak = new WindowLeaked(
                                what + " " + who + " has leaked window "
                                + root.getView() + " that was originally added here");
                        leak.setStackTrace(root.getLocation().getStackTrace());
                        Log.e(TAG, "", leak);
                    }

                    removeViewLocked(i, false);
                }
            }
        }
    }
    
    形如
    WindowManager: android.view.WindowLeaked: Activity ** has leaked window DecorView@c5aef04[] that was originally added here