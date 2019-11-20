R:
* [从源码解析-Android系统启动流程概述 init进程zygote进程SystemServer进程启动流程 - Mango先生的博客 - CSDN博客](https://blog.csdn.net/qq_30993595/article/details/82714409#ZygoteInitmain_1192)

S:
* init 启动 Zygote，Zygote 加载 ZygoteInit 类，ZygoteInit 启动 SystemServer
* SystemServer 会启动各种服务
* SystemServer 启动了 Launcher
* Launcher 可以启动其他 app

# 系统启动
只是简单学习

* Loader
* Linux Kernel
* Native  
init 进程
* Framework  
Zygote 进程，加载 ZygoteInit 类  
System Server 管理整个 Java Framework
* Application
Zygote 孵化的第一个 App 进程是 Launcher


# Zygote
> 在Android中，zygote是整个系统创建新进程的核心进程。在init进程启动后就会创建zygote进程；zygote进程在内部会先启动Dalvik虚拟机，继而加载一些必要的系统资源和系统类，最后进入一种监听状态。在之后的运作中，当其他系统模块（比如AMS）希望创建新进程时，只需向zygote进程发出请求，zygote进程监听到该请求后，会相应地fork出新的进程，于是这个新进程在初生之时，就先天具有了自己的Dalvik虚拟机以及系统资源

# main
    if (zygote) {
        runtime.start("com.android.internal.os.ZygoteInit", args, zygote);
    } else if (className) {
        runtime.start("com.android.internal.os.RuntimeInit", args, zygote);
    } else {
        //没有指定类名或zygote，参数错误
        return 10;
    }
    
> 根据传入参数的不同可以有两种启动方式，一个是 “com.android.internal.os.RuntimeInit”, 另一个是 ”com.android.internal.os.ZygoteInit", 对应RuntimeInit 和 ZygoteInit 两个类， 这两个类的主要区别在于Java端，可以明显看出，ZygoteInit 相比 RuntimeInit 多做了很多事情，比如说 “preload", “gc” 等等。但是在Native端，他们都做了相同的事， startVM() 和 startReg()


AndroidRuntime::start 调用 ZygoteInit.main

# ZygoteInit.main


    不确定流程是否正确，简单查看一下
    com.android.internal.os.ZygoteInit#main
    
            if (startSystemServer) {
                Runnable r = forkSystemServer(abiList, socketName, zygoteServer);

                // {@code r == null} in the parent (zygote) process, and {@code r != null} in the
                // child (system_server) process.
                if (r != null) {
                    r.run();
                    return;
                }
            }
    com.android.internal.os.ZygoteInit#forkSystemServer
        return handleSystemServerProcess(parsedArgs);
    com.android.internal.os.ZygoteInit#handleSystemServerProcess
        return ZygoteInit.zygoteInit(parsedArgs.targetSdkVersion, parsedArgs.remainingArgs, cl);
    com.android.internal.os.ZygoteInit#zygoteInit
        return RuntimeInit.applicationInit(targetSdkVersion, argv, classLoader);
    com.android.internal.os.RuntimeInit#applicationInit
        return findStaticMain(args.startClass, args.startArgs, classLoader);
    com.android.internal.os.RuntimeInit#findStaticMain
        return new MethodAndArgsCaller(m, argv);
    com.android.internal.os.RuntimeInit.MethodAndArgsCaller#run
        mMethod.invoke(null, new Object[] { mArgs });
        
    所以最后执行方法就是 com.android.server.SystemServer#main
    com.android.server.SystemServer#run
        ...
            Looper.prepareMainLooper();
        ...
            // Initialize the system context.
            createSystemContext();
        ...
        
        // Start services.
        try {
            traceBeginAndSlog("StartServices");
            startBootstrapServices();
            startCoreServices();
            startOtherServices();
            SystemServerInitThreadPool.shutdown();
        } catch (Throwable ex) {
            Slog.e("System", "******************************************");
            Slog.e("System", "************ Failure starting system services", ex);
            throw ex;
        } finally {
            traceEnd();
        }
        
    com.android.server.SystemServer#createSystemContext
        ActivityThread activityThread = ActivityThread.systemMain();
    android.app.ActivityThread#systemMain
        ActivityThread thread = new ActivityThread();
        thread.attach(true, 0);
        
    android.app.ActivityThread#attach
                mInstrumentation = new Instrumentation();
                mInstrumentation.basicInit(this);
                ContextImpl context = ContextImpl.createAppContext(
                        this, getSystemContext().mPackageInfo);
                mInitialApplication = context.mPackageInfo.makeApplication(true, null);
                mInitialApplication.onCreate();