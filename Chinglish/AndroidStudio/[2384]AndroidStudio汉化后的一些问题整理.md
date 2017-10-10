[md]

>本文由平方X发表于平方X网，转载请注明出处。[http://blog.pingfangx.com/2384.html](http://blog.pingfangx.com/2384.html)

# 0x01 各工具窗口的快捷方式无法打开  
首页的提示中不显示项目视图的快捷捷。  
首先根据之前整理的快捷键，我们知道0-9的功能分别是

* 【Alt+0】激活消息工具窗口(Activate Messages Tool Window)
* 【Alt+1】激活项目工具窗口(Activate Project Tool Window)
* 【Alt+2】激活收藏夹工具窗口(Activate Favorites Tool Window)
* 【Alt+3】激活查找工具窗口(Activate Find Tool Window)
* 【Alt+4】激活运行工具窗口(Activate Run Tool Window)
* 【Alt+5】激活调试工具窗口(Activate Debug Tool Window)
* 【Alt+6】激活TODO工具窗口(Activate TODO Tool Window)
* 【Alt+7】激活结构工具窗口(Activate Structure Tool Window)
* 【Alt+8】激活层次结构工具窗口(Activate Hierarchy Tool Window)
* 【Alt+9】激活版本控制工具窗口(Activate Version Control Tool Window)

经过测试发现，工具窗口命名于
UIBundle.properties，将其恢复即可。
```
tool.window.name.commander=Commander
tool.window.name.messages=Messages
tool.window.name.project=Project
tool.window.name.structure=Structure
tool.window.name.favorites=Favorites
tool.window.name.ant.build=Ant Build
tool.window.name.preview=Preview
tool.window.name.debug=Debug
tool.window.name.run=Run
tool.window.name.find=Find
tool.window.name.cvs=CVS
tool.window.name.hierarchy=Hierarchy
tool.window.name.inspection=Inspection Results
tool.window.name.todo=TODO
tool.window.name.dependency.viewer=Dependency Viewer
tool.window.name.version.control=Version Control
tool.window.name.module.dependencies=Module Dependencies
tool.window.name.tasks=Time Tracking
tool.window.name.database=Database
```

# 0x02 一些词没有被翻译

## 2.1 Rebuild Project
搜索“Rebuild Project”，定位到
\plugins\android\lib\android.jar

解包后再搜索，定位到
\com\android\tools\idea\gradle\actions\RebuildGradleProjectAction.class 

很幸运，jd-gui是可以用的，我们看到
```
public class RebuildGradleProjectAction
  extends AndroidStudioGradleAction
{
  public RebuildGradleProjectAction()
  {
    super("Rebuild Project");
  }
  ...
}
```
举一反三，我们知道，有一些 action 的 text 和 description 是写死在代码里的。所在包有
com.android.tools.idea.actions、com.android.tools.idea.gradle.actions 等。

## 2.2 do not ask me again
退出时的提示  
搜索后发现在lib\idea.jar   
解包后搜索定位到\com\intellij\openapi\application\impl\ApplicationImpl$5.class 



openapi
位于lib\openapi.jar





## 2.3 New
在 File 菜单中第一个就是 New ，一开始无从下手，不知从哪找。  
后来尝试性地用正则搜索“action.*new”，结果找到了META-INF\android-plugin.xml，于是我们知道
### 操作注册于 xml 文件中
分为 group, action等，有一个属性是 popup ，如果是添加的，会有标签 add-to-group ，带有 group-id , anchor , relative-to-action 等属性。  
如
```
<action id="Android.CreateResourcesActionGroup" text="Android resource file" class="org.jetbrains.android.actions.CreateResourceFileActionGroup">
    <add-to-group group-id="NewGroup" anchor="before" relative-to-action="NewFile"/>
</action>
```

### 文件菜单 FileMenu
知道了操作注册于 xml 中后，我们又搜索了一下，知道文件菜单的 group id 为 "FileMenu"，它注册于  
\lib\resources.jar,\idea\PlatformActions.xml
```
    <group id="MainMenu">
      <group id="FileMenu" popup="true">
        <group id="FileOpenGroup">
          <action id="NewDummyProject" class="com.intellij.ide.actions.NewDummyProjectAction" text="New Dummy Project" internal="true"/>
          <action id="OpenFile" class="com.intellij.ide.actions.OpenFileAction" icon="AllIcons.Actions.Menu_open"/>
          <group id="$LRU" popup="true">
            <group id="RecentProjectListGroup" class="com.intellij.ide.actions.RecentProjectsGroup" popup="false"/>
            <separator/>
            <action class="com.intellij.ide.ManageRecentProjectsAction" id="ManageRecentProjects"/>
          </group>
          <action id="CloseProject" class="com.intellij.ide.actions.CloseProjectAction"/>
        </group>
        <separator/>
        <group id="FileMainSettingsGroup">
          <action id="ShowSettings" class="com.intellij.ide.actions.ShowSettingsAction"/>
          <group id="FileOtherSettingsGroup" class="com.intellij.ide.actions.SmartPopupActionGroup">
             <action id="TemplateProjectProperties" class="com.intellij.ide.actions.TemplateProjectPropertiesAction"/>
             <group id="FileSettingsGroup"/>
          </group>
          <separator/>
          <group id="ExportImportGroup">
            <action id="ImportSettings" class="com.intellij.ide.actions.ImportSettingsAction"/>
            <action id="ExportSettings" class="com.intellij.ide.actions.ExportSettingsAction"/>
          </group>
        </group>
        <separator/>
        <action id="SaveAll" class="com.intellij.ide.actions.SaveAllAction" icon="AllIcons.Actions.Menu_saveall"/>
        <action id="Synchronize" class="com.intellij.ide.actions.SynchronizeAction" icon="AllIcons.Actions.Refresh"/>
        <action id="InvalidateCaches" class="com.intellij.ide.actions.InvalidateCachesAction"/>

        <action id="ChangeFileEncodingAction" class="com.intellij.openapi.vfs.encoding.ChangeFileEncodingAction"/>

        <group id="ChangeLineSeparators" text="Line Separators" popup="true" class="com.intellij.ide.actions.NonTrivialActionGroup">
          <action id="ConvertToWindowsLineSeparators" class="com.intellij.codeStyle.ConvertToWindowsLineSeparatorsAction"/>
          <action id="ConvertToUnixLineSeparators" class="com.intellij.codeStyle.ConvertToUnixLineSeparatorsAction"/>
          <action id="ConvertToMacLineSeparators" class="com.intellij.codeStyle.ConvertToMacLineSeparatorsAction"/>
        </group>

        <action id="ToggleReadOnlyAttribute" class="com.intellij.ide.actions.ToggleReadOnlyAttributeAction"/>
        <separator/>
        <action id="Exit" class="com.intellij.ide.actions.ExitAction"/>
      </group>

      <!-- Edit -->
```

搜索了几次 FileMenu 都没有找到想要的结果，再搜索 “FileOpenGroup” 找到 \idea\RichPlatformActions.xml  
翻译测试后成功，要注意的是，这里的 “Product...” ,“Module...” 并不是 AndroidStudio 的，正确的还是在类文件中。  
这里可以汉化 “New” 和 “Project from Version Control”
```
    <!-- File -->
    <group id="OpenProjectGroup">
      <group id="NewElementInMenuGroup" class="com.intellij.ide.actions.NewActionGroup" text="New" popup="true"/>
      <add-to-group group-id="FileOpenGroup" anchor="first"/>
    </group>

    <action id="NewElement" class="com.intellij.ide.actions.NewElementAction"/>

    <group id="NewProjectOrModuleGroup">
      <action id="NewProject" class="com.intellij.ide.actions.NewProjectAction" text="Project..."/>
      <action id="ImportProject" class="com.intellij.ide.actions.ImportProjectAction" text="Project from Existing Sources..."/>
      <group id="NewProjectFromVCS" class="com.intellij.openapi.vcs.checkout.NewProjectFromVCSGroup" text="Project from Version Control" popup="true"/>
      <separator/>
      <action id="NewModule" class="com.intellij.openapi.roots.ui.configuration.actions.NewModuleAction" text="Module..."/>
      <action id="ImportModule" class="com.intellij.ide.actions.ImportModuleAction" text="Module from Existing Sources..."/>
      <separator/>
    </group>

    <action id="SaveAsNewFormat" class="com.intellij.ide.actions.SaveAsDirectoryBasedFormatAction" text="Save as Directory-Based Format...">
      <add-to-group group-id="ExportImportGroup" anchor="last"/>
    </action>
```


[/md]