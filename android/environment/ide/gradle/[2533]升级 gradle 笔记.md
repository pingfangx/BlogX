# 1 项目 build.gradle 的修改
## com.android.tools.build:gradle:3.1.2
升级由这个开始

## gradle-4.4-all.zip
>Caused by: java.lang.RuntimeException: Minimum supported Gradle version is 4.4. Current version is 3.3. If using the gradle wrapper, try editing the distributionUrl in ..\gradle\wrapper\gradle-wrapper.properties to gradle-4.4-all.zip

gradle-wrapper 中升级为 gradle-4.4-all.zip

## buildToolsVersion 升级为 27.0.3
> The specified Android SDK Build Tools version (26.0.3) is ignored, as it is below the minimum supported version (27.0.3) for Android Gradle Plugin 3.1.2.
Android SDK Build Tools 27.0.3 will be used.
To suppress this warning, remove "buildToolsVersion '26.0.3'" from your build.gradle file, as each version of the Android Gradle Plugin now has a default version of the build tools.

## compileSdkVersion 升级为 27（后降回 26）

## androidSupportVersion 升级为 27.1.1 （后来有问题降回 26.1.0）
>This support library should not use a different version (26) than the compileSdkVersion (27) (Ctrl+F1)   
There are some combinations of libraries, or tools and libraries, that are incompatible, or can lead to bugs. One such incompatibility is compiling with a version of the Android support libraries that is not the latest version (or in particular, a version lower than your targetSdkVersion).

以及
> All com.android.support libraries must use the exact same version specification (mixing versions can lead to runtime crashes). 

但是修改后
>Program type already present: android.support.v4.view.ViewPager$ViewPositionComparator    

原因是 support-core-ui 和 support-v4-24.3 中都有  
查找未找到失用，降回 26.1.0 后，发现 support-v4-26.1.0 中为空，并没有别的文件。

后来学习了 gradle 后使用 :app:dependencies 命令知道是七鱼客服使用的，又是它！

# 2 app 中 build.gradle 的修改
## output.outputFile 改为 outputFileName
> Cannot set the value of read-only property 'outputFile'

指定输出 apk 名时遇到  
[https://stackoverflow.com/questions/44239235/](https://stackoverflow.com/questions/44239235/)  
[API changes](https://developer.android.com/studio/build/gradle-plugin-3-0-0-migration.html#variant_api)  
>Use all() instead of each()  
Use outputFileName instead of output.outputFile if you change only file name (that is your case)

## 添加 flavorDimensions
>All flavors must now belong to a named flavor dimension

[Declare flavor dimensions](https://developer.android.com/studio/build/gradle-plugin-3-0-0-migration.html?utm_source=android-studio#flavor_dimensions)  
需要声明 flavorDimensions  
然后为每一个 flavor 指定 dimension，如果 flavorDimensions 只有一个则不需要都指定。

## 添加 annotationProcessor
> Annotation processors must be explicitly declared now

使用了 butterknife 遇到。  
[Use the annotation processor dependency configuration](https://developer.android.com/studio/build/gradle-plugin-3-0-0-migration.html?utm_source=android-studio#annotationProcessor_config)  
顺便再次吐槽国内的博客各种抄，官网明明写了不推荐用 includeCompileClasspath ，还要用。  
加上 annotationProcessor 就可以了，我一开始以为要指定 Processor 的名字，查了一下，只要指定 butterknife 就好了。

## 升级七鱼
> Error: style attribute '@android:attr/windowExitAnimation' not found

[Error: style attribute '@android:attr/windowExitAnimation' not found](https://stackoverflow.com/questions/45952607/)  
```
Solution:
Removing the "@" at the start of the item name.

<item name="@android:windowEnterAnimation">@anim/anim_toast_show</item>
<item name="@android:windowExitAnimation">@anim/anim_toast_hide</item>
to:

<item name="android:windowEnterAnimation">@anim/anim_toast_show</item>
<item name="android:windowExitAnimation">@anim/anim_toast_hide</item>
```
在项目中是因为引入了七鱼的库，没有修改，将其升级为新版本后修复。

# 3 依赖的修改  
## 修改 repositories
        /**
         * 在构建的时候，在非离线模式
         * 每一个模块的每一种构建类型的每一种源集，都会从每一个仓库中解析依赖（针对未解析成功的）
         * module * buildType * sourceSet * repository * dependency
         * 为了减少解析资数，加快构建速度，可依次优化每个因子
         */

## 修改 dependencies
    compile 改为 implementation 、api 或 compileOnly
    
    implementation 只在模块中使用
    api 引用该子模块的模块中，可以使用 api 解析的依赖
    compileOnly 仅用来编译，实际运行时主模块中已有了（这里好像使用 implementation 也可以，可能是自动合并了）
    
## 修改 gradle.properties
> org.gradle.internal.resource.transport.http.HttpRequestException: Could not HEAD  
Caused by: org.apache.http.conn.HttpHostConnectException: Connect to 127.0.0.1:1080 [/127.0.0.1] failed: Connection refused: connect

ip 和端口确实是我设的代理，但是明明禁用了代理。  
后来发现项目目录有 gradle.properties 文件中有代理设置  
修改后还是无效，又修改 C:\Users\Admin\.gradle\gradle.properties