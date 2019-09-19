Q:
* 可以配置哪些，分别表示什么
* 哪里可以查到完成可配置内容

[Java HotSpot VM Options](https://www.oracle.com/technetwork/java/javase/tech/vmoptions-jsp-140102.html)  
列出了部分 VM Options

[Why do JVM arguments start with “-D”?](https://stackoverflow.com/a/44745321)  
解释了为什么以 -D 开头，同时给出了链接

# [Standard Options](https://docs.oracle.com/javase/8/docs/technotes/tools/windows/java.html#BABDJJFI)
在该链接下有相关选项的意思
> These are the most commonly used options that are supported by all implementations of the JVM.

## -Dproperty=value
> Sets a system property value. The property variable is a string with no spaces that represents the name of the property. The value variable is a string that represents the value of the property. If value is a string with spaces, then enclose it in quotation marks (for example -Dfoo="foo bar").

## -javaagent:jarpath[=options]
Loads the specified Java programming language agent. For more information about instrumenting Java applications, see the java.lang.instrument package description in the Java API documentation at http://docs.oracle.com/javase/8/docs/api/java/lang/instrument/package-summary.html



# 解释部分常用设置
## -Duser.name
## -javaagent
## -Duser.language=zh
## -Duser.region=CN

## -Xmssize
    Sets the initial size (in bytes) of the heap. This value must be a multiple of 1024 and greater than 1 MB. Append the letter k or K to indicate kilobytes, m or M to indicate megabytes, g or G to indicate gigabytes.

    The following examples show how to set the size of allocated memory to 6 MB using various units:

    -Xms6291456
    -Xms6144k
    -Xms6m
    If you do not set this option, then the initial size will be set as the sum of the sizes allocated for the old generation and the young generation. The initial size of the heap for the young generation can be set using the -Xmn option or the -XX:NewSize option.

## -Xmxsize
    Specifies the maximum size (in bytes) of the memory allocation pool in bytes. This value must be a multiple of 1024 and greater than 2 MB. Append the letter k or K to indicate kilobytes, m or M to indicate megabytes, g or G to indicate gigabytes. The default value is chosen at runtime based on system configuration. For server deployments, -Xms and -Xmx are often set to the same value. See the section "Ergonomics" in Java SE HotSpot Virtual Machine Garbage Collection Tuning Guide at http://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/index.html.

    The following examples show how to set the maximum allowed size of allocated memory to 80 MB using various units:

    -Xmx83886080
    -Xmx81920k
    -Xmx80m
    The -Xmx option is equivalent to -XX:MaxHeapSize.
## -XX:MaxMetaspaceSize=size
    Sets the maximum amount of native memory that can be allocated for class metadata. By default, the size is not limited. The amount of metadata for an application depends on the application itself, other running applications, and the amount of memory available on the system.

    The following example shows how to set the maximum class metadata size to 256 MB:

    -XX:MaxMetaspaceSize=256m
    
## -XX:+HeapDumpOnOutOfMemoryError
    Enables the dumping of the Java heap to a file in the current directory by using the heap profiler (HPROF) when a java.lang.OutOfMemoryError exception is thrown. You can explicitly set the heap dump file path and name using the -XX:HeapDumpPath option. By default, this option is disabled and the heap is not dumped when an OutOfMemoryError exception is thrown.