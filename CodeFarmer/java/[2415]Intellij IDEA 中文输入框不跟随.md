[md]

找到 [zyue在知乎回答](https://www.zhihu.com/question/37582743/answer/191630075)  
以及评论区各大神的补充。
# 原因
Idea 自带的 jre 会导致这个问题，更具体地说，好像是因为自带的版本太高所致。
# 解决方案
1. 备份并替换 Idea 自带的 jre64 文件夹
2. 重命名 jre64 目录，找不到自带的会自动使用安装的
3. 按Ctrl+Shift+A，输入Switch IDE Boot JDK，切换 启动的 jdk

如果不是这个原因，还可能有其他原因
1. 切换字体
2. 升级输入法
3. 使用32位
# Android Studio 3.0 升级后不跟随的问题
一开始仍然是切换了启动 jdk ，可是仍然无效。  
应该修改 文件→项目结构→JDK location  
可以指向本地的 jdk 也可以，用本地 jdk 替换 Android Studio 安装目录下的 jre 文件夹。注意虽然文件夹名字是 jre ，但其内容是整个 jdk 文件夹。

在安装过程中还发现，在启动 jdk 安装程序时，会自动卸载相同版本的 jdk ，也就是说，如果此时取消安装，之前的相同版本仍然是被卸载了。

[/md]