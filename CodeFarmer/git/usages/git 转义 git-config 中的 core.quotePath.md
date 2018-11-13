在 git-config 的帮助中，有关

core.quotePath

> e.g. octal \302\265 for "micro" in UTF-8

在这里疑惑了，之前简单学习了编码，micro 怎么会表示成 \302\265 呢  
于是查了一下

[MICRO SIGN](http://www.cogsci.ed.ac.uk/~richard/utf-8.cgi?input=%C2%B5&mode=char)
    
    Character    µ
    Character name    MICRO SIGN
    Hex UTF-8 bytes    C2 B5
    Octal UTF-8 bytes    302 265
    
原来是指一个符号

# 接下来我们看如何表示
    \302\265
    ['c2', 'b5']
    utf-8 十六进制 0xc2b5
    utf-8 二进制 0b1100001010110101
    按 8 位分隔
    ['11000010', '10110101']
    按 utf-8 规则取有效位
    ['00010', '110101']
    合并二进制 0b00010110101
    unicode 十进制 181
    unicode 十六进制 0xb5
    最终结果 µ
    
    根据 b5 查询 unicode，结果一致
    
    