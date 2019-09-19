# 基本术语
    泛型类型    generic type
    泛型接口    generic interface
    类型形参    type parameter
    类型实参    type argument
    泛型类型调用  generic type invocation
    参数化类型   parameterized type
    钻石操作符   the diamond

    public class Box<T>{
    }
    
    这个类称为 泛型类型
    其中 T 称为类型形参
    
    Box<Integer> integerBox = new Box<>();
    
    Box<Integer> 称为泛型类型调用，也称为参数化类型
    Integer 称为类型实参
    <> 称为钻石操作符
    
    原始类型    raw type
    直接使用 Box，不提供类型实参称为原始类型