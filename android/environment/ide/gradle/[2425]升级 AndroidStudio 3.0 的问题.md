[md]

# 0x01 安装
## 1.1 升级失败，重新下载安装
## 1.2 相关工具升级


# 0x02 遇到的问题

## 2.1 Cannot set the value of read-only property 'outputFile'
指定输出 apk 名时遇到  
[https://stackoverflow.com/questions/44239235/](https://stackoverflow.com/questions/44239235/)  
[API changes](https://developer.android.com/studio/build/gradle-plugin-3-0-0-migration.html#variant_api)  
>Use all() instead of each()  
Use outputFileName instead of output.outputFile if you change only file name (that is your case)

## 2.2 multidex 解析失败
按推荐的在 repositories 中添加 google

## 2.3 All flavors must now belong to a named flavor dimension
[Declare flavor dimensions](https://developer.android.com/studio/build/gradle-plugin-3-0-0-migration.html?utm_source=android-studio#flavor_dimensions)  
需要声明 flavorDimensions  
然后为每一个 flavor 指定 dimension，如果 flavorDimensions 只有一个则不需要都指定。

## 2.4 Error: style attribute '@android:attr/windowExitAnimation' not found
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

## 2.5 Annotation processors must be explicitly declared now
使用了 butterknife 遇到。  
[Use the annotation processor dependency configuration](https://developer.android.com/studio/build/gradle-plugin-3-0-0-migration.html?utm_source=android-studio#annotationProcessor_config)  
顺便再次吐槽国内的博客各种抄，官网明明写了不推荐用 includeCompileClasspath ，还要用。  
加上 annotationProcessor 就可以了，我一开始以为要指定 Processor 的名字，查了一下，只要指定 butterknife 就好了。

[/md]