获取翻译的堆栈

    1 = {StackTraceElement@14174} "org.omegat.core.data.ProjectTMX.getDefaultTranslation(ProjectTMX.java:235)"
    2 = {StackTraceElement@14175} "org.omegat.core.data.RealProject$TranslateFilesCallback.getSegmentTranslation(RealProject.java:1791)"
    3 = {StackTraceElement@14176} "org.omegat.core.data.TranslateEntry.internalGetSegmentTranslation(TranslateEntry.java:253)"
    4 = {StackTraceElement@14177} "org.omegat.core.data.TranslateEntry.getTranslation(TranslateEntry.java:122)"
    5 = {StackTraceElement@14178} "org.omegat.filters2.AbstractFilter.processEntry(AbstractFilter.java:610)"
    6 = {StackTraceElement@14179} "org.omegat.filters2.html2.HTMLFilter2.privateProcessEntry(HTMLFilter2.java:201)"
    7 = {StackTraceElement@14180} "org.omegat.filters2.html2.FilterVisitor.endup(FilterVisitor.java:624)"
    8 = {StackTraceElement@14181} "org.omegat.filters2.html2.FilterVisitor.visitEndTag(FilterVisitor.java:329)"
    9 = {StackTraceElement@14182} "org.htmlparser.nodes.TagNode.accept(TagNode.java:760)"
    10 = {StackTraceElement@14183} "org.htmlparser.tags.CompositeTag.accept(CompositeTag.java:461)"
    11 = {StackTraceElement@14184} "org.htmlparser.tags.CompositeTag.accept(CompositeTag.java:461)"
    12 = {StackTraceElement@14185} "org.htmlparser.Parser.visitAllNodesWith(Parser.java:661)"
    13 = {StackTraceElement@14186} "org.omegat.filters2.html2.HTMLFilter2.processFile(HTMLFilter2.java:180)"
    14 = {StackTraceElement@14187} "org.omegat.filters2.AbstractFilter.processFile(AbstractFilter.java:450)"
    15 = {StackTraceElement@14188} "org.omegat.filters2.AbstractFilter.translateFile(AbstractFilter.java:567)"
    16 = {StackTraceElement@14189} "org.omegat.filters2.master.FilterMaster.translateFile(FilterMaster.java:253)"
    17 = {StackTraceElement@14190} "org.omegat.core.data.RealProject.compileProjectAndCommit(RealProject.java:652)"
    18 = {StackTraceElement@14191} "org.omegat.core.data.RealProject.compileProject(RealProject.java:578)"
    19 = {StackTraceElement@14192} "org.omegat.core.data.RealProject.compileProject(RealProject.java:564)"

    转到 AbstractFilter.translateFile
    然后访问各结点，在 FilterVisitor.endup 中获取翻译
    调用 AbstractFilter.processEntry
    
创建输出的堆栈

    0 = {StackTraceElement@14647} "java.lang.Thread.getStackTrace(Thread.java:1559)"
    1 = {StackTraceElement@14648} "org.omegat.filters2.html2.HTMLWriter.<init>(HTMLWriter.java:100)"
    2 = {StackTraceElement@14649} "org.omegat.filters2.html2.HTMLFilter2.createWriter(HTMLFilter2.java:125)"
    3 = {StackTraceElement@14650} "org.omegat.filters2.AbstractFilter.processFile(AbstractFilter.java:444)"
    4 = {StackTraceElement@14651} "org.omegat.filters2.AbstractFilter.translateFile(AbstractFilter.java:567)"
    5 = {StackTraceElement@14652} "org.omegat.filters2.master.FilterMaster.translateFile(FilterMaster.java:253)"
    6 = {StackTraceElement@14653} "org.omegat.core.data.RealProject.compileProjectAndCommit(RealProject.java:652)"
    7 = {StackTraceElement@14654} "org.omegat.core.data.RealProject.compileProject(RealProject.java:578)"
    8 = {StackTraceElement@14655} "org.omegat.core.data.RealProject.compileProject(RealProject.java:564)"
    
    可以看到公共方法为 AbstractFilter.processFile
    AbstractFilter 连接了获取翻译和创建输出文件
    
    protected void processFile(File inFile, File outFile, FilterContext fc) throws IOException,
            TranslationException {
        String encoding = getInputEncoding(fc, inFile);
        BufferedReader reader = createReader(inFile, encoding);
        inEncodingLastParsedFile = encoding == null ? Charset.defaultCharset().name() : encoding;
        try {
            BufferedWriter writer;

            if (outFile != null) {
                String outEncoding = getOutputEncoding(fc);
                //创建输出
                writer = createWriter(outFile, outEncoding);
            } else {
                writer = new NullBufferedWriter();
            }

            try {
                //处理文件
                processFile(reader, writer, fc);
            } finally {
                writer.close();
            }
        } finally {
            reader.close();
        }
    }