# 0x00 起因
起因是对属性的注释，我发现使用 # 在属性前注释，行尾注释，PyCharm 都无法进行文档提示。  
几番测试后，根据方法的注释方式，发现在属性下方使用 "" 或者 """""" 注释就有提示了，于是我就这样注释。  
后来看别人的 py 文件，发现并没有这样注释，难道我用错了？  
我查看了 time 等的源码，发现源码也有这样注释的啊，那官方的说明在哪呢？  
于是找了一下。

# 0x01 过程
在 PEP 8 中的 Documentation Strings 提到了
>PEP 257 describes good docstring conventions. 

在 PEP 257 中
>If you violate these conventions, the worst you'll get is some dirty looks. But some software (such as the Docutils [3] docstring processing system [1] [2]) will be aware of the conventions, so following them will get you the best results.

[1] 指的是 PEP 256  
[2] 指的是 PEP 258  

在 PEP 258 中提到
>(This is a simplified version of PEP 224 [2].)

于是查看 PEP 224  
终于找到了自己想要的论证.

# 0x02 汉化
8
20
224
256
257
258
292
484