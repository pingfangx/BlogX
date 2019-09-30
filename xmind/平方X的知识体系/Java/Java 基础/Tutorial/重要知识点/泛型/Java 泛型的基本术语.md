# 基本术语
术语|英文|示例|定义或备注
-|-|-|-
泛型类型|generic type|同下|在类型上参数化的泛型类或接口
泛型类|generic class|class ArrayList<E>|
泛型接口|generic interface|interface List<E>|
类型参数|type parameter|<K, V>|在翻译时类型实参、类型形参统称，但不标准
类型变量|type variable|同上|即类型参数
类型形参|type parameter|同上|
类型实参|type argument|<String, Integer>|
泛型类型声明|generic type declaration|public class List<T>|
泛型类型调用|generic type invocation|List<Integer> integerList;|
参数化类型|parameterized type|同上|即泛型类型调用
钻石操作符|the diamond|new ArrayList<>();|不知道是不是要翻译为菱形
泛型方法|generic method|public <T> T[] toArray(T[] a)|
类型推断|type inference||
目标类型|target type||
有界类型形参|bounded type parameter|同下|
上界类型形参|upper bound type parameter|<T extends Number>|
多重边界类型形参|multiple bounds type parameter|<T extends B1 & B2 & B3>|
通配符|wildcard|?|
上界通配符|upper bounded wildcard|List<? extends Number>|
无界通配符|unbounded wildcard|List<?>|
下界通配符|lower bounded wildcard|List<? super Integer>|
通配符捕获|wildcard capture|CAP|

## 备注
> 要从代码中引用泛型 Box 类，必须执行 generic type invocation (泛型类型调用)，它将 T 替换为某些具体值，例如 Integer：

> 你可以将泛型类型调用视为与普通方法调用类似，但不是将参数传递给方法，而是传递 type argument (类型实参) - 这种情况下是 Integer - 到 Box 类本身。

> 泛型类型的调用通常称为 parameterized type (参数化类型)。

因为类似方法调用，所以才有泛型类型**调用**、类型**参数**等概念

## 有界类型形参
有界类型形参用类型形参表示，如 <E extends Serializable>

可以用于泛型类型也可以用于泛型方法

只有上界类型形参和多重边界类型形参，没有下界和无界


## 通配符
> 在泛型代码中，称之为 wildcard (通配符) 的问号(?)表示未知类型。通配符可用于各种情况：作为参数、字段或局部变量的类型；有时作为返回类型(虽然更好的编程实践是让其更具体)。通配符从不用作泛型方法调用，泛型类实例创建或超类型的类型实参。
