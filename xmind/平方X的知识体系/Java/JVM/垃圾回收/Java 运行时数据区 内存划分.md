Q:
* 哪些区域随虚拟机，哪些随线程

R:
* 《JVMS 8》2.5
* 《深入理解 Java 虚拟机》2.2

# 程序计数器
存储下一条要执行的字节码指令
* 线程私有
* 没有规定 OutOfMemoryError

# Java 虚拟机栈
栈帧存储局部变量表、操作数栈、动态链接、方法出口等
* 方法栈帧
* StackOverflowError
* 如果允许动态扩展，则会 OutOfMemoryError

# 本地方法栈
没有强制规范，有的虚拟机如 HotSpot 直接就把本地方法栈和虚拟机栈合二为一
* StackOverflowError 和 OutOfMemoryError

# Java 堆
存储对象的实例
* OutOfMemoryError

# 方法区
存放已被虚拟机加载的类信息、常量、静态变量等
* OutOfMemoryError

## 运行时常量池
运行期间也可以将新的常量放入池中，利如 String.intern()

# Q: 基本类型和引用类型保存在哪？
其实不是按数扭类型来分的。
* 如果是常量、静态变量，存放于方法区
* 字符串常量存放于运行时常量池（属于方法区）
* 非静态变量，基本类型可以直接存放于虚拟机栈的局部变量表
* 局部变量表中只能存放对象引用，对象实际存放于堆中