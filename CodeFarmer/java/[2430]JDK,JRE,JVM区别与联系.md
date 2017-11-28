[md]

转自[java_mzd.《JDK,JRE,JVM区别与联系》](http://java-mzd.iteye.com/blog/838514)  

很多朋友可能跟我一样，已经使用JAVA开发很久了，可是对JDK,JRE,JVM这三者的联系与区别，一直都是模模糊糊的。

今天特写此文，来整理下三者的关系。 
# JDK : Java Development ToolKit(Java开发工具包)
JDK是整个JAVA的核心，包括了Java运行环境（Java Runtime Envirnment），一堆Java工具（javac/java/jdb等）和Java基础的类库（即Java API 包括rt.jar）。  
最主流的JDK是Sun公司发布的JDK，除了Sun之外，还有很多公司和组织都开发了属于自己的JDK，例如国外IBM公司开发了属于自己的JDK，国内淘宝也开发了属于自己的JDK，各个组织开发自己的JDK都是为了在某些方面得到一些提高，以适应自己的需求，比如IBM的JDK据说运行效率就比SUN的JDK高的多。但不管怎么说，我们还是需要先把基础的Sun JDK掌握好。  

JDK有以下三种版本：  
J2SE，standard edition，标准版，是我们通常用的一个版本  
J2EE，enterpsise edtion，企业版，使用这种JDK开发J2EE应用程序  
J2ME，micro edtion，主要用于移动设备、嵌入式设备上的java应用程序  
 
我们常常用JDK来代指Java API，Java API是Java的应用程序接口，其实就是前辈们写好的一些java Class，包括一些重要的语言结构以及基本图形，网络和文件I/O等等 ，我们在自己的程序中，调用前辈们写好的这些Class，来作为我们自己开发的一个基础。当然，现在已经有越来越多的性能更好或者功能更强大的第三方类库供我们使用。
 
# JRE:Java  Runtime  Enviromental(java运行时环境)
也就是我们说的JAVA平台，所有的Java程序都要在JRE下才能运行。包括JVM和JAVA核心类库和支持文件。与JDK相比，它不包含开发工具——编译器、调试器和其它工具。
 
# JVM：Java Virtual Mechinal(JAVA虚拟机)
JVM是JRE的一部分，它是一个虚构出来的计算机，是通过在实际的计算机上仿真模拟各种计算机功能来实现的。JVM有自己完善的硬件架构，如处理器、堆栈、寄存器等，还具有相应的指令系统。JVM 的主要工作是解释自己的指令集（即字节码）并映射到本地的 CPU 的指令集或 OS 的系统调用。Java语言是跨平台运行的，其实就是不同的操作系统，使用不同的JVM映射规则，让其与操作系统无关，完成了跨平台性。JVM 对上层的 Java 源文件是不关心的，它关注的只是由源文件生成的类文件（ class file ）。类文件的组成包括 JVM 指令集，符号表以及一些补助信息。
下图很好的表面了JDK,JRE,JVM三者间的关系：  
![](https://pingfangx.github.io/resource/blogx/2430.1.png)  
我们开发的实际情况是：我们利用JDK（调用JAVA API）开发了属于我们自己的JAVA程序后，通过JDK中的编译程序（javac）将我们的文本java文件编译成JAVA字节码，在JRE上运行这些JAVA字节码，JVM解析这些字节码，映射到CPU指令集或OS的系统调用。

[/md]