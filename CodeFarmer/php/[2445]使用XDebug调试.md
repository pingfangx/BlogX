
# wamp 3.1.4
下载的 php 已经自带 xdebug ，只需要在 php.ini 中启用即可。  
PhpStorm 还是一样，添加配置，调试是否可用，可以直接 validate


参考  
http://blog.sina.com.cn/s/blog_6fb374610101a0fe.html
http://www.cnphp6.com/archives/64729

1，在http://xdebug.org/download.php下载xdebug  
2，复制到php安装目录下的ext目录，我的是  
`D:\software\program\webpage\wamp64\bin\php\php5.6.25\ext`

3，配置php.ini
```
[xdebug]
zend_extension = "D:\software\program\webpage\wamp64\bin\php\php5.6.25\ext"
xdebug.idekey=PhpStorm
xdebug.remote_enable = On
xdebug.remote_host=localhost
xdebug.remote_port=9000
xdebug.remote_handler=dbgp
```
4，重启apache

5，php storm里，点运行→编辑结构，点加号，选PHP Web Application  
添加本地Server，设置start url的Browser  
6，加外可能还需要设置设置→语言和框架→PHP→DEBUG，的XDebug，填上9000