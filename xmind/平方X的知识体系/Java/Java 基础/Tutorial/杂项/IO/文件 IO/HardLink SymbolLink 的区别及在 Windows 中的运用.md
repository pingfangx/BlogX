区别网上已经有很多，就不测试了。

在 Tutorial 的 io/links.html 中有介绍

# 适用场景
在使用汉化包的时候，相关的 css 等资源没有添加到 source 中，但是为了 target 能正常浏览，需要相关资源。

此时如果直接复制一份显得没有必要，于是就可以利用链接。

这里使用 SymbolLink 即可，测试见 FileLinkTest.java

    

    /**
     * 创建后是 .symlink 类型
     */
    @Test
    public void test_createSymbolicLink() {
        Path newLink = folder.resolve("D:\\workspace\\TranslatorX-other\\AndroidDocs\\target\\docs\\assets");
        Path target = folder.resolve("F:\\android-sdk\\docs\\assets");
        try {
            Files.createSymbolicLink(newLink, target);
        } catch (IOException | UnsupportedOperationException x) {
            System.err.println(x);
        }
    }

    /**
     * 硬链接文件必须存在
     */
    @Test
    public void test_createLink() {
        Path newLink = folder.resolve("test.txt.link");
        Path target = folder.resolve("test.txt");
        try {
            Files.createLink(newLink, target);
        } catch (IOException | UnsupportedOperationException x) {
            System.err.println(x);
        }
    }