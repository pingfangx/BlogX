检查了一遍，是可以升级，但是没有测试人员呀，想了想还是不升级了。
# 相关问题

[top-think/think](https://github.com/top-think/think)

[top-think/framework](https://github.com/top-think/framework)

[ThinkPHP5.1完全开发手册](https://www.kancloud.cn/manual/thinkphp5_1/353946)

[5.1版本升级指导](https://www.kancloud.cn/manual/thinkphp5_1/354155)

[5.0 升级指导](https://www.kancloud.cn/manual/thinkphp5/163239)


查看版本 thinkphp/base.php

版本为 5.0.3 要升为最新的，需要先一步步升到 5.0.22  
再升级 5.1

根据升级指导查看需要修改的各个地方

## 本地 thinkphp 的修改
文件|修改
-|-
application/*|所有文件夹
application/index/Index.php|说明
application/config.php|list_rows
application/database.php|database,password,prefix,auto_timestamp
application/route.php|跳转

## 本地 thinkphp 框架的修改
虽然版本号是 v5.0.3  
但是代码却与 v5.0.3 的有些不同，后来发现应该当时就是从 git clone 的，因此应该选择时间对应的版本。   
20160623 应该有一个版本 5.0.0 RC3，20161130 自己更新了一下。  
后来终于找到了对应提交，切过去再比较。  
除了残留 20160623 的部分文件，就只修改了一个文件。

文件|修改
-|-
library/think/App.php|修改读取操作方法使支持用下划线访问的时候，也查找有没有小驼峰命名的方法。


# 升级
## 修改 exp 查询
## 命名空间调整
    think\\(App|Cache|Config|Cookie|Debug|Env|Hook|Lang|Log|Request|Response|Route|Session|Url|Validate|View)
## 配置文件调整
搜索 config.php 进行拆分
## 常量调整
    (EXT|IS_WIN|IS_CLI|DS|ENV_PREFIX|THINK_START_TIME|THINK_START_MEM|THINK_VERSION|THINK_PATH|LIB_PATH|CORE_PATH|APP_PATH|CONFIG_PATH|CONFIG_EXT|ROOT_PATH|EXTEND_PATH|VENDOR_PATH|RUNTIME_PATH|LOG_PATH|CACHE_PATH|TEMP_PATH|MODULE_PATH)
修改 LimitedCache
## 路由调整
修改 route.php

## 其它注意事项
取消了Loader::import方法以及import  
模板的变量输出默认添加了htmlentities安全过滤，如果你需要输出html内容的话，请使用{$var|raw}方式替换，并且date方法已经做了内部封装，无需再使用###变量替换了。