# 发现过滤规则无效
在 org.htmlparser.tags.CompositeTag#accept 中使用 getChildrenAsNodeArray() 查看

    发现 <td> 与 </td> 被解析为一个 TableRow  
    而 <code> 与 </code> 却被解析为一个 TagNode 加一个 TextNode 再加一个 TagNode
    于是，判断时 TagNode 被过滤了，但是随后又处理 TextNode 添加。
    而 TableRow 则是直接就被过滤，查看 TableRow 的创建。

    <init>:58, TableRow (org.htmlparser.tags)
    registerTags:318, PrototypicalNodeFactory (org.htmlparser)
    <init>:179, PrototypicalNodeFactory (org.htmlparser)
    <init>:164, PrototypicalNodeFactory (org.htmlparser)
    <init>:264, Parser (org.htmlparser)
    <init>:246, Parser (org.htmlparser)
    processFile:182, HTMLFilter2 (org.omegat.filters2.html2)
    processFile:450, AbstractFilter (org.omegat.filters2)
    parseFile:508, AbstractFilter (org.omegat.filters2)
    loadFile:204, FilterMaster (org.omegat.filters2.master)
    loadSourceFiles:1149, RealProject (org.omegat.core.data)
    loadProject:368, RealProject (org.omegat.core.data)
    loadProject:72, ProjectFactory (org.omegat.core.data)
    lambda$doInBackground$0:591, ProjectUICommands$7 (org.omegat.gui.main)

    创建位于 org.htmlparser.PrototypicalNodeFactory#createTagNode
    
    于是在 org.omegat.filters2.html2.HTMLFilter2#processFile
    
        Parser parser = new Parser();
        创建后注册
        TagUtils.registerTag(parser);
        
    public static void registerTag(Parser parser) {
        NodeFactory nodeFactory = parser.getNodeFactory();
        if (nodeFactory instanceof PrototypicalNodeFactory) {
            ((PrototypicalNodeFactory) nodeFactory).registerTag(new CodeTag());
        }
    }