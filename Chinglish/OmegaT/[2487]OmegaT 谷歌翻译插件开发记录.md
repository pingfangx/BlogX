# 0x00 前言
tk 的计算来自于
[cocoa520/Google_TK](https://github.com/cocoa520/Google_TK/blob/master/google_tk.html)  
之前使用 HtmlUnit 实现，但比较笨，后来还失效了。[让OmegaT支持百度翻译和谷歌翻译](http://blog.pingfangx.com/2359.html)  
于是这一次重写插件  
[[2487]OmegaT 谷歌翻译插件开发记录](http://blog.pingfangx.com/2487.html)  
[[2488]OmegaT 百度翻译插件开发记录](http://blog.pingfangx.com/2488.html)  

下面只介绍过程，没有原理介绍。  
[源码](https://github.com/pingfangx/omegat/blob/451bea6ade0bf62dc5bed7c771cf92ac08522a93/plugin/src/main/java/com/pingfangx/omegat/plugin/GoogleTranslatorX.java)

# 0x01 新建 Module
新建 Gradle module，名为 plugin 新建后相关文件夹不存在（后来发现是卡了？等弹出 git 添加提示就有了），但是在  
plugin_main.iml 和 plugin_test.iml 中已经有了，按标准新建文件夹
src/man/java 和 src/test/java

# 0x02 java 加载 js 的方式。
```
        try {
            ScriptEngineManager manager = new ScriptEngineManager();
            ScriptEngine engine = manager.getEngineByName("javascript");
            engine.eval("...");
            if (engine instanceof Invocable) {
                Invocable invoke = (Invocable) engine;
                return (String) invoke.invokeFunction("TL", text);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
```


# 0x03 读取自己 jar 包中的内容
写完之后导出 jar 参考 [[2434]IntelliJ IDEA 生成可运行的 jar 包](http://blog.pingfangx.com/2434.html) 。  
因为需要那个 js 文件，想要打包到 jar 中。
## 打包
在 Artifacts 的设置中，在 jar 内新建目录，新建文件就好。
## 读取
一开始使用
```
InputStream inputStream = GoogleTk.class.getResourceAsStream("resource/google_tk.js");
```
不行。又搜了一下，使用
```
InputStream inputStream = ClassLoader.getSystemResourceAsStream("resource/google_tk.js");
```
就可以了。
[ididcan《JavaIO——java如何读取jar包自身内部的属性文件》](http://blog.csdn.net/ididcan/article/details/6832505)

但是这样的问题是，在代码里不能正常测试，只能生成 jar 才能获取到。  
标记为资源根也不行，不知应该怎么设置。  
## 放弃
虽然以 jar 包形式运行可以了，但是当作库提供给 OmegaT 加载时，依然出错，只好放弃。  
最后还是选择了将 js 以字符串的形式加载，早知道直接这样了。

# 0x04 联网问题
测试时 WikiGet 报 503 ，但是用浏览器直接打开地址是可以的。  
可能是因为测试时注释了
```
addProxyAuthentication(conn);
```
于是实际加载测度，又提示 403 。
发现是必须添加 
```
            headers.put("User-Agent", "Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.6) Gecko/20091201 Firefox/3.5.6");
```

# 0x05 测试
运行 test 时，WikiGet 报空，将那一名注释。  
缺少 commons-io，将其加入 test 的 module 的依赖。

运行 OmegaT 的 main 时，找不到插件目录，修改 org.omegat.util.StaticUtils#installDir 返回 lib 目录，
并在 lib 下添加 plugins 并放上插件测试。