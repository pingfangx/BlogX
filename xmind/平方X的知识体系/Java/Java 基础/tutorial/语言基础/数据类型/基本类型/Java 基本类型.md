基本类型知识点不太多，主要包括

* 占用大小

* 字段默认值

* 字面量

整理表

类型|占用大小|最小值|最大值|字段默认值|示例字面量
-|-|-|-|-|-
byte|8|-128|127|0|
short|16|-32668|32727|0|
int|32|-2^31|2^31-1|0|0b1,0xA,1_234
long|64|-2^63|2^63-1|0L|
float|32|||0.0F|1.234E2
double|64|||0.0D|
boolean|未精确定义|1|0|false|
char|16|'\u0000'|'\uffff'|'\u0000'|
对象||||null|

# 其他一些注意的点
## 下划线
java 7 添加的，注意有位置限制，不能随意放置

## int 和 long 最大值
java 8 以后可以表示无符号类型。

TODO
* 为什么说 booleand 的大不未精确定义  
可能需要查看规范
> This data type represents one bit of information, but its "size" isn't something that's precisely defined.
* 如何确定一个变量的基本类型
* 未赋初值的字段，查看编译文件也并没有为其赋值，还是说反编译没有展示  
> 已声明但未初始化的字段将由编译器设置为合理的默认值。