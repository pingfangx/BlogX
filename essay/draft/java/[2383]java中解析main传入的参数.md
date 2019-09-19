[md]

>本文由平方X发表于平方X网，转载请注明出处。[http://blog.pingfangx.com/2383.html](http://blog.pingfangx.com/2383.html)

一开始想手动解析，后来想想有没有轮子可以用。  
找到  
[guanyuan123.《我想向java的main()传入大量参数，怎么做最优雅？》](http://blog.sina.com.cn/s/blog_700aa8830101loma.html)  

开始试用了[Args4J](http://args4j.kohsuke.org/)，但是好像不能解析帮助？于是又找了  
[rensanning.《Java命令行选项解析之Commons-CLI & Args4J & JCommander》](http://rensanning.iteye.com/blog/2161201)  
文章中介绍的Args4J,还支持aliases，于是想到肯定也支持帮助，是自己打开的方式不对。

[自己的使用例子](https://github.com/pingfangx/JavaX/blob/develop-tools/ClassFileEditor/src/com/pingfangx/tools/ClassFileEditor.java)

[/md]