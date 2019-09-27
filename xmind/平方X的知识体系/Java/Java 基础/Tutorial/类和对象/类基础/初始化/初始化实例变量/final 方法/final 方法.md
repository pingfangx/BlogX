* 该方法是 final 的，因为在实例初始化期间调用非 final 方法可能会导致问题。

测试发现，初始化类变量的私有静态方法和初始化实例变量的 final 方法

私有为 final 是为了避免出现问题

实际是没有强制要求的

测试代码

    
    public class FinalMethodTest {
        private class AClass {

            protected int field = initField();

            protected int initField() {
                return 0;
            }
        }

        private class BClass extends AClass {
            @Override
            protected int initField() {
                return 1;
            }
        }

        @Test
        public void test() {
            //由方法初始化
            Assert.assertEquals(0, new AClass().field);
            //不设为 final 会被重写
            Assert.assertEquals(1, new BClass().field);
        }
    }
    
    编译结果
    
    private class BClass extends FinalMethodTest.AClass {
        private BClass() {
            super(null);
        }

        protected int initField() {
            return 1;
        }
    }

    private class AClass {
        protected int field;

        private AClass() {
            this.field = this.initField();
        }

        protected int initField() {
            return 0;
        }
    }
    
    字节码
    // class version 52.0 (52)
    // access flags 0x20
    class com/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest$AClass {

      // compiled from: FinalMethodTest.java
      // access flags 0x2
      private INNERCLASS com/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest$AClass com/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest AClass
      // access flags 0x1008
      static synthetic INNERCLASS com/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest$1 null null

      // access flags 0x4
      protected I field

      // access flags 0x1010
      final synthetic Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest; this$0

      // access flags 0x2
      private <init>(Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest;)V
       L0
        LINENUMBER 11 L0
        ALOAD 0
        ALOAD 1
        PUTFIELD com/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest$AClass.this$0 : Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest;
        ALOAD 0
        INVOKESPECIAL java/lang/Object.<init> ()V
       L1
        LINENUMBER 13 L1
        ALOAD 0
        ALOAD 0
        //初始化字段
        INVOKEVIRTUAL com/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest$AClass.initField ()I
        PUTFIELD com/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest$AClass.field : I
        RETURN
       L2
        LOCALVARIABLE this Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest$AClass; L0 L2 0
        MAXSTACK = 2
        MAXLOCALS = 2

      // access flags 0x4
      protected initField()I
       L0
        LINENUMBER 16 L0
        ICONST_0
        IRETURN
       L1
        LOCALVARIABLE this Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest$AClass; L0 L1 0
        MAXSTACK = 1
        MAXLOCALS = 1

      // access flags 0x1000
      synthetic <init>(Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest;Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest$1;)V
       L0
        LINENUMBER 11 L0
        ALOAD 0
        ALOAD 1
        INVOKESPECIAL com/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest$AClass.<init> (Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest;)V
        RETURN
       L1
        LOCALVARIABLE this Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest$AClass; L0 L1 0
        LOCALVARIABLE x0 Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest; L0 L1 1
        LOCALVARIABLE x1 Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest$1; L0 L1 2
        MAXSTACK = 2
        MAXLOCALS = 3
    }

    // class version 52.0 (52)
    // access flags 0x20
    class com/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest$BClass extends com/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest$AClass {

      // compiled from: FinalMethodTest.java
      // access flags 0x2
      private INNERCLASS com/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest$BClass com/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest BClass
      // access flags 0x1008
      static synthetic INNERCLASS com/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest$1 null null
      // access flags 0x2
      private INNERCLASS com/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest$AClass com/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest AClass

      // access flags 0x1010
      final synthetic Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest; this$0

      // access flags 0x2
      private <init>(Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest;)V
       L0
        LINENUMBER 20 L0
        ALOAD 0
        ALOAD 1
        PUTFIELD com/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest$BClass.this$0 : Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest;
        ALOAD 0
        ALOAD 1
        ACONST_NULL
        //调用父类初始化方法
        INVOKESPECIAL com/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest$AClass.<init> (Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest;Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest$1;)V
        RETURN
       L1
        LOCALVARIABLE this Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest$BClass; L0 L1 0
        MAXSTACK = 3
        MAXLOCALS = 2

      // access flags 0x4
      protected initField()I
       L0
        LINENUMBER 23 L0
        ICONST_1
        IRETURN
       L1
        LOCALVARIABLE this Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest$BClass; L0 L1 0
        MAXSTACK = 1
        MAXLOCALS = 1

      // access flags 0x1000
      synthetic <init>(Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest;Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest$1;)V
       L0
        LINENUMBER 20 L0
        ALOAD 0
        ALOAD 1
        INVOKESPECIAL com/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest$BClass.<init> (Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest;)V
        RETURN
       L1
        LOCALVARIABLE this Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest$BClass; L0 L1 0
        LOCALVARIABLE x0 Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest; L0 L1 1
        LOCALVARIABLE x1 Lcom/pingfangx/study/tutorial/learning_the_java_language/classes_and_objects/init_fields/FinalMethodTest$1; L0 L1 2
        MAXSTACK = 2
        MAXLOCALS = 3
    }

