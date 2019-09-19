Jadx 
下载源码后，直接运行 jadx-gui
# 点击时

    1 = {StackTraceElement@7069} "jadx.gui.ui.codearea.CodeArea.<init>(CodeArea.java:62)"
    2 = {StackTraceElement@7070} "jadx.gui.ui.codearea.CodePanel.<init>(CodePanel.java:26)"
    3 = {StackTraceElement@7071} "jadx.gui.ui.TabbedPane.makeContentPanel(TabbedPane.java:180)"
    4 = {StackTraceElement@7072} "jadx.gui.ui.TabbedPane.getContentPanel(TabbedPane.java:151)"
    5 = {StackTraceElement@7073} "jadx.gui.ui.TabbedPane.showCode(TabbedPane.java:68)"
    6 = {StackTraceElement@7074} "jadx.gui.ui.TabbedPane.codeJump(TabbedPane.java:111)"
    7 = {StackTraceElement@7075} "jadx.gui.ui.MainWindow.treeClickAction(MainWindow.java:334)"
    
    jadx.gui.ui.codearea.CodeArea#CodeArea
		setText(node.getContent());
    内容即为代码，node 从何处来
    
    
# 打开文件时
    1 = {StackTraceElement@5590} "jadx.gui.treemodel.JClass.update(JClass.java:63)"
    2 = {StackTraceElement@5591} "jadx.gui.treemodel.JPackage.update(JPackage.java:61)"
    3 = {StackTraceElement@5592} "jadx.gui.treemodel.JPackage.<init>(JPackage.java:36)"
    4 = {StackTraceElement@5593} "jadx.gui.treemodel.JSources.getHierarchyPackages(JSources.java:57)"
    5 = {StackTraceElement@5594} "jadx.gui.treemodel.JSources.update(JSources.java:40)"
    6 = {StackTraceElement@5595} "jadx.gui.treemodel.JSources.<init>(JSources.java:29)"
    7 = {StackTraceElement@5596} "jadx.gui.treemodel.JRoot.update(JRoot.java:32)"
    8 = {StackTraceElement@5597} "jadx.gui.treemodel.JRoot.<init>(JRoot.java:27)"
    9 = {StackTraceElement@5598} "jadx.gui.ui.MainWindow.initTree(MainWindow.java:276)"
    10 = {StackTraceElement@5599} "jadx.gui.ui.MainWindow.openFile(MainWindow.java:206)"
    11 = {StackTraceElement@5600} "jadx.gui.ui.MainWindow.openFile(MainWindow.java:196)"
    
所以最重要的是 wrapper

    jadx.gui.JadxWrapper
    
# 打开无法反编译的代码
    Caused by: jadx.core.utils.exceptions.DecodeException: Unknown instruction: 'invoke-custom'
        at jadx.core.dex.instructions.InsnDecoder.decode(InsnDecoder.java:581)
        at jadx.core.dex.instructions.InsnDecoder.process(InsnDecoder.java:74)
        at jadx.core.dex.nodes.MethodNode.load(MethodNode.java:104)
        
    com.android.dx.io.OpcodeInfo#INVOKE_CUSTOM
    INVOKE_CUSTOM = new OpcodeInfo.Info(252, "invoke-custom", InstructionCodec.FORMAT_35C, IndexType.CALL_SITE_REF);
    
    根据 decode 中前面的代码
    case Opcodes.INVOKE_STATIC:
        return invoke(insn, offset, InvokeType.STATIC, false);

    case Opcodes.INVOKE_STATIC_RANGE:
        return invoke(insn, offset, InvokeType.STATIC, true);
    添加 INVOKE_CUSTOM 枚举，加入 case
    case Opcodes.INVOKE_CUSTOM:
        return invoke(insn, offset, InvokeType.CUSTOM, false);
    不再报错，但是不知道是否正确。