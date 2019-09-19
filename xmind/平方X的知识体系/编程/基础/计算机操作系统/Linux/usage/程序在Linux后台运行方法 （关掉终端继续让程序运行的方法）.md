[程序在Linux后台运行方法 （关掉终端继续让程序运行的方法）](https://blog.csdn.net/qq_28093585/article/details/79967922)


（1）使程序在后台运行方法

一般情况下，我们在命令后面加上&即可(如下面的语句会在后台执行可执行文件TCPServerFinal)

    ./TCPServerFinal &
关闭后台程序方法：使用jobs 命令列出正在运行的进程，使用kill命令结束进程（PID是用jobs命令查询出的进程号）。

    jobs -l
    kill PID
（2）已经运行的程序放到后台继续运行

    ctrl+z 挂起任务

输入bg 命令将挂起的任务放到后台继续执行。

 

（3）使程序在后台执行，而且终端窗口关闭后不会作为子进程被中断：加上 nohup 命令

    nohup ./TCPServerFinal & 
这样关闭终端后程序仍然在继续运行。

如何关闭这个在后台运行的进程：使用 ps -A 命令查询这个进程的PID进程号，再用kill命令终止进程。

需要注意的是：nohup命令会将程序的输出定向到当前目录的 nohup.out 文件中，我的程序输出较多，所以产生了一个特别的的nohup.out 文件。    解决方法：将标准输出定向到垃圾桶，具体操作如下：

命令语法： nohup xxxx >/dev/null 2>&1& 
比如： nohup ./TCPServerFinal  >/dev/null 2>&1&
命令解释：后台运行 TCPServerFinal  程序，将标准错误输出合并到标准输出，然后标准输出重定向至 垃圾桶 /dev/null
(无论是否将 nohup 命令的输出重定向到终端，输出都将附加到当前目录的 nohup.out 文件中。如果当前目录的 nohup.out 文件不可写，输出重定向到 $HOME/nohup.out 文件中。)
