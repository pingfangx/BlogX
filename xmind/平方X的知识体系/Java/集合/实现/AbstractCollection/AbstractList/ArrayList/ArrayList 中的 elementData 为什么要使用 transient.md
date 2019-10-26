R:
* 《JLS 8》8.3.1.3

> 变量可以被标记为 transient，以表明它们不是对象的持久状态的一部分。

ArrayList 实现 Serializable，transient 不会被默认序列化（在调用 defaultWriteObject 和 defaultReadObject 时不会处理）

