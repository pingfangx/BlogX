# 加载的片段添加到项目中
    org.omegat.core.data.RealProject$LoadFilesCallback.addSegment(RealProject.java:1733)
    org.omegat.core.data.ParseEntry.fileFinished(ParseEntry.java:76)
    org.omegat.core.data.RealProject$LoadFilesCallback.fileFinished(RealProject.java:1716)
    org.omegat.core.data.RealProject.loadSourceFiles(RealProject.java:1152)
    org.omegat.core.data.RealProject.loadProject(RealProject.java:368)
    org.omegat.core.data.ProjectFactory.loadProject(ProjectFactory.java:72)
# 遍历时如果添加片段
    org.omegat.core.data.ParseEntry.addEntry(ParseEntry.java:195)
    org.omegat.filters2.AbstractFilter.processEntry(AbstractFilter.java:607)
    org.omegat.filters2.html2.HTMLFilter2.privateProcessEntry(HTMLFilter2.java:201)
    org.omegat.filters2.html2.FilterVisitor.endup(FilterVisitor.java:624)
    org.omegat.filters2.html2.FilterVisitor.visitEndTag(FilterVisitor.java:329)
    org.htmlparser.nodes.TagNode.accept(TagNode.java:760)
    org.htmlparser.tags.CompositeTag.accept(CompositeTag.java:465)
    org.htmlparser.tags.CompositeTag.accept(CompositeTag.java:461)
    org.htmlparser.tags.CompositeTag.accept(CompositeTag.java:461)
    org.htmlparser.Parser.visitAllNodesWith(Parser.java:661)
    org.omegat.filters2.html2.HTMLFilter2.processFile(HTMLFilter2.java:180)
    org.omegat.filters2.AbstractFilter.processFile(AbstractFilter.java:450)
    org.omegat.filters2.AbstractFilter.parseFile(AbstractFilter.java:508)
    org.omegat.filters2.master.FilterMaster.loadFile(FilterMaster.java:204)
    org.omegat.core.data.RealProject.loadSourceFiles(RealProject.java:1149)
    org.omegat.core.data.RealProject.loadProject(RealProject.java:368)
    org.omegat.core.data.ProjectFactory.loadProject(ProjectFactory.java:72)
    
    
当遇到 忽略的 tag 时

    org.omegat.filters2.html2.FilterVisitor#visitTag
    
        if (intactTag) {
            if (text) {
                endup();
            } else {
                flushbefors();
            }
            writeout(tag.toHtml());
            if (tag.getEndTag() != null) {
                recurse = false;
            }
        }
        
        recurse 被置为 false
    后续
    org.htmlparser.tags.CompositeTag#accept
    org.htmlparser.visitors.NodeVisitor#shouldRecurseChildren 返回 false，不再递归
    
但是如果 pre 是纯文本的

    org.htmlparser.tags.CompositeTag#accept
    org.htmlparser.nodes.TextNode#accept
    org.omegat.filters2.html2.FilterVisitor#visitStringNode
    org.omegat.filters2.html2.FilterVisitor#queueTranslatable(org.htmlparser.Text)
    
    private void queueTranslatable(Text txt) {
        if (!txt.toHtml().trim().isEmpty()) {
            translatable.addAll(afters);
            afters.clear();
            translatable.add(txt);
        } else {
            afters.add(txt);
        }
    }
    
    被添加到了 translatable 中。
    然后当处理 </pre> 时
    org.htmlparser.nodes.TagNode#accept
    org.htmlparser.visitors.NodeVisitor#visitEndTag
    org.omegat.filters2.html2.FilterVisitor#endup
    org.omegat.filters2.html2.HTMLFilter2#privateProcessEntry
        ...
        all.addAll(translatable);
        ...
        for (int i = firstgood; i <= lastgood; i++) {
            Node node = all.get(i);
            if (node instanceof Tag) {
                shortcut((Tag) node, paragraph);
            } else { // node instanceof Text
                paragraph.append(HTMLUtils.entitiesToChars(node.toHtml()));
            }
        }
    org.omegat.filters2.html2.HTMLFilter2#privateProcessEntry
    最后又被添加了，
    断点发现， translatable  size 为 1 ，后续 firstgood lastgood 都为 0 类似标题等地方，都会出现这种情况。
    
    因此最后的文问题就是，因此纯文本也应该判断 tag
    但是 pre 此处被解析为 TextNode，TextNode 是没有相关属性的。
    Node
        Tag
            TagNode
        Text
            TextNode
            
            
# pre 标签含有 class 忽略无效
再次下断

    processEntry:606, AbstractFilter (org.omegat.filters2)
    privateProcessEntry:204, HTMLFilter2 (org.omegat.filters2.html2)
    endup:616, FilterVisitor (org.omegat.filters2.html2)
    visitEndTag:321, FilterVisitor (org.omegat.filters2.html2)
    accept:760, TagNode (org.htmlparser.nodes)
    accept:461, CompositeTag (org.htmlparser.tags)
    accept:461, CompositeTag (org.htmlparser.tags)
    accept:461, CompositeTag (org.htmlparser.tags)
    accept:461, CompositeTag (org.htmlparser.tags)
    visitAllNodesWith:661, Parser (org.htmlparser)
    
    看到时一开始的 pre 已经忽略了但是 /pre 又继续处理。
    和之前的 code 标签一样，
    <pre></pre> 被解析为 一个 Tag 一个 Text 加一个 End
    于是手动添加 pre 标签的解析。
    
    成功。