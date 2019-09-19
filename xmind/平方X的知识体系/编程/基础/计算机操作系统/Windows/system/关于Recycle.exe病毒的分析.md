[关于Recycle.exe病毒的分析](https://blog.csdn.net/shadowlaser/article/details/5959645)

【解决办法】：在文件夹选项里去掉隐藏系统文件选项，在任务管理器内找到病毒名称（可以在msconfig中找到一个启动选项）结束掉，并删掉系统文件夹windows/system32下的病毒文件夹和文件（msconfig里有路径），删掉【开始】菜单的【启动】选项里的快捷方式（用cmd解决病毒的系统属性）在注册表里查找病毒名称的键值删掉所有的键值，重启电脑，插入U盘，无病毒写入文件，问题解决。

U盘免疫办法：建立autorun.inf文件夹，建立reclyer.exe文件夹并进行删不掉处理。