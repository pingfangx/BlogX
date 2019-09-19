```
**该修改被撤销，还是在生成后用 python 再处理**
在 org.omegat.gui.main.MainWindowMenu 找到 org.omegat.gui.main.MainWindowMenu#projectCompileMenuItem
点击事件在 org.omegat.gui.main.MainWindowMenuHandler#projectCompileMenuItemActionPerformed
org.omegat.gui.main.ProjectUICommands#projectCompile
org.omegat.core.data.IProject#compileProject
org.omegat.core.data.RealProject#compileProject(java.lang.String)
org.omegat.core.data.RealProject#compileProjectAndCommit
org.omegat.filters2.master.FilterMaster#translateFile
org.omegat.filters2.AbstractFilter#translateFile
org.omegat.filters2.AbstractFilter#processFile(java.io.File, java.io.File, org.omegat.filters2.FilterContext)
java.io.BufferedWriter#close
org.omegat.filters2.html2.HTMLWriter#close
org.omegat.filters2.html2.HTMLWriter#flush
```
