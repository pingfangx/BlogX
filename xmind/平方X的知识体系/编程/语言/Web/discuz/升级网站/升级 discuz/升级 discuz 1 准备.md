php 版本 5.6 最高支持 7.2
本地 X3.2 

首先让本地与线上一致。  
然后记录本地对 discuz 的改动。  
替换源码后，再重新应用改动。

# 1 比较本地与线上的区别
有区别的文件|描述
-|-|-
config|配置文件
data|附件数据、数据库与文件缓存
uc_client|
uc_server|
xx/xxDebug.php|
xx/think/runtime/|
xx/think/Application/config.php|
xx/think/Application/database.php|
source/admincp/discuzfiles.md5
source/class/discuz/discuz_application.php|本地不需要 https
.htaccess|本地不需要 https

备份文件|描述
-|-
xxScore.php|铁大X V1.0|
static/image/mobile/logo.gif|以前设计的七彩图标，哈哈
xx/support_author2|以前的支持作者

# 2 比较本地与 discuz 的区别
## 用 Beyond Compare 比较
有区别的文件|描述|目录
-|-|-
source/class/discuz/discuz_application.php|https
source/class/discuz/discuz_error.php|https
source/class/class_member.php|用户名不能为纯数字
source/function/function_attach.php|apk 附件
source/module/forum/forum_ajax.php|用户名不能为纯数字
source/module/home/home_space.php|https 用户个人空间编码
source/plugin/|两个插件|1
static/image/common||1
static/image/filetype/apk.gif|
static/image/mobile/images/logo.png|
template/default/common/footer.htm|
template/default/common/header.htm|
template/default/common/header_common.htm|
template/default/xx/||1
template/xx/||1
xx/||1
xxtieba||1
favicon.icon|图标修改了
index.php|首页修改了

## 用 discuz 自带的工具 > 文件校验
之前用 python 也处理过
