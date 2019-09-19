群里有人问，就查了一下
看源码
```
com.intellij.idea.Main#main
com.intellij.ide.Bootstrap#main
com.intellij.ide.plugins.PluginManager#start
com.intellij.idea.MainImpl#start
com.intellij.idea.StartupUtil#prepareAndStart
com.intellij.idea.StartupUtil.AppStarter#start
com.intellij.idea.IdeaApplication#IdeaApplication
com.intellij.idea.IdeaApplication.IdeStarter#showSplash
com.intellij.ui.Splash#Splash
    Icon originalImage = IconLoader.getIcon(info.getSplashImageUrl());
com.intellij.openapi.application.impl.ApplicationInfoImpl#getSplashImageUrl
file:/D:/workspace/github/intellij-community/out/production/python-community/pycharm_core_logo.png
```
于是搜索 phpstorm.*logo\.png 结果没有找到，还不如直接去 jar 包看呢。
* AndroidStudio 在 resources.jar!/artwork/studio_splash.png
* IEDA 在 resources.jar!/idea_logo.png
* PhpStorm 在 phpstorm.jar:phpstorm.jar!/artwork/webide_logo.png
* PyCharm 在 pycharm.jar!/pycharm_logo.png
* WebStorm 在 webstorm.jar!/artwork/webide_logo.png