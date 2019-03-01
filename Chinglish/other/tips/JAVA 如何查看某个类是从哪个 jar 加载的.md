https://stackoverflow.com/questions/1983839/determine-which-jar-file-a-class-is-from

[Java-查看JVM从哪个JAR包中加载指定类](https://blog.csdn.net/yangshangwei/article/details/74531939)

    public static String where(final Class cls) {
        if (cls == null)throw new IllegalArgumentException("null input: cls");
        URL result = null;
        final String clsAsResource = cls.getName().replace('.', '/').concat(".class");
        final ProtectionDomain pd = cls.getProtectionDomain();
        if (pd != null) {
            final CodeSource cs = pd.getCodeSource();
            if (cs != null) result = cs.getLocation();
            if (result != null) {
                if ("file".equals(result.getProtocol())) {
                    try {
                        if (result.toExternalForm().endsWith(".jar") ||
                                result.toExternalForm().endsWith(".zip"))
                            result = new URL("jar:".concat(result.toExternalForm())
                                    .concat("!/").concat(clsAsResource));
                        else if (new File(result.getFile()).isDirectory())
                            result = new URL(result, clsAsResource);
                    }
                    catch (MalformedURLException ignore) {}
                }
            }
        }
        if (result == null) {
            final ClassLoader clsLoader = cls.getClassLoader();
            result = clsLoader != null ?
                    clsLoader.getResource(clsAsResource) :
                    ClassLoader.getSystemResource(clsAsResource);
        }
        System.out.println(result.toString());
        return result.toString();
    }

    TipUIUtil.class.getProtectionDomain().getCodeSource()
    这个需要 java -verbose MyApp 的形式
    
    但下面的可以正常调用
    TipUIUtil.class.getClassLoader().getResource(TipUIUtil.class.getName().replace('.', '/').concat(".class"))
    