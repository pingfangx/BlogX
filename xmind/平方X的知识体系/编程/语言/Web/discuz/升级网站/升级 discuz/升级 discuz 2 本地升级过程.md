### **升级提示**
从 X3.2、X3.3 升级
- 备份数据库 
- 建立文件夹 old，旧程序除了 data ，  config， uc_client, uc_server 目录以外的程序移动进入 old 目录中
- 上传 X3.4 程序（压缩包中 upload 目录中的文件）， 如上传时候提示覆盖目录，请选择“是”
- 如果您不再需要云平台相关插件，请上传安装包 utility 目录中的 clearcloud.php 到论坛 install 目录，执行后将会把云平台相关应用进行降级操作
- 升级完毕，进入后台，更新缓存，并测试功能 X3.4
其中的QQ互联功能已升级为允许使用QQ互联官方的 appid，新站点必须到 http://connect.qq.com/ 申请，升级上来的站点不受影响

X3.4 自身升级，直接覆盖文件即可

# 升级本地过程
## 1 备份
* 备份数据库
* python 脚本备份添加的、修改的文件

## 2 升级
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
* 还原添加的文件
* 还原修改的文件