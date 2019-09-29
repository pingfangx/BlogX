测试类

    public class FieldThisTest {
        /**
         * 可以看到确实与描述一致，$this$0 是用于 最外层的封闭类，内部的依次为 $this$1 $this$2
         */
        public class A {
            public class B {
                public class C {
                }
            }
        }
    }
    
    字节码
    // class version 52.0 (52)
    // access flags 0x21
    public class com/pingfangx/study/tutorial/reflect/field/FieldThisTest {

      // compiled from: FieldThisTest.java
      // access flags 0x1
      public INNERCLASS com/pingfangx/study/tutorial/reflect/field/FieldThisTest$A com/pingfangx/study/tutorial/reflect/field/FieldThisTest A

      // access flags 0x1
      public <init>()V
       L0
        LINENUMBER 7 L0
        ALOAD 0
        INVOKESPECIAL java/lang/Object.<init> ()V
        RETURN
       L1
        LOCALVARIABLE this Lcom/pingfangx/study/tutorial/reflect/field/FieldThisTest; L0 L1 0
        MAXSTACK = 1
        MAXLOCALS = 1
    }
    
    // class version 52.0 (52)
    // access flags 0x21
    public class com/pingfangx/study/tutorial/reflect/field/FieldThisTest$A {

      // compiled from: FieldThisTest.java
      // access flags 0x1
      public INNERCLASS com/pingfangx/study/tutorial/reflect/field/FieldThisTest$A com/pingfangx/study/tutorial/reflect/field/FieldThisTest A
      // access flags 0x1
      public INNERCLASS com/pingfangx/study/tutorial/reflect/field/FieldThisTest$A$B com/pingfangx/study/tutorial/reflect/field/FieldThisTest$A B

      // access flags 0x1010
      final synthetic Lcom/pingfangx/study/tutorial/reflect/field/FieldThisTest; this$0

      // access flags 0x1
      public <init>(Lcom/pingfangx/study/tutorial/reflect/field/FieldThisTest;)V
       L0
        LINENUMBER 11 L0
        ALOAD 0
        ALOAD 1
        // this$0
        PUTFIELD com/pingfangx/study/tutorial/reflect/field/FieldThisTest$A.this$0 : Lcom/pingfangx/study/tutorial/reflect/field/FieldThisTest;
        ALOAD 0
        INVOKESPECIAL java/lang/Object.<init> ()V
        RETURN
       L1
        LOCALVARIABLE this Lcom/pingfangx/study/tutorial/reflect/field/FieldThisTest$A; L0 L1 0
        LOCALVARIABLE this$0 Lcom/pingfangx/study/tutorial/reflect/field/FieldThisTest; L0 L1 1
        MAXSTACK = 2
        MAXLOCALS = 2
    }
    
    // class version 52.0 (52)
    // access flags 0x21
    public class com/pingfangx/study/tutorial/reflect/field/FieldThisTest$A$B {

      // compiled from: FieldThisTest.java
      // access flags 0x1
      public INNERCLASS com/pingfangx/study/tutorial/reflect/field/FieldThisTest$A com/pingfangx/study/tutorial/reflect/field/FieldThisTest A
      // access flags 0x1
      public INNERCLASS com/pingfangx/study/tutorial/reflect/field/FieldThisTest$A$B com/pingfangx/study/tutorial/reflect/field/FieldThisTest$A B
      // access flags 0x1
      public INNERCLASS com/pingfangx/study/tutorial/reflect/field/FieldThisTest$A$B$C com/pingfangx/study/tutorial/reflect/field/FieldThisTest$A$B C

      // access flags 0x1010
      final synthetic Lcom/pingfangx/study/tutorial/reflect/field/FieldThisTest$A; this$1

      // access flags 0x1
      public <init>(Lcom/pingfangx/study/tutorial/reflect/field/FieldThisTest$A;)V
       L0
        LINENUMBER 12 L0
        ALOAD 0
        ALOAD 1
        // this$1
        PUTFIELD com/pingfangx/study/tutorial/reflect/field/FieldThisTest$A$B.this$1 : Lcom/pingfangx/study/tutorial/reflect/field/FieldThisTest$A;
        ALOAD 0
        INVOKESPECIAL java/lang/Object.<init> ()V
        RETURN
       L1
        LOCALVARIABLE this Lcom/pingfangx/study/tutorial/reflect/field/FieldThisTest$A$B; L0 L1 0
        LOCALVARIABLE this$1 Lcom/pingfangx/study/tutorial/reflect/field/FieldThisTest$A; L0 L1 1
        MAXSTACK = 2
        MAXLOCALS = 2
    }
    
    // class version 52.0 (52)
    // access flags 0x21
    public class com/pingfangx/study/tutorial/reflect/field/FieldThisTest$A$B$C {

      // compiled from: FieldThisTest.java
      // access flags 0x1
      public INNERCLASS com/pingfangx/study/tutorial/reflect/field/FieldThisTest$A com/pingfangx/study/tutorial/reflect/field/FieldThisTest A
      // access flags 0x1
      public INNERCLASS com/pingfangx/study/tutorial/reflect/field/FieldThisTest$A$B com/pingfangx/study/tutorial/reflect/field/FieldThisTest$A B
      // access flags 0x1
      public INNERCLASS com/pingfangx/study/tutorial/reflect/field/FieldThisTest$A$B$C com/pingfangx/study/tutorial/reflect/field/FieldThisTest$A$B C

      // access flags 0x1010
      final synthetic Lcom/pingfangx/study/tutorial/reflect/field/FieldThisTest$A$B; this$2

      // access flags 0x1
      public <init>(Lcom/pingfangx/study/tutorial/reflect/field/FieldThisTest$A$B;)V
       L0
        LINENUMBER 13 L0
        ALOAD 0
        ALOAD 1
        // this$2
        PUTFIELD com/pingfangx/study/tutorial/reflect/field/FieldThisTest$A$B$C.this$2 : Lcom/pingfangx/study/tutorial/reflect/field/FieldThisTest$A$B;
        ALOAD 0
        INVOKESPECIAL java/lang/Object.<init> ()V
        RETURN
       L1
        LOCALVARIABLE this Lcom/pingfangx/study/tutorial/reflect/field/FieldThisTest$A$B$C; L0 L1 0
        LOCALVARIABLE this$2 Lcom/pingfangx/study/tutorial/reflect/field/FieldThisTest$A$B; L0 L1 1
        MAXSTACK = 2
        MAXLOCALS = 2
    }


