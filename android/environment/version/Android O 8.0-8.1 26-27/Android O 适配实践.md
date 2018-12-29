[Android Oreo](https://developer.android.google.cn/about/versions/oreo/)

[Android 8.0适配指北](https://blog.csdn.net/qq_17766199/article/details/80965631)

* 从清单文件中移除隐式广播接收器
* 运行时权限是否正确请求及使用
* 通知适配
* 安装 apk 权限
* 后台执行限制，启动前台任务
* 只有全屏不透明的 Activity 可以设置方向

# 从清单文件中移除隐式广播接收器
项目中几个广播（极光、融云）都显示发送，测试正常接收，无需修改。

# 运行时权限是否正确请求及使用
READ_EXTERNAL_STORAGE 和 WRITE_EXTERNAL_STORAGE 需要分开请求  
之前的版本，如果请求其中一个权限，授予后同组的其他权限也会授予（即使没有请求）  
修改后，请求同组权限时会自动授予（但是仍需要请求，不请求将不授予）  
于是将相关权限处同时请求即可。

# 通知适配
> Developer warning for package ""  
> Failed to post notification on channel "null"

项目中已经有 Notification 组和 网易七鱼组  
如果不设置，下载时的通知就无法展示

# 安装 apk 权限
如果不声明权限，会提示未知来源。  
但网上博文说如果不声明权限会安装失败，如果需要，可以添加。

REQUEST_INSTALL_PACKAGES 

# 后台执行限制，启动前台任务


# 只有全屏不透明的 Activity 可以设置方向
见另一篇介绍

