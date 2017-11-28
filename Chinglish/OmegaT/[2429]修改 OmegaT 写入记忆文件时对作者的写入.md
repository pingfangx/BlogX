[md]

有时候会校验记忆文件，校验后作者就丢失了，索性都删掉好了，以免每次修改都会发生改变。

搜索 saveMenu ，一路找到
org.omegat.gui.main.MainWindowMenuHandler#projectSaveMenuItemActionPerformed
org.omegat.gui.main.ProjectUICommands#projectSave
org.omegat.core.data.RealProject#saveProject
org.omegat.core.data.ProjectTMX#save
org.omegat.core.data.ProjectTMX#exportTMX
org.omegat.util.TMXWriter2#writeEntry(java.lang.String, java.lang.String, org.omegat.core.data.TMXEntry, java.util.List<java.lang.String>)
org.omegat.util.TMXWriter2#writeEntry(java.lang.String, java.lang.String, java.lang.String, java.lang.String, long, java.lang.String, long, java.util.List<java.lang.String>)
在此处会保存作者、时间等

org.omegat.core.data.RealProject#setTranslation(org.omegat.core.data.SourceTextEntry, org.omegat.core.data.PrepareTMXEntry, boolean, org.omegat.core.data.TMXEntry.ExternalLinked)
在此处设置


[/md]