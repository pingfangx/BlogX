参考 TextFilter

# 在 Plugins.properties 中添加
开发时直接添加，开发完应该打 jar 包就可以了。

# 重写插件相关方法

    public static void loadPlugins() {
        Core.registerFilterClass(JavaSourceFilter.class);
    }

    public static void unloadPlugins() {
    }
    
# 继承 AbstractFilter
重写相关方法

# 重写 AbstractFilter.processFile
只需要解析要翻译的内容，然后调用 `outFile.write(processEntry(entry));` 

不需要的内容，直接调用 `out.write()`

真是方便

