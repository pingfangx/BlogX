[md]

[Airsaid《Android 中注解的使用》](https://juejin.im/post/59bf5e1c518825397176d126)

# 0x01 读完后主要想了解所有的注解。

官方文档[注解支持库](https://developer.android.google.cn/topic/libraries/support-library/features.html#annotations)

转到
[android.support.annotation](https://developer.android.google.cn/reference/android/support/annotation/package-summary.html)

# 0x02 汉化 annotation 包
## 为 package-summary.html 生成伪翻译文件
```
java -jar "D:\xx\software\program\OmegaT_4.1.2_01_Beta_Without_JRE\OmegaT2.jar" "D:\workspace\TranslatorX\AndroidSdkDocs" --mode=console-createpseudotranslatetmx --pseudotranslatetmx=project_save.tmx --pseudotranslatetype=equal
@pause
```
参考[使用注解改进代码检查](https://developer.android.com/studio/write/annotations.html?hl=zh-cn)  
[汉化结果](https://github.com/pingfangx/TranslatorX/tree/android_sdk_docs/AndroidSdkDocs/target/docs/reference/android/support/annotation)


# 0x03 更多
## 3.1 所有的资源类型
通过 [android.R](https://developer.android.google.cn/reference/android/R.html) 知道有

class	R.anim
 
class	R.animator
 
class	R.array
 
class	R.attr
 
class	R.bool
 
class	R.color
 
class	R.dimen
 
class	R.drawable
 
class	R.fraction
 
class	R.id
 
class	R.integer
 
class	R.interpolator
 
class	R.layout
 
class	R.menu
 
class	R.mipmap
 
class	R.plurals
 
class	R.raw
 
class	R.string
 
class	R.style
 
class	R.styleable
 
class	R.transition
 
class	R.xml


通地[Resource Types](https://developer.android.google.cn/guide/topics/resources/available-resources.html)了解一下
## 3.1.1 fraction
android.content.res.Resources#getFraction
```
Retrieve a fractional unit for a particular resource ID.
Parameters
id int: The desired resource identifier, as generated by the aapt tool. This integer encodes the package, type, and resource entry. The value 0 is an invalid identifier.
base int: The base value of this fraction. In other words, a standard fraction is multiplied by this value.
pbase int: The parent base value of this fraction. In other words, a parent fraction (nn%p) is multiplied by this value.
```
如果是标准小数，会乘以 base ，如果是 nn%p 的形式，会乘以 pbase。  
源码为
```
android.content.res.Resources#getFraction
android.util.TypedValue#complexToFraction
    public static float complexToFraction(int data, float base, float pbase)
    {
        switch ((data>>COMPLEX_UNIT_SHIFT)&COMPLEX_UNIT_MASK) {
        case COMPLEX_UNIT_FRACTION:
            return complexToFloat(data) * base;
        case COMPLEX_UNIT_FRACTION_PARENT:
            return complexToFloat(data) * pbase;
        }
        return 0;
    }
```
## 3.1.2 interpolator
[Animation Resources](https://developer.android.google.cn/guide/topics/resources/animation-resource.html#Tween) 中有介绍
## 3.1.3 plurals
[Quantity Strings (Plurals)](https://developer.android.google.cn/guide/topics/resources/string-resource.html#Plurals)
* android.content.res.Resources#getQuantityText
* android.content.res.Resources#getQuantityString(int, int)
* android.content.res.Resources#getQuantityString(int, int, java.lang.Object...)
## 3.1.4 transition
[转换可绘制对象](https://developer.android.google.cn/guide/topics/resources/drawable-resource.html#Transition)  
[TransitionDrawable](https://developer.android.google.cn/reference/android/graphics/drawable/TransitionDrawable.html)
## 3.1.5 xml

# 3.2 音标
* dimension  [daɪˈmenʃn] 
* fraction [ˈfrækʃn] 
* interpolator  [ɪn'tɜ:pəʊleɪtə] 
* plural [ˈplʊərəl] 
* quantity [ˈkwɒntəti]

[/md]