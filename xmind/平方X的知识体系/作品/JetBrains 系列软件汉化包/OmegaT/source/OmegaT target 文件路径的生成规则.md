# 堆栈
    1 = {StackTraceElement@6966} "org.omegat.filters2.master.FilterMaster.constructTargetFilename(FilterMaster.java:612)"
    2 = {StackTraceElement@6967} "org.omegat.filters2.master.FilterMaster.getTargetForSource(FilterMaster.java:531)"
    3 = {StackTraceElement@6968} "org.omegat.filters2.master.FilterMaster.getTargetForSource(FilterMaster.java:525)"
    4 = {StackTraceElement@6969} "org.omegat.core.data.RealProject.getTargetPathForSourceFile(RealProject.java:1636)"
    5 = {StackTraceElement@6970} "org.omegat.gui.editor.EditorController.getCurrentTargetFile(EditorController.java:690)"
    6 = {StackTraceElement@6971} "org.omegat.gui.main.MainWindowMenuHandler.projectAccessCurrentTargetDocumentMenuItemActionPerformed(MainWindowMenuHandler.java:326)"

通过方法中相关占位符的替换，我们可以知道应该是可以配置的

文档位于 [3.3. 目标文件名](https://omegat.sourceforge.io/manual-latest/zh_CN/chapter.file.filters.html#target.name) 

在 文件过滤器 > 编辑中可以配置

但是不满足原来的需求（只有 tips 目录的文件生成到 tips_zh_CN）