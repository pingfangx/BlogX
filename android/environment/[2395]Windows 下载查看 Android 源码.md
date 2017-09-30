[md]

参考，感谢。[Jeanboydev.《 Windows 环境下载 Android 源码》](http://blog.csdn.net/freekiteyu/article/details/70939672)  
之前解决 webview bug 还是什么的时候也 clone 过几个源码（要查看某一版本），但没有完整下过（惭愧……）。  
这一次想了解[Android 中虚线的实线]()，于是查了一下，以后也要认真、多看源码。  

首先我们要知道谷歌是有官方的教程的[下载源代码](https://source.android.com/source/downloading)  
我们还要知道，感谢[清华大学开源软件镜像站-AOSP](https://mirrors.tuna.tsinghua.edu.cn/help/AOSP/)  

# clon 清单文件
```
git clone https://android.googlesource.com/platform/manifest.git
//没有梯子使用清华源
git clone https://aosp.tuna.tsinghua.edu.cn/platform/manifest.git
```
下载完成后会有manifest/default.xml

# 切换分枝
这里自己存有疑问，难道不需要加上版本号吗？为什么直接根据清单文件clone的就是所对应的版本呢。

后来自己又想了一下，不知为啥短路了…… clone 了每一个项目之后，每个项目都是独立的，可以切换到我们想要的分枝。  
也就是说我们需要在 clone 完成后执行切换，或者如果要快速克隆，可以只克隆那一个tag。

# clone 清单文件中的各个项目
原文中提供了 python 脚本，但自己又重新写了一个。

[android_source_downloader.py](https://github.com/pingfangx/PythonX/blob/feature-android_source_downloader/ToolsX/android/android_source_downloader.py)


[/md]