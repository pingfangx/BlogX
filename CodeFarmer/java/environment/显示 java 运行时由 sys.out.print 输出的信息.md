# 查找 log
失败，没有

# 控制台
[What happens to “System.out.println()” in executable jar?](https://stackoverflow.com/a/28477682)

提到了 [如何启用和查看 Java 控制台？](https://java.com/zh_CN/download/help/javaconsole.xml)

测试没用，好像是因为。

    https://blog.csdn.net/cuser_online/article/details/6219482 
    java.exe与java.exe有一个最基本的区别，用鼠标双击启动程序时，双击JAVA.EXE会

    弹出一个黑DOS窗口一闪而过；而双击JAVAW.EXE则没有任何变化。
    其根本原因是：JAVA.EXE是命令行程序，
    程序入口是C语言的main()函数（不是java的 public static void main）；而

    JAVAW.EXE是WINDOWS窗口程序，
    程序入口是C语言的WinMain()函数。
    由于以上不同的特性，带来了另外两个区别：
    1)JAVA启动的程序能在黑DOS窗口中显示System.out.print()输出的内容。而JAVAW

    则不能显示。
    2)在批处理中被调用时，会等待JAVA执行完毕；而不会等待JAVAW的执行结果。
    最后还要指出一个区别：JAVAW不会弹出命令行参数帮助提示信息。
    
    
# 修改代码

    private static void setOutPut() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd-HHmmss");
        String dateString = sdf.format(new Date());

        String file = "D:\\log\\log" + dateString + ".txt";
        try {
            System.setOut(new PrintStream(file));
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
    }
    
在调用输出前通过此方法设置，成功。