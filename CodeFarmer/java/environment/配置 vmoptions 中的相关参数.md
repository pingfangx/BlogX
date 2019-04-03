Q:
* 可以配置哪些，分别表示什么
* 哪里可以查到完成可配置内容

[Java HotSpot VM Options](https://www.oracle.com/technetwork/java/javase/tech/vmoptions-jsp-140102.html)  
列出了部分 VM Options

[Why do JVM arguments start with “-D”?](https://stackoverflow.com/a/44745321)  
解释了为什么以 -D 开头，同时给出了链接

# [Standard Options](https://docs.oracle.com/javase/8/docs/technotes/tools/windows/java.html#BABDJJFI)
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