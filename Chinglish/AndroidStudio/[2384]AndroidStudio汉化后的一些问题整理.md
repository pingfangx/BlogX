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


[/md]