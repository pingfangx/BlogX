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

[/md]