# 调用
    java.lang.ClassLoader#getResource
    java.lang.ClassLoader#findResource
    com.intellij.util.lang.UrlClassLoader#findResource
    com.intellij.util.lang.UrlClassLoader#findResourceImpl
    com.intellij.util.lang.ClassPath#getResource
    com.intellij.util.lang.ClasspathCache.LoaderIterator
    com.intellij.util.lang.ClassPath.ResourceStringLoaderIterator#process
    com.intellij.util.lang.JarLoader#getResource
        
        ZipEntry entry = zipFile.getEntry(name);
        if (entry != null) {
          return new MyResource(getBaseURL(), entry);
        }
    
    返回的 resource 为
    jar:file:/D:/workspace/github/intellij-community/lib/resources_zh_CN_IntelliJIDEA_2018.2_r1.jar!/
    其 url 是
    com.intellij.util.lang.JarLoader#JarLoader
        super(new URL("jar", "", -1, url + "!/"), index);
        所以会以 jar: 开头，!/ 结尾