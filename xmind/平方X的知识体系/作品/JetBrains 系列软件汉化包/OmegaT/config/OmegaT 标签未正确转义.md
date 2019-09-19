# 场景
在翻译泛型时 List<? super Integer>
无法正确的转义
原文为

    <tt>List&lt;? super Integer&gt;</tt>

翻译后为

    <tt>List<?super Integer&gt;</tt>

# 查看输出

    在 org.omegat.gui.main.MainWindowMenu 找到 org.omegat.gui.main.MainWindowMenu#projectCompileMenuItem
    点击事件在 org.omegat.gui.main.MainWindowMenuHandler#projectCompileMenuItemActionPerformed
    org.omegat.gui.main.ProjectUICommands#projectCompile
    org.omegat.core.data.IProject#compileProject
    org.omegat.core.data.RealProject#compileProject(java.lang.String)
    org.omegat.core.data.RealProject#compileProjectAndCommit
    org.omegat.filters2.master.FilterMaster#translateFile
    org.omegat.filters2.AbstractFilter#translateFile
    org.omegat.filters2.AbstractFilter#processFile(java.io.File, java.io.File, org.omegat.filters2.FilterContext)
    org.omegat.filters2.html2.HTMLFilter2#processFile
    org.htmlparser.Parser#visitAllNodesWith
    org.htmlparser.Node#accept
    ...
    org.omegat.filters2.html2.FilterVisitor#visitEndTag
    org.omegat.filters2.html2.FilterVisitor#endup
    
        // getting the translation
        String translation = filter.privateProcessEntry(compressed, null);

        // writing out uncompressed
        if (compressed.equals(translation) && !options.getCompressWhitespace()) {
            translation = uncompressed;
        }

        // converting & < and > into &amp; &lt; and &gt; respectively
        // note that this doesn't change < and > of tag shortcuts
        translation = HTMLUtils.charsToEntities(translation, filter.getTargetEncoding(), sShortcuts);
        // expands tag shortcuts into full-blown tags
        translation = unshorcutize(translation);
        // writing out the paragraph into target file
        writeout(spacePrefix);
        writeout(translation);
        writeout(spacePostfix);
    
    由 org.omegat.filters2.html2.HTMLUtils#charsToEntities 返回的方法没有正确转义
    
# org.omegat.filters2.html2.HTMLUtils#charsToEntities

            case '<':
                int qMarkPos = str.indexOf('?', i);
                // If it's the beginning of a processing instruction
                if (qMarkPos == str.offsetByCodePoints(i, 1)) {
                    res.append("<");
                    break;
                }
                
[Processing Instruction](https://en.wikipedia.org/wiki/Processing_Instruction)

offsetByCodePoints 这个需要理解 CodePoint

# 解决
这个其实不好解决，
根据语法

    An SGML processing instruction is enclosed within <? and >

    An XML processing instruction is enclosed within <? and ?>
    
因此在 HTML（基于 SGML）中也不好判断后面是否以 ?> 结尾。  
而且由于拆分时

    <tt>List<? super Integer></tt>
    被拆为
    
    <tt>List<?
    super Integer></tt>
    
    中间的空格被去掉了，因此在翻译时，在 ? 前后都添加空格
    <tt>List< ? 
    super Integer></tt>
    
但是 List<?> 还是无法正常转义

于是去学习了 OmegaT 分割规则和文件过滤器。
