# tutorial
### 参数部分
各种类型的参数

### 文档字符串
第一行紧跟在 """ 之后，然后跟空行，这之前看过，后来实际书写时忘记了。

### 推导式（Comprehensions）
可以实现复杂的构造

### 可以用 zip() 函数将其内元素一一匹配。

## Input and Output
### 格式化
其他的修饰符可用于在格式化之前转化值。 '!a' 应用 ascii() ，'!s' 应用 str()，还有 '!r' 应用 repr():
str.rjust() str.ljust() str.center() str.zfill()

# classes
迭代器与生成器。  
迭代器需要  定义一个 __iter__() 方法来返回一个带有 __next__() 方法的对象  

生成器可以帮助实现 __next__() 方法，但它不是必须的。

# stdlib
## glob
## performance-measurement
todo
## doctest 
todo

## struct
使用二进制数据记录格式

## datastructures
### 5.6. 循环的技巧