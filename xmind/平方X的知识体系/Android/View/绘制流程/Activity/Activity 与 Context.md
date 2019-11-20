R:
* [Android应用程序窗口（Activity）的运行上下文环境（Context）的创建过程分析 - 老罗的Android之旅 - CSDN博客](https://blog.csdn.net/luoshengyang/article/details/8201936)
* Context 创建时序图.puml

# 栈
    attachBaseContext:71, ContextWrapper (android.content)
    attachBaseContext:80, ContextThemeWrapper (android.view)
    attachBaseContext:981, Activity (android.app)
    attachBaseContext:97, AppCompatActivity (androidx.appcompat.app)
    attach:7051, Activity (android.app)
    performLaunchActivity:2873, ActivityThread (android.app)
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
