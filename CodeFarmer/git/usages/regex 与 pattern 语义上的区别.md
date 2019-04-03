在 java 中

    Pattern = Pattern.compile(String regex)

那 pattern 与 regex 有什么区别呢，取变量名时如何取呢。

    regex=regular expression，指正则表达式
    pattern 表示模式、格式、样式。
    
[differences between PATTERN and regex](https://www.linuxquestions.org/questions/linux-newbie-8/differences-between-pattern-and-regex-4175574095/)

> No, a "regex", or regular expression is a very specific type of pattern.

> A PATTERN as commonly found in man pages and other documentation can sometimes be a regular expression, or it can be any other type pattern recognized by a particular application.

> As used in the locate man page, a PATTERN is any string of characters and may include globbing characters (another form of pattern), but...


所以按个人理解，正则是模式的一种，模式是可以由开发人员定义的。

比如，可以定义 \han 表示汉字之类的。

因此命名的时候，String 可以命名为 regex，Pattern 可以命名为 pattern，与方法签名一致。