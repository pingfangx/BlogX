
[三种方式查看Java类字节码](https://blog.csdn.net/kwame211/article/details/77677662)

# 1 命令行
    javap
    javac

# 2 jclasslib
[ingokegel/jclasslib](https://github.com/ingokegel/jclasslib)

插件搜索 jclasslib 安装即可。  
View > Show Bytecode With jclasslib

jclasslib 插件是通过 java 文件找到对应的 class 文件，但是如果未编译就无法找到。  
需要 build 一下。

# 3 External Tools
Setting > Tools > External Tools  
## javac
见 javac.md

## javap
见 javap.md

# 4 Byte Code Viewer
idea 的内置插件，也挺好用的。
