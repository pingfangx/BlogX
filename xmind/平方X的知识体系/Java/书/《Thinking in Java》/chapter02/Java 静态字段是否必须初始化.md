不需要，和普通字段一样。

如果设置了初始值，则初始化地方不一样。

静态字段在 static <clinit>()V

普通字段在 public <init>()V

示例
    
    public class StaticFieldTest {
        static int si;
        static int sj = 1;
        int i;
        int j = 1;
    }
    字节码
      // access flags 0x1
      public <init>()V
       L0
        LINENUMBER 9 L0
        ALOAD 0
        INVOKESPECIAL java/lang/Object.<init> ()V
       L1
        LINENUMBER 13 L1
        ALOAD 0
        ICONST_1
        PUTFIELD com/pingfangx/study/book1/chapter02/StaticFieldTest.j : I
        RETURN
       L2
        LOCALVARIABLE this Lcom/pingfangx/study/book1/chapter02/StaticFieldTest; L0 L2 0
        MAXSTACK = 2
        MAXLOCALS = 1
        
      // access flags 0x8
      static <clinit>()V
       L0
        LINENUMBER 11 L0
        ICONST_1
        PUTSTATIC com/pingfangx/study/book1/chapter02/StaticFieldTest.sj : I
        RETURN
        MAXSTACK = 1
        MAXLOCALS = 0