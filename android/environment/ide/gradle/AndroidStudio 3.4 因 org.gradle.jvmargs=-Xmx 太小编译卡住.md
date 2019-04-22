升级后编译花费较长时间，且 CPU 占满，还会失败。


同时有部分错误

    GC overhead limit exceeded
    
    以及
    Expiring Daemon because JVM Tenured space is exhausted
    Daemon will be stopped at the end of the build after running out of JVM memory
    
# 尝试增大 vmoptions 中的 -Xmx
-Xmx4G  
无效，该选项只是针对 AndroidStudio 的，我们需要的是为 gradle 配置。

# 排查步骤
* 降回 3.3.2 成功
* 测试发现修改构建工具版本无效，但是修改 gradle 版本有效
* 5.1.1 失败，5.4 成功，说明与 gradle 版本有关
* 搜索 GC overhead limit exceeded 得到方法

[解决Android Studio出现GC overhead limit exceeded](https://www.cnblogs.com/jeffen/p/7607239.html)

需要修改 gradle.properties 中的

    org.gradle.jvmargs=-Xmx4096m
    
    或者修改 build.gradle 中 android 中添加
    dexOptions {
        javaMaxHeapSize "4g"
    }
    
# org.gradle.jvmargs=-Xmx4G
为什么以前不需要配置，升级后需要配置呢，文件中有这样的注释

    ## Project-wide Gradle settings.
    #
    # For more details on how to configure your build environment visit
    # http://www.gradle.org/docs/current/userguide/build_environment.html
    #
    # Specifies the JVM arguments used for the daemon process.
    # The setting is particularly useful for tweaking memory settings.
    # Default value: -Xmx10248m -XX:MaxPermSize=256m
    # org.gradle.jvmargs=-Xmx2048m -XX:MaxPermSize=512m -XX:+HeapDumpOnOutOfMemoryError -Dfile.encoding=UTF-8
    
    但是地址打开，说明写的是
    The org.gradle.jvmargs Gradle property controls the VM running the build. It defaults to -Xmx512m "-XX:MaxMetaspaceSize=256m"
    org.gradle.jvmargs=-Xmx2g -XX:MaxMetaspaceSize=512m -XX:+HeapDumpOnOutOfMemoryError -Dfile.encoding=UTF-8
    
    难道是默认值发生了变化
    3.4 新建一个项目，gradle.properties 中默认为
    # Specifies the JVM arguments used for the daemon process.
    # The setting is particularly useful for tweaking memory settings.
    org.gradle.jvmargs=-Xmx1536m
    
    推测可能就是某个版本的 gradle 修改这个默认值，项目中一直没有指定。  
    导致在 gradle-5.1.1 或某些版本中使用默认值太小造成错误。
    
    
# 验证
学习了 jps 之后，可以验证上面的推测

    >jps -v
    不进行配置，以默认配置运行：
    9584 GradleDaemon -XX:MaxMetaspaceSize=256m -XX:+HeapDumpOnOutOfMemoryError -Xms256m -Xmx512m -Dfile.encoding=GBK -Duser.country=CN -Duser.language=zh -Duser.variant
    
    手动配置后运行：
    org.gradle.jvmargs=-Xmx2g -XX:MaxMetaspaceSize=1g
    2700 GradleDaemon -XX:MaxMetaspaceSize=1g -Xmx2g -Dfile.encoding=GBK -Duser.country=CN -Duser.language=zh -Duser.variant
    
    相关参数的含义参见
    《配置 vmoptions 中的相关 jvm 参数》