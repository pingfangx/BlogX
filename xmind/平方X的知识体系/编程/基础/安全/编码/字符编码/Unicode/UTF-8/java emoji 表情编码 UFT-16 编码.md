# 
[Unicode Character 'FACE WITH TEARS OF JOY' (U+1F602)](https://www.fileformat.info/info/unicode/char/1f602/index.htm)

    😂
    以笑哭表情为例
    
    U+1F602

    codePointAt 为 128514

    0x1F602=128514

    toCharArray 由两个 char 表示

    '\uD83D' 55357
    '\uDE02' 56834


    为什么会是 0xD83D 0xDE02 呢？
    因为使用的 UTF-16
    
[Which encoding does Java uses UTF-8 or UTF-16? - Stack Overflow](https://stackoverflow.com/questions/39955169/which-encoding-does-java-uses-utf-8-or-utf-16)

[UTF-16 - 维基百科](https://zh.wikipedia.org/wiki/UTF-16)

之前翻译 Java Tutorials 的时候也有介绍过

[称为代理的补充字符(Java? 教程-Java Tutorials 中文版>国际化>使用文本)](https://pingfangx.github.io/java-tutorials/i18n/text/supplementaryChars.html)

    0x1F602
    
    减去 0x10000
    得到 0xF602
    表示为 20 位的二进制    0b0000111101 1000000010
    高 10 位加上 0xD800
    0xD800+0b0000111101=55357
    转为十六进制  0xD83d
    
    低 10 位加上 0xDC00
    0xDC00+0b1000000010=56843
    转为十六进制  0xDE02
    
    
# 简述一下如何表示 emoji
## 获取 unicode
使用 codePointAt 获取代码点，转为十六进制

## 用 UTF-16 编码
* 减去 0x10000，转为 20 位二进制
* 高十位加上 0xD800
* 低十位加上 0xDC00