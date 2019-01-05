# 升级线上过程
## 1 备份
* 备份文件、备份数据库

## 2 升级
commit 为  1f1b8e3  
因为没有好的 ftp 软件，PhpStorm 也没找对使用方法。  
于是打包上传，然后解压缩，好像也可以，正常使用。

根据 readme/upgrade.txt，

1. 进入您原来的系统，关闭您的站点。进行数据备份。
2. 站点建立 old 文件夹，除 data, config, uc_server, uc_client 之外的文件移动到 old 目录中
3. 下载并解压缩最新版的程序包（请注意需要与您原来的语言版本一样，不可混用)
4. 程序包解压缩后，可以看到 readme, upload, utilities 三个目录， 
5. 上传upload目录中的程序到服务器论坛目录，如果提示需要覆盖，则选择“是”
6. 将压缩包中 /utilities/ 目录中的 update.php 程序上传到您的论坛 install 目录。并删除 install 目录
   中的 index.php
7. 访问 http://您的域名/论坛目录/install/update.php
8. 按照程序提示，直至所有升级完毕。删除 update.php 程序，以免被恶意利用。
9. 进入论坛后台，更新缓存，并对新功能进行设置和测试。
10. old目录中如果存放有非discuzX程序文件，则将他备份或者恢复到原来的位置，否则当中的程序可以在升级成功后删除。

## 3 还原
* 上传并运行工具（xx_checktool.php）生成各文件的 md5
* 删除 old 文件夹
### 上传增改的文件
* 从 PhoStorm 中将相关提交对应的文件直接上传到服务器  
即本地的“还原添加”、“还原修改”两次提交  
上传时先进行了处理，再进行上传，可能处理是判断是否已存在文件，或者是从 git 检出。

上传耗时

    [2018/11/13 22:00] Upload 646 changes to www.pingfangx.com
    [2018/11/13 22:14] Upload 646 changes to www.pingfangx.com completed in 13 分钟: 646 files transferred (15.7 kbit/s)
### 上传被忽略的文件
* thinkphp
* config  
因为 data, config, uc_server, uc_client 保留，因此只需上传  
xx/xxDebug.php  
xx/think/application/config.php 和  
xx/think/application/database.php  