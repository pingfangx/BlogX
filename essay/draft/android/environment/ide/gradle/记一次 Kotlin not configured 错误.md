是 Kotlin 无法加载，修改 kotlin 版本却又无法下载。

难道是开着代理的原因，于是将代理软件关闭，终于提示

> Connect to 127.0.0.1:1080 [/127.0.0.1] failed: Connection refused: connect

现在知道是 gradle 的配置文件中设置了代理，但是项目中并没有 gradle.properties

于是找系统默认的，但是系统盘并没有 .gradle 目录

原来是之前改了 GRADLE_USER_HOME 环境变量