[Determining Supported Processor Types (ABIs) for an Android Device](https://handstandsam.com/2016/01/28/determining-supported-processor-types-abis-for-an-android-device/)

[与 .so 有关的一个长年大坑](https://zhuanlan.zhihu.com/p/21359984)  
> 为了减小 apk 体积，只保留 armeabi 和 armeabi-v7a 两个文件夹，并保证这两个文件夹中 .so 数量一致
> 对只提供 armeabi 版本的第三方 .so，原样复制一份到 armeabi-v7a 文件夹


[为何 Twitter 区别于微信、淘宝，只使用了 armeabi-v7a？](https://www.diycode.cc/topics/691)

[微信的安装包在只编译了armeabi，没有x86，arm64-v8a是如何运行在各种处理器的手机上的？](https://www.zhihu.com/question/36893314)


# 结果
根据建议
x86 和 x86_64 仅部分模拟器使用  
mips 很少见到  
release 仅保留 armeabi 和 armeabi-v7a 的支持  
debug 为了模拟器加上 x86 和 x86_64  

但是项目中使用的 armeabi 和 armeabi-v7a 并没有一一对应，需要统计数据支持。
