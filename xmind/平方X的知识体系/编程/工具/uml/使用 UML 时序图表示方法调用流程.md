学习源码的过程中经常会想要分析调用流程，于是想用 UML 时序图来表示。但是在实际的使用过程中发现对 UML 时序图并不是很熟悉，有时不知道应该怎么表示，于是认真学习一下。



R:

[穿针引线，帮你回忆， 汇总：Android系统启动流程 & 应用程序'进程'启动流程 & 应用'程序'启动流程（框架图、流程图、时序图）](https://www.jianshu.com/p/dea4e834e712)

[Sequence diagram-wikipedia](https://en.wikipedia.org/wiki/Sequence_diagram)

[时序图-wikipedia](https://zh.wikipedia.org/wiki/时序图)

[时序图-百度百科](https://baike.baidu.com/item/时序图)

《UML精粹第三版》第 4 章	顺序图

有示例解释，讲得很详细的

> 第一个消息并无参加者发送，原因是它来自一个不确定的源。这个消息称为基础消息。

《Android开发三剑客——UML、模式与测试》.(王家林)

个人感觉没有干货，但是介绍了 StartUML 的使用，可以在使用过程中加深理解。

[UML建模之时序图（Sequence Diagram）](https://www.cnblogs.com/ywqu/archive/2009/12/22/1629426.html)

S:

# 角色（Actor）

# 对象（Object）

用来表示不同的类

# 生命线（Lifeline）

# 控制焦点(Activation)

这里好像有问题，Focus of Control 表示控制焦点，Activation 表示激活。

> 控制焦点代表时序图中的对象执行一项操作的时期，在时序图中每条生命线上的窄的矩形代表活动期。它可以被理解成C语言语义中一对花括号“{}”中的内容。

# 消息（Message）

## 同步消息=调用消息（Synchronous Message）

## 异步消息（Asynchronous Message）

## 返回消息（Return Message）

# 自关联消息（Self-Message）



# 表示方法调用流程的总结

* 用同步消息表示某个对象的方法调用，如果转到别的类，也就转到了其他类型的对象。
* 创建参加者时可以简单用 new 表示

* 返回消息不是必须的
* 自调用应该在控制焦点内再叠加一个控制焦点，但是为了简洁，可以参照《穿针引线，帮你回忆， 汇总：Android系统启动流程 & 应用程序'进程'启动流程 & 应用'程序'启动流程（框架图、流程图、时序图）》中的示例，将每个方法调用表示为一段控制焦点，转到另一个方法就转到新的控制焦点。

## StarUML 中的名词

* Sequence Diagram
* Object
* Stimulus
* SelfStimulus



# PlantUML

最后选择 [Plant-UML 时序图](http://plantuml.com/zh/sequence-diagram)