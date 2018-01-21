有一次需要安装 pycrypto 然后报错
```
 warning: GMP or MPIR library not found; Not building Crypto.PublicKey._fastmath.
 building 'Crypto.Random.OSRNG.winrandom' extension
 error: Microsoft Visual C++ 14.0 is required. Get it with "Microsoft Visual C++ Build Tools": http://landinghub.visualstudio.com/visual-cpp-build-tools
```
# 重装 VS
搜索发现需要安装 VS ，自已的 VS 打不开了，卸载、修复、重装，2010、2015 都试了还是不行。  
[求助  Team Explorer for Microsoft Visual Studio2015安装错误](https://tieba.baidu.com/p/4024153653)
>以上的回复都没有解决我的问题，可能是不太适合我
我的解决方法是
将windows补丁更新,然后继续安装
如果没有办法请更新,因为Team Explore 可能需要某些补丁的支持。

修复后安装成功。

# vcvarsall.bat
在 [false2true.《Python 包安装error: Microsoft Visual C++ 14.0 is required...问题解决方案,》](http://blog.csdn.net/marchcuckoo/article/details/76919218)
>解决方案：
Python 3.6 模块安装error: Microsoft Visual C++ 14.0 is required...问题解决方案,
一般并不是缺少C++运行环境

不是环境问题，于是去下载 [pycrypto](https://github.com/dlitz/pycrypto) 下载下来，安装提示
```
 error: Unable to find vcvarsall.bat
```

再搜索发现
[secretx.《彻底解决 error: Unable to find vcvarsall.bat》](http://blog.csdn.net/secretx/article/details/17472107)
里面提到
> 你还可以更暴力，在“..python安装路径...\Lib\distutils目录下有个msvc9compiler.py找到243行  
                  toolskey = "VS%0.f0COMNTOOLS" % version   直接改为 toolskey = "VS你的版本COMNTOOLS"(这个就是为什么要配 ”VS90COMNTOOLS“ 的原因，因为人家文件名都告诉你了是  Microsoft vc 9的compiler,   代码都写死了要vc9的comntools，就要找这个玩意儿，找不到不干活
                  
但我修改了还是不行，我用 everything 搜了一下,发现我根本没有 vcvarsall.bat
后来找到 [Python3.4 用 pip 安装lxml时出现 “Unable to find vcvarsall.bat ”？](https://www.zhihu.com/question/26857761)  
代代树 的回答  
>feature → Programming Languages → Visual C++ Common Tools for Visual C++ 2015

勾上以后安装完,再搜索 vcvarsall.bat 就有了.

关闭搜索窗口时发现，
[Microsoft Visual C++ 14.0 is required (Unable to find vcvarsall.bat)](https://stackoverflow.com/questions/29846087/microsoft-visual-c-14-0-is-required-unable-to-find-vcvarsall-bat)
里面已经提到了
> Your path only lists Visual Studio 11 and 12, it wants 14, which is Visual Studio 2015. If you install that, and remember to tick the box for Languages->C++ then it should work.

