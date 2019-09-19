以前保存的信息，更新后无法读取了  
断点发现

    java.io.InvalidClassException: <class>; local class incompatible: stream classdesc serialVersionUID = -8305515919770156342, local class serialVersionUID = -3470992040536913630

也就是说类不兼容，serialVersionUID 不一致

一般如果我们继承了 Serializable，如果不指定 serialVersionUID 字段，就会警告：

    '<class>' does not define a 'serialVersionUID' field
    Reports any Serializable classes which do not provide a serialVersionUID field. Without a serialVersionUID field, any change to a class will make previously serialized versions unreadable.
    
没有 serialVersionUID 字段，类的任何更改都会使之前的序列化版本不可读。

因此问题来了
* 不指定 serialVersionUID ，是如何生成的
* 校验 serialVersionUID 是在何处进行的

# 不指定 serialVersionUID ，是如何生成的
官方文档 [Serializable.html](https://docs.oracle.com/javase/8/docs/api/java/io/Serializable.html)  
6.0 有中文版，

> 如果可序列化类未显式声明 serialVersionUID，则序列化运行时将基于该类的各个方面计算该类的默认 serialVersionUID 值，如“Java(TM) 对象序列化规范”中所述。不过，强烈建议 所有可序列化类都显式声明 serialVersionUID 值，原因是计算默认的 serialVersionUID 对类的详细信息具有较高的敏感性，根据编译器实现的不同可能千差万别，这样在反序列化过程中可能会导致意外的 InvalidClassException。因此，为保证 serialVersionUID 值跨不同 java 编译器实现的一致性，序列化类必须声明一个明确的 serialVersionUID 值。还强烈建议使用 private 修饰符显示声明 serialVersionUID（如果可能），原因是这种声明仅应用于直接声明类 -- serialVersionUID 字段作为继承成员没有用处。数组类不能声明一个明确的 serialVersionUID，因此它们总是具有默认的计算值，但是数组类没有匹配 serialVersionUID 值的要求。

提到的 “Java(TM) 对象序列化规范”，中有述 [4.6 Stream Unique Identifiers](https://docs.oracle.com/javase/7/docs/platform/serialization/spec/class.html#4100)

里面有详细描述。

序列化也有很多内容啊，感觉没有认真看。
包括 serialVersionUID 的生成，

[不兼容变化](https://docs.oracle.com/javase/7/docs/platform/serialization/spec/version.html#5172) 
和 [兼容变化](https://docs.oracle.com/javase/7/docs/platform/serialization/spec/version.html#6754)

# 校验 serialVersionUID 是在何处进行的
    2 = {StackTraceElement@12327} "java.io.ObjectStreamClass.initNonProxy(ObjectStreamClass.java:621)"
    3 = {StackTraceElement@12328} "java.io.ObjectInputStream.readNonProxyDesc(ObjectInputStream.java:1625)"
    4 = {StackTraceElement@12329} "java.io.ObjectInputStream.readClassDesc(ObjectInputStream.java:1520)"
    5 = {StackTraceElement@12330} "java.io.ObjectInputStream.readOrdinaryObject(ObjectInputStream.java:1776)"
    6 = {StackTraceElement@12331} "java.io.ObjectInputStream.readObject0(ObjectInputStream.java:1353)"
    7 = {StackTraceElement@12332} "java.io.ObjectInputStream.readObject(ObjectInputStream.java:373)"
    
    
    java.io.ObjectInputStream#readObject
            Object obj = readObject0(false);
    java.io.ObjectInputStream#readObject0
        return checkResolve(readOrdinaryObject(unshared));
    java.io.ObjectInputStream#readOrdinaryObject
        ObjectStreamClass desc = readClassDesc(false);
    java.io.ObjectInputStream#readClassDesc
        return readNonProxyDesc(unshared);
    java.io.ObjectInputStream#readNonProxyDesc
        desc.initNonProxy(readDesc, cl, resolveEx, readClassDesc(false));
    java.io.ObjectStreamClass#initNonProxy
        
            if (model.serializable == osc.serializable &&
                    !cl.isArray() &&
                    suid != osc.getSerialVersionUID()) {
                throw new InvalidClassException(osc.name,
                        "local class incompatible: " +
                                "stream classdesc serialVersionUID = " + suid +
                                ", local class serialVersionUID = " +
                                osc.getSerialVersionUID());
            }