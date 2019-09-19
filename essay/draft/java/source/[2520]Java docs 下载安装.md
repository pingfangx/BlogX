看到 Iterable 的文档
```
<a href="{@docRoot}/../technotes/guides/language/foreach.html">For-each Loop</a>
```
打开，提示
>无法解析网址 ../../..//../technotes/guides/language/foreach.html  
在 project settings 中配置 API 文档可能会有帮助。

才发现，原来下载的 jdk 不带文档的啊。
但是因为有源码呀，所以并不影响之前的编程，如何配置这个 doc 呢。

# 下载
网站一直比较复杂，整理一下  
[oracle](https://www.oracle.com/index.html) → 
[java se](http://www.oracle.com/technetwork/java/javase/overview/index.html) → 
[Documentation](http://www.oracle.com/technetwork/java/javase/documentation/index.html) →
[JDK 9 Documentation](https://docs.oracle.com/javase/9/) 

因为当前安装的是 jdk 8，于是转到  
[Downloads](http://www.oracle.com/technetwork/java/javase/downloads/index.html)
在 Additional Resources 中找到 [Java SE 8 Documentation](http://www.oracle.com/technetwork/java/javase/documentation/jdk8-doc-downloads-2133158.html)  
然后下载对应版本即可


另外还有
[中文 Documentation 页](http://www.oracle.com/technetwork/cn/java/javase/documentation/api-jsp-136079-zhs.html)  
在此页面可以看到 jdk 6 是提供中文 API 的，别的版本都没有。

另外国内 oschina 提供有  
[jdk 7 api](http://tool.oschina.net/apidocs/apidoc?api=jdk_7u4)  
[jdk 6 api 中文](http://tool.oschina.net/apidocs/apidoc?api=jdk-zh)

# 使用
解压后，在 项目结构 → sdks 中配置文档路径即可。

# 又理一遍概念
## jdk(Java Development Kit)
java 开发工具包，即用于 java 开发的 sdk  
> JDK中还包括完整的JRE（Java Runtime Environment），Java运行环境，也被称为private runtime。包括了用于产品环境的各种库类，如基础类库rt.jar，以及给开发人员使用的补充库，如国际化与本地化的类库、IDL库等等。
JDK中还包括各种样例程序，用以展示Java API中的各部分。

## jre(Java Runtime Environment)
java 运行环境

## sdk(Software development kit)
软件开发工具包

## doc(documentation)

## api(Application Programming Interface)
应用编程接口

# Tutorial
想找下中文版，没有找到。  
英文版可以下载，中文版找到 《Java 8 编程官方参考教程（第9版）》（不是 Tutorial 的汉化，但可以参照学习）