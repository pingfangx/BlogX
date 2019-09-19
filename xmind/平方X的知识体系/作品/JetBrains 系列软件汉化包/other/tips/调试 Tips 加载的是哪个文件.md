发现每日提示中有部分 tip 被从 resources_en.jar 中删除了  
但是运行后却还是有展示，但是没汉化，查看 tip 是从哪里加载的。
# 调试
因为 Community 版和 Ultimate 版不能同时运行，所以直接用 AndroidStudio 反过来调试 Idea

# 配置 VM options 添加并附加附加调试

    -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005

# 确定 jar 位置
使用 TipUIUtil.class.getClassLoader().getResource(TipUIUtil.class.getName().replace('.', '/').concat(".class"))  

    /lib/platform-impl.jar!/com/intellij/ide/util/TipUIUtil.class
    
# 复制 jar 到项目中，断点调试。
查看 tip 参数，得到

    PluginDescriptor(name=Java IDE Customization, classpath=D:\software\JetBrains\apps\IDEA-U\ch-0\192.5728.98\plugins\java-ide-customization)
    
    com.intellij.ide.util.TipUIUtil#getTipText
    
                StringBuilder text = new StringBuilder();
                File tipFile = new File(tip.fileName);
                String cssText;
                if (tipFile.isAbsolute() && tipFile.exists()) {
                    text.append(FileUtil.loadFile(tipFile));
                    updateImages(text, (ClassLoader)null, tipFile.getParentFile().getAbsolutePath(), component);
                    cssText = FileUtil.loadFile(new File(tipFile.getParentFile(), UIUtil.isUnderDarcula() ? "css/tips_darcula.css" : "css/tips.css"));
                } else {
                    PluginDescriptor pluginDescriptor = tip.getPluginDescriptor();
                    ClassLoader tipLoader = pluginDescriptor == null ? TipUIUtil.class.getClassLoader() : (ClassLoader)ObjectUtils.notNull(pluginDescriptor.getPluginClassLoader(), TipUIUtil.class.getClassLoader());
                    InputStream tipStream = ResourceUtil.getResourceAsStream(tipLoader, "/tips/", tip.fileName);
                    if (tipStream == null) {
                        return getCantReadText(tip);
                    }

                    text.append(ResourceUtil.loadText(tipStream));
                    updateImages(text, tipLoader, "", component);
                    InputStream cssResourceStream = ResourceUtil.getResourceAsStream(tipLoader, "/tips/", UIUtil.isUnderDarcula() ? "css/tips_darcula.css" : "css/tips.css");
                    cssText = cssResourceStream != null ? ResourceUtil.loadText(cssResourceStream) : "";
                }
    
    此时的 tipLoader 是 
    com.intellij.ide.plugins.cl.PluginClassLoader
    但是它有 myParents
    PluginClassLoader 和 URLClassLoader
    
    因为其直接获取的 stream
    InputStream tipStream = ResourceUtil.getResourceAsStream(tipLoader, "/tips/", tip.fileName);
    改用 getResource 获取资源查看文件名
    tipLoader.getResource("/tips/"+tip.fileName)
    file:/D:/software/JetBrains/apps/IDEA-U/ch-0/192.5728.98/plugins/java/lib/resources_en.jar!/tips/Welcome.html
    
    
# 查看 PluginClassLoader 的 getResource
    com.intellij.util.ResourceUtil#getResourceAsStream(java.lang.ClassLoader, java.lang.String, java.lang.String)
    
      public static InputStream getResourceAsStream(@NotNull ClassLoader loader, @NonNls @NotNull String basePath, @NonNls @NotNull String fileName) {
        String fixedPath = StringUtil.trimStart(StringUtil.trimEnd(basePath, "/"), "/");

        List<String> bundles = calculateBundleNames(fixedPath, Locale.getDefault());
        for (String bundle : bundles) {
          InputStream stream = loader.getResourceAsStream(bundle + "/" + fileName);
          if (stream == null) continue;

          return stream;
        }

        return loader.getResourceAsStream(fixedPath + "/" + fileName);
      }
    可以看到 ResourceUtil 依然是收集 bundle 然后依次查找
    com.intellij.ide.plugins.cl.PluginClassLoader#getResourceAsStream
    
      @Override
      public InputStream getResourceAsStream(String name) {
        InputStream stream = getOwnResourceAsStream(name);
        if (stream != null) return stream;

        return processResourcesInParents(name, getResourceAsStreamInPluginCL, getResourceAsStreamInCl, null, null);
      }
    虽然优先在当前 loader 中查找，找不到才会去 parent 中查找
    但是因为先找的是 zh_CN，所以只要在 parent 中找到就可以正常返回了
    
# 结论
可以将 \plugins\java\lib\resources_en.jar 也收集，合并为 
\lib\resources_zh_CN_IntelliJIDEA_2019.2_r1.jar  
加载时会先查找 zh_CN 的资源，在 parentLoader 中找到就会返回