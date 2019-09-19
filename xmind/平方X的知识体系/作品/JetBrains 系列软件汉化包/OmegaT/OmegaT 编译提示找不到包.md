Gradle 刷新即可，总是想不起来，每次 rebuild 、 invalidate caches 之后才想起来。

后来提示到不到 org/omegat/Version.properties  
发现路径里面只有

    out/production/classes/
    但是实际却位于
    out/production/resources/org/omegat/Version.properties
    可能是资源没设置对，手动复制过去就好了，以后理解了再来查看为什么