Q:
* gradle 基础知识
* 点运行的时候，做了什么操作
* compile 与 implemetion

# 0x01 相关网址
[https://gradle.org/](https://gradle.org/)

[Gradle User Manual](https://docs.gradle.org/current/userguide/userguide.html)

[Gradle User Guide 中文版](https://github.com/DONGChuan/GradleUserGuide)

> Gradle is an open-source build automation tool focused on flexibility and performance. Gradle build scripts are written using a Groovy or Kotlin DSL. Read about Gradle features to learn what is possible with Gradle.

> 领域特定语言（英语：domain-specific language、DSL）指的是专注于某个应用程序领域的计算机语言。又译作领域专用语言。




# 0x02 文档部分目录

## 安装
* 下载解压
* 配置环境变量

## Initialize a project
gradle init  
各文件的作用
![](https://pingfangx.github.io/resource/blogx/2534/1.png)

## Create a task
./gradlew.bat copy

## Discover available tasks
## Analyze and debug your build
## Discover available properties
## Command-Line Interface
## Common tasks

> There are many JVM options ([this blog post on Java performance tuning](https://dzone.com/articles/java-performance-tuning) and [this reference](http://www.oracle.com/technetwork/java/javase/tech/vmoptions-jsp-140102.html) may be helpful).

> A daemon is a computer program that runs as a background process, rather than being under the direct control of an interactive user.

## Initialization Scripts
## Building Android Apps
这里面详细介绍了 AndroidStudio 构建的相关


![](https://pingfangx.github.io/resource/blogx/2534/2.png)


## Gradle Build Language Reference
## Improving the Performance of Gradle Builds
## Dependency Management
### Managing Transitive Dependencies

# 0x03 Gradle Wrapper
[The Gradle Wrapper](https://docs.gradle.org/current/userguide/gradle_wrapper.html)  
一开始理解 Wrapper 是不是用来指定 Gradle 的版本的，后来发现，其实 Gradle Wrapper 只是用来避免安装 Gradle 的。  
应该也是避免频繁手动安装不同版本的 Gradle  
> The recommended way to execute any Gradle build is with the help of the Gradle Wrapper (in short just “Wrapper”). The Wrapper is a script that invokes a declared version of Gradle, downloading it beforehand if necessary. As a result, developers can get up and running with a Gradle project quickly without having to follow manual installation processes saving your company time and money.

> It is recommended to always execute a build with the Wrapper to ensure a reliable, controlled and standardized execution of the build. Using the Wrapper looks almost exactly like running the build with a Gradle installation. Depending on the operating system you either run gradlew or gradlew.bat instead of the gradle command. The following console output demonstrate the use of the Wrapper on a Windows machine for a Java-based project.


也就是说 gradlew 的 w 其实应该就是 wrapper 的意思，gradlew 能执行的任务，也可以直接用 gradle 来执行。  
gradlew 是使用 gradle-wrapper.properties 中指定下载路径、指定版本的 gradle 执行  
而 gradle 则是使用系统内安装的 gradle 来执行。


# 0x04 Gradle 中的相关版本的配置
[Building Android Apps](https://guides.gradle.org/building-android-apps/)

[Everything you need to build on Android](https://developer.android.com/studio/features/)

## gradle-wrapper.properties
用来指定 gradle 的版本

## com.android.tools.build:gradle:3.1.2
> The Android Studio build system is based on Gradle, and the Android plugin for Gradle adds several features that are specific to building Android apps. Although the Android plugin is typically updated in lock-step with Android Studio, the plugin (and the rest of the Gradle system) can run independent of Android Studio and be updated separately.

指定安卓的（gradle 中使用的）构建插件的版本，可能需要匹配的 gradle 版本

## compileSdkVersion
编译的 sdk 版本

## buildToolsVersion
> Android SDK Build-Tools is a component of the Android SDK required for building Android apps. It's installed in the <sdk>/build-tools/ directory.

构建工具的版本，与 sdk 接近，在 SDK Tool 中下载。  
上面的构建插件的版本可能限制该 buildToolsVersion

## minSdkVersion
最小 sdk，会限制部分 api 使用

## targetSdkVersion
目标


# 0x05 点运行的时候，做了什么操作
[配置构建](https://developer.android.com/studio/build/)  

[Build System Overview](http://android.xsoftlab.net/sdk/installing/studio-build.html)

这些 tasks 是如何来的呢，应该是 apply plugin: 'com.android.application' 添加的  
[gradle plugins : com.android.application source code](https://stackoverflow.com/questions/35606611)


![](https://pingfangx.github.io/resource/blogx/2534/3.png)

![](https://pingfangx.github.io/resource/blogx/2534/4.png)

在输出中，也可以看到

> Selected primary task ':app:assembleDebug' from project :app

    Tasks to be executed: 
    [task ':app:buildInfoDebugLoader',
     task ':app:preBuild',
     task ':app:preDebugBuild',
     task ':app:compileDebugAidl',
     task ':app:compileDebugRenderscript',
     task ':app:checkDebugManifest',
     task ':app:generateDebugBuildConfig',
     task ':app:prepareLintJar',
     task ':app:mainApkListPersistenceDebug',
     task ':app:generateDebugResValues',
     task ':app:generateDebugResources',
     task ':app:mergeDebugResources',
     task ':app:createDebugCompatibleScreenManifests',
     task ':app:processDebugManifest',
     task ':app:splitsDiscoveryTaskDebug',
     task ':app:processDebugResources',
     task ':app:generateDebugSources',
     task ':app:javaPreCompileDebug',
     task ':app:compileDebugJavaWithJavac',
     task ':app:instantRunMainApkResourcesDebug',
     task ':app:mergeDebugShaders',
     task ':app:compileDebugShaders',
     task ':app:generateDebugAssets',
     task ':app:mergeDebugAssets',
     task ':app:validateSigningDebug',
     task ':app:processInstantRunDebugResourcesApk',
     task ':app:checkManifestChangesDebug',
     task ':app:transformClassesWithExtractJarsForDebug',
     task ':app:transformClassesWithInstantRunVerifierForDebug',
     task ':app:transformClassesWithDependencyCheckerForDebug',
     task ':app:compileDebugNdk',
     task ':app:mergeDebugJniLibFolders',
     task ':app:transformNativeLibsWithMergeJniLibsForDebug',
     task ':app:processDebugJavaRes',
     task ':app:transformResourcesWithMergeJavaResForDebug',
     task ':app:transformNativeLibsAndResourcesWithJavaResourcesVerifierForDebug',
     task ':app:transformClassesWithInstantRunForDebug',
     task ':app:transformClassesEnhancedWithInstantReloadDexForDebug',
     task ':app:incrementalDebugTasks',
     task ':app:preColdswapDebug',
     task ':app:fastDeployDebugExtractor',
     task ':app:generateDebugInstantRunAppInfo',
     task ':app:transformClassesWithInstantRunSlicerForDebug',
     task ':app:transformClassesWithDexBuilderForDebug',
     task ':app:transformDexArchiveWithExternalLibsDexMergerForDebug',
     task ':app:transformDexArchiveWithDexMergerForDebug',
     task ':app:transformDexWithInstantRunDependenciesApkForDebug',
     task ':app:transformDexWithInstantRunSlicesApkForDebug',
     task ':app:packageDebug',
     task ':app:buildInfoGeneratorDebug',
     task ':app:compileDebugSources',
     task ':app:assembleDebug']

 
# 0x06 设置输出 api 的文件名的代码解析

            applicationVariants.all { variant ->
                variant.outputs.all { output ->
                    def outputFile = output.outputFile
                    if (outputFile != null && outputFile.name.endsWith('.apk')) {
                        outputFileName = "**${defaultConfig.versionName}_${releaseTime()}_${variant.productFlavors[0].name}.apk"
                    }
                }
            }
            
在 [Android Plugin for Gradle Release Notes](https://developer.android.com/studio/releases/gradle-plugin)  
给出了一堆参考
> For details about how to configure your Android builds with Gradle, see the following pages:

>[Configure Your Build](https://developer.android.com/studio/build/index.html)  
>[Android Plugin DSL Reference](http://google.github.io/android-gradle-dsl/current/)  
>[Gradle DSL Reference](https://docs.gradle.org/current/dsl/)  
>For more information about the Gradle build system, see the [Gradle user guide](https://docs.gradle.org/current/userguide/userguide.html).

然后简单了解一下 groovy 的语法
[Documentation](http://groovy-lang.org/documentation.html)

* applicationVariants 是 AppExtension 的属性，DomainObjectSet<ApplicationVariant> applicationVariants  
* all 是集合的方法 org.gradle.api.DomainObjectCollection#all(groovy.lang.Closure)  
* Closure 参考 [Closures](http://groovy-lang.org/closures.html)  
* variant 为 ApplicationVariant 继承 BaseVariant
* DomainObjectCollection<BaseVariantOutput> getOutputs();
* BaseVariantOutput 继承 OutputFile
* 但是 outputFileName 如何生效？



# 0x07 compile 与 implemetion
[The Java Library plugin configurations](https://docs.gradle.org/current/userguide/java_library_plugin.html#sec:java_library_configurations_graph)

可以简单根据命名区分。

![](https://pingfangx.github.io/resource/blogx/2534/5.png)

![](https://pingfangx.github.io/resource/blogx/2534/6.png)