# Tutorial 中有两句话
* Java 要求在任何字段或方法之前首先定义常量  
是指要在字段和方法之前定义枚举常量，否则编译报错
* 此外，当存在字段和方法时，枚举常量列表必须以分号结尾  
是指如果没有字段和方法，其实是可以省略分号的

# 自动处理的地方
## 1 类声明 final
不可继承

## 2 类声明 extends java.lang.Enum<E>
Enum 的类型形参很有意思

    public abstract class Enum<E extends Enum<E>>
            implements Comparable<E>, Serializable {
            
它限定 E 不能是任意类型，而是必继承 Enum<E> 的类型

## 3 枚举常量
定义的枚举都被处理为
    
    public final static enum ... NAME;
    
注意 ... 是类型，而 enum 相当于修饰符，可用 java.lang.reflect.Field#isEnumConstant 判断
    
## 4 字段 private final static synthetic ... $VALUES

## 5 方法 public static values()
获取 $VALUES clone 后返回

## 6 方法 public static valueOf(Ljava/lang/String;)
调用 java.lang.Enum#valueOf
    
    T result = enumType.enumConstantDirectory().get(name);
    java.lang.Class#enumConstantDirectory
    
    Map<String, T> enumConstantDirectory() {
        if (enumConstantDirectory == null) {
            T[] universe = getEnumConstantsShared();
            if (universe == null)
                throw new IllegalArgumentException(
                    getName() + " is not an enum type");
            Map<String, T> m = new HashMap<>(2 * universe.length);
            for (T constant : universe)
                m.put(((Enum<?>)constant).name(), constant);
            enumConstantDirectory = m;
        }
        return enumConstantDirectory;
    }
    保存到 HashMap 中
    面 getEnumConstantsShared 则是通过反射调用 values() 方法
    
## 7 构造函数 private <init>(Ljava/lang/String;IZ)V
会自动在前面添加 String 和 int 并调用父类构造函数

## 8 静态初始化 static <clinit>()V
调用构造函数赋值设为枚举常量  
并保存到 $VALUES 中

示例类

    public enum SimpleEnumTest {
        A(false);

        SimpleEnumTest(boolean b) {

        }
    }

    字节码
    // class version 52.0 (52)
    // access flags 0x4031
    // signature Ljava/lang/Enum<Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/_enum/SimpleEnumTest;>;
    // declaration: com/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/_enum/SimpleEnumTest extends java.lang.Enum<com.pingfangx.study.tutorial.learning_the_java_language.classes_and_objects._enum.SimpleEnumTest>
    // 1
    // 2
    public final enum com/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/_enum/SimpleEnumTest extends java/lang/Enum {

      // compiled from: SimpleEnumTest.java

      // access flags 0x4019
      // 3
      public final static enum Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/_enum/SimpleEnumTest; A

      // access flags 0x101A
      // 4
      private final static synthetic [Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/_enum/SimpleEnumTest; $VALUES

      // access flags 0x9
      // 5
      public static values()[Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/_enum/SimpleEnumTest;
       L0
        LINENUMBER 7 L0
        GETSTATIC com/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/_enum/SimpleEnumTest.$VALUES : [Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/_enum/SimpleEnumTest;
        INVOKEVIRTUAL [Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/_enum/SimpleEnumTest;.clone ()Ljava/lang/Object;
        CHECKCAST [Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/_enum/SimpleEnumTest;
        ARETURN
        MAXSTACK = 1
        MAXLOCALS = 0

      // access flags 0x9
      // 6
      public static valueOf(Ljava/lang/String;)Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/_enum/SimpleEnumTest;
       L0
        LINENUMBER 7 L0
        LDC Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/_enum/SimpleEnumTest;.class
        ALOAD 0
        INVOKESTATIC java/lang/Enum.valueOf (Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;
        CHECKCAST com/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/_enum/SimpleEnumTest
        ARETURN
       L1
        LOCALVARIABLE name Ljava/lang/String; L0 L1 0
        MAXSTACK = 2
        MAXLOCALS = 1

      // access flags 0x2
      // signature (Z)V
      // declaration: void <init>(boolean)
      // 7
      private <init>(Ljava/lang/String;IZ)V
       L0
        LINENUMBER 10 L0
        ALOAD 0
        ALOAD 1
        ILOAD 2
        INVOKESPECIAL java/lang/Enum.<init> (Ljava/lang/String;I)V
       L1
        LINENUMBER 12 L1
        RETURN
       L2
        LOCALVARIABLE this Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/_enum/SimpleEnumTest; L0 L2 0
        LOCALVARIABLE b Z L0 L2 3
        MAXSTACK = 3
        MAXLOCALS = 4

      // access flags 0x8
      // 8
      static <clinit>()V
       L0
        LINENUMBER 8 L0
        NEW com/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/_enum/SimpleEnumTest
        DUP
        LDC "A"
        ICONST_0
        ICONST_0
        INVOKESPECIAL com/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/_enum/SimpleEnumTest.<init> (Ljava/lang/String;IZ)V
        PUTSTATIC com/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/_enum/SimpleEnumTest.A : Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/_enum/SimpleEnumTest;
       L1
        LINENUMBER 7 L1
        ICONST_1
        ANEWARRAY com/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/_enum/SimpleEnumTest
        DUP
        ICONST_0
        GETSTATIC com/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/_enum/SimpleEnumTest.A : Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/_enum/SimpleEnumTest;
        AASTORE
        PUTSTATIC com/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/_enum/SimpleEnumTest.$VALUES : [Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/_enum/SimpleEnumTest;
        RETURN
        MAXSTACK = 5
        MAXLOCALS = 0
    }
