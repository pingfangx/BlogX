结合之前的 《启动流程与 IPC》

经过比较我们知道，
# android.app.servertransaction.TransactionExecutor#executeLifecycleState

        // Execute the final transition with proper parameters.
        lifecycleItem.execute(mTransactionHandler, token, mPendingActions);
        lifecycleItem.postExecute(mTransactionHandler, token, mPendingActions);

所以 execute 直接调用 ClientTransactionHandler 的相关方法

ActivityThread extends ClientTransactionHandler

所以直接调用相关生命周期方法

postExecute 则与 AMS 通信去了。

# onPause
    onPause:1731, Activity (android.app)
    onPause:418, FragmentActivity (androidx.fragment.app)
    onPause:43, BaseLifecycleActivity (com.pingfangx.demo.androidx.activity.android.app.activity)
    performPause:7329, Activity (android.app)
    callActivityOnPause:1465, Instrumentation (android.app)
    performPauseActivityIfNeeded:4021, ActivityThread (android.app)
    performPauseActivity:3986, ActivityThread (android.app)
    handlePauseActivity:3938, ActivityThread (android.app)
    execute:45, PauseActivityItem (android.app.servertransaction)
    executeLifecycleState:145, TransactionExecutor (android.app.servertransaction)
    execute:70, TransactionExecutor (android.app.servertransaction)
    handleMessage:1808, ActivityThread$H (android.app)
    dispatchMessage:106, Handler (android.os)
    loop:193, Looper (android.os)
    main:6669, ActivityThread (android.app)
    invoke:-1, Method (java.lang.reflect)
    run:493, RuntimeInit$MethodAndArgsCaller (com.android.internal.os)
    main:858, ZygoteInit (com.android.internal.os)

    
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
    
# onCreate

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