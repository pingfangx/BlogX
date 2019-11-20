javac A.java 编译
java -cp . A 运行

# -cp . 
指定当前目录为类路径，不指定也可以

# java A 不需要指定 .class
是类名不是文件名

# A.java 中不要声明包
如果声明了包，那么就无法找到主类。

如果要声明包，那么需要在包的根目录，并指定类的包名
如

`java com.pingfangx.demo.A`

# 指定编码
如果需要指定，则 -encoding utf-8