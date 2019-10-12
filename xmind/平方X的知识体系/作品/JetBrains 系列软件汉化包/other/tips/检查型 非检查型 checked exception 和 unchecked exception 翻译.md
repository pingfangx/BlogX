# 检查型异常和非检查型异常
[checked/unchecked应该翻译成什么？](https://codemany.com/blog/what-should-checked-and-unchecked-translate/)

> 《Java核心技术》将它们翻译成“已检查/未检查”。《Java编程思想》和《Effictive Java中文版》则翻译成“被检查的/不检查的”。至于技术文章的翻译更是花样百出，有“检测/非检测”、“可检测/非检测”、“可查/不可查”、“受查/非受查”、“检查型/非检查型”、“检查/非检查”等。

> 从上述的描述可以得出，“checked异常”和“unchecked异常”是两种异常类型，且“checked异常”隐含有必须要检查的思想。

> 紧紧围绕这些描述，细细地思考和比较，个人认为：1. 《Java核心技术》的翻译存在问题，“已检查”和“未检查”说明的是异常的检查状态，没有表达出异常的分类这个概念。2. 《Java编程思想》和《Effictive Java中文版》的翻译则正确地表达了异常的分类，但“被检查”翻译的有点无厘头，如果能改成“要检查”则会更好，缺陷是连接“异常”这个词组后是短语，而非名词，读来费劲，也不上口；如果去掉“的”的话，后者会有歧义，听起来像是命令。3. “检测/非检测”和“检查/非检查”是同个意思。4. “可检测”这个翻译看上去似乎表示异常是可以检查的，和Java语言规范要求的该类异常必须要检查不符。5. “可查/不可查”也是如此。6. “受查/非受查”的翻译则有些莫名其妙的感觉。7. “检查型/非检查型”翻译的很好，既表达了异常的分类，也表达了一种异常是要检查的，另一种异常是不要检查的意义，只是前者还缺少点强制的意味。

> 分析到这里，结果已经是不言而明。“要检查的/不检查的”和“检查型/非检查型”是两种更好的翻译，都能把Java语言规范对checked/unchecked异常的描述尽量地表述出来。而后者在实际使用中更为简洁适宜。

> 接下来的事情就是把以前译文中未翻译的checked/unchecked修改成“检查型/非检查型”。在以后的翻译中也继续使用这个翻译结果，除非能找到更好的表述方式。


文章分析的很好，检查型/非检查型也是我接受的译法。

相关原文为
> The first kind of exception is the checked exception. These are exceptional conditions that a well-written application should anticipate and recover from. 

> Here's the bottom line guideline: If a client can reasonably be expected to recover from an exception, make it a checked exception. If a client cannot do anything to recover from the exception, make it an unchecked exception.

所以这里的检查型或许可以理解为，开发者应该 **检查** 异常，以进行恢复。  
而非检查型异常（错误和运行时异常），应用程序通常无法预测或恢复


# 未经检查的警告
这里还有一个  unchecked warning
> gives an unchecked warning, since this isn't something the runtime system is going to check for you.

> The term "unchecked" means that the compiler does not have enough type information to perform all type checks necessary to ensure type safety.

根据这两条，似乎也可以翻译为非检查型警告，但是却有官方汉化的对比  
使用 

    -Duser.language=en
    -Duser.region=US

    Information:java: ..Test.java uses unchecked or unsafe operations.
    Information:java: Recompile with -Xlint:unchecked for details.
    中文为
    Information:java: ..Test.java使用了未经检查或不安全的操作。
    Information:java: 有关详细信息, 请使用 -Xlint:unchecked 重新编译。

所以还是翻译为 **未经检查的警告**

同理异常部分却是

    Error:(20, 9) java: unreported exception java.io.FileNotFoundException; must be caught or declared to be thrown    
    Error:(20, 9) java: 未报告的异常错误java.io.FileNotFoundException; 必须对其进行捕获或声明以便抛出
    
    以后如果发现再进行对比。
    
    
# 官方译文
    在 1.6 的 java api 中文版中
    api/java/util/package-summary.html
    译为了 未经检查的异常
    
    api/java/lang/reflect/package-summary.html
    译为了 经过检查的异常