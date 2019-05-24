[r8 / r8](https://r8.googlesource.com/r8)

[R8 compatibility FAQ](https://r8.googlesource.com/r8/+/refs/heads/master/compatibility-faq.md)
> R8 integrates desugaring, shrinking, obfuscating, optimizing, and dexing all in one step—resulting in noticeable build performance improvements. R8 was introduced in Android Gradle plugin 3.3.0 and is now enabled by default for both app and Android library projects using plugin 3.4.0 and higher.
> The image below provides a high-level overview of the compile process before R8 was introduced.
![](https://developer.android.com/studio/images/build/r8/compile_with_d8_proguard.png)

> Now, with R8, desugaring, shrinking, obfuscating, optimizing, and dexing (D8) are all completed in one step, as illustrated below.
![](https://developer.android.com/studio/images/build/r8/compile_with_r8.png)


# desugaring
[Android Studio 3.0+ 新Dex编译器D8 Desugar R8](https://www.jianshu.com/p/bb6fb79dab17)  
文章中有脱糖的介绍，而来源自然是  
[语法糖（Syntactic sugar）](https://zh.wikipedia.org/wiki/%E8%AF%AD%E6%B3%95%E7%B3%96)