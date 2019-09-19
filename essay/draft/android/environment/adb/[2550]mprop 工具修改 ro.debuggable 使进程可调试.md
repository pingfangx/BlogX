[Android”挂逼”修炼之行—支付宝蚂蚁森林能量自动收取插件开发原理解析](http://www.520monkey.com/archives/1283)

感谢提到的 mprop

# mprop
[wpvsyou/mprop](https://github.com/wpvsyou/mprop)

[[原创]修改ro属性的小工具新版本-170119](https://bbs.pediy.com/thread-215311.htm)

[[原创]android ro.debuggable属性调试修改(mprop逆向)](https://bbs.pediy.com/thread-246081.htm)

使用最后一篇的工具，

    adb push mprop /data/local/tmp
    adb shell
    cd /data/local/tmp
    chmod 777 mprop
    getprop ro.debuggable
    ./mprop ro.debuggable 1 修改
    执行后会输出一堆，等一会儿直到修改完毕
    getprop ro.debuggable 检查
    然后进程需杀死重启