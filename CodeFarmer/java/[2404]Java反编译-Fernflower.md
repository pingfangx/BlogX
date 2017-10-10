[md]

使用 AndroidStudio 的时候发现反编译用的 Fernflower，搜了一下。  
找到[FernFlower - CLI Java Decompiler](http://the.bytecode.club/showthread.php?tid=5)  
[github 开源](https://github.com/JetBrains/intellij-community/tree/master/plugins/java-decompiler/engine/src/org/jetbrains/java/decompiler)  
[gui](https://github.com/Konloch/bytecode-viewer/releases)

```
Fernflower is an easy to use yet advanced cli Java decompiler.

Download, READ THIS!

FernFlower has recently become open sourced, you can view the repo at https://github.com/JetBrains/intellij-co...decompiler

If you're looking for GUI FernFlower, download Bytecode Viewer - https://github.com/Konloch/bytecode-viewer/releases

Basic Decompile:
Code:
java -jar fernflower.jar jarToDecompile.jar decomp/

With that fernflower will decompile jarToDecompile.jar and put the Java files into decomp/jarToDecompile.jar (Remember, jar is simply a .zip archive, so open it with any zip reader)

If you run into the issue with people obfuscating as aa aA and you can't reobfuscate for some reason, fernflower has a neat ability that allows you to rename all of the classes/fields/methods to class1, class2, etc.

Code:
java -jar fernflower.jar -ren=1 jarToDecompile.jar decomp/

For more options, read the FernFlower documentation here.

These are just some of the awesome things you can do with fernflower, go download it and try it out!
```

[/md]