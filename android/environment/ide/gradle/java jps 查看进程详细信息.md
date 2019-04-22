有多个 java 进程，如何知道是哪个程序启动的呢。

使用 jps 即可。

    >jps
    6304 KotlinCompileDaemon
    8324 GradleDaemon
    8980
    5704 Jps
    10044 GradleDaemon
    
    还可以 -v 查看启动参数