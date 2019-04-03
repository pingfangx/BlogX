You can configure Gradle wrapper to user distribution with sources. It will provide IDE with Gradle API/DSL documentation.

# 新建项目时的选择
* Use default gradle wrapper (not configured for the current project)
* Use gradle 'wrapper' task configuration (Gradle wrapper customization in build script)
* Use local gradle distribution


当选择 wrapper task configuration 时
报错 
> Gradle version 2.2 is required. Current version is 4.10. If using the gradle wrapper, try editing the distributionUrl in D:\software\JetBrains\apps\IDEA-U\ch-0\183.5153.38\bin\gradle\wrapper\gradle-wrapper.properties to gradle-2.2-all.zip
