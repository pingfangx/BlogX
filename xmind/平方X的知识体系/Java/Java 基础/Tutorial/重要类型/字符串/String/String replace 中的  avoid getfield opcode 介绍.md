源码

    public String replace(char oldChar, char newChar) {
        if (oldChar != newChar) {
            int len = value.length;
            int i = -1;
            char[] val = value; /* avoid getfield opcode */

            while (++i < len) {
                if (val[i] == oldChar) {
                    break;
                }
            }
            if (i < len) {
                char buf[] = new char[len];
                for (int j = 0; j < i; j++) {
                    buf[j] = val[j];
                }
                while (i < len) {
                    char c = val[i];
                    buf[i] = (c == oldChar) ? newChar : c;
                    i++;
                }
                return new String(buf, true);
            }
        }
        return this;
    }
    
这其中的 avoid getfield opcode 是什么意思？

    测试代码
    
    private class TestClass {
        private char value[];

        private void print() {
            for (int i = 0; i < value.length; i++) {
                System.out.println(value[i]);
            }
        }

        private void printWithVariable() {
            char[] val = value;
            for (int i = 0; i < val.length; i++) {
                System.out.println(val[i]);
            }
        }
    }
    
    字节码
    // class version 52.0 (52)
    // access flags 0x20
    class com/pingfangx/study/tutorial/learning_the_java_language/data/ReplceTest$TestClass {

      // compiled from: ReplceTest.java
      // access flags 0x2
      private INNERCLASS com/pingfangx/study/tutorial/learning_the_java_language/data/ReplceTest$TestClass com/pingfangx/study/tutorial/learning_the_java_language/data/ReplceTest TestClass

      // access flags 0x2
      private [C value

      // access flags 0x1010
      final synthetic Lcom/pingfangx/study/tutorial/learning_the_java_language/data/ReplceTest; this$0

      // access flags 0x2
      private <init>(Lcom/pingfangx/study/tutorial/learning_the_java_language/data/ReplceTest;)V
       L0
        LINENUMBER 11 L0
        ALOAD 0
        ALOAD 1
        PUTFIELD com/pingfangx/study/tutorial/learning_the_java_language/data/ReplceTest$TestClass.this$0 : Lcom/pingfangx/study/tutorial/learning_the_java_language/data/ReplceTest;
        ALOAD 0
        INVOKESPECIAL java/lang/Object.<init> ()V
        RETURN
       L1
        LOCALVARIABLE this Lcom/pingfangx/study/tutorial/learning_the_java_language/data/ReplceTest$TestClass; L0 L1 0
        MAXSTACK = 2
        MAXLOCALS = 2

      // access flags 0x2
      private print()V
       L0
        LINENUMBER 15 L0
        ICONST_0
        ISTORE 1
       L1
       FRAME APPEND [I]
        ILOAD 1
        ALOAD 0
        GETFIELD com/pingfangx/study/tutorial/learning_the_java_language/data/ReplceTest$TestClass.value : [C
        ARRAYLENGTH
        IF_ICMPGE L2
       L3
        LINENUMBER 16 L3
        GETSTATIC java/lang/System.out : Ljava/io/PrintStream;
        ALOAD 0
        GETFIELD com/pingfangx/study/tutorial/learning_the_java_language/data/ReplceTest$TestClass.value : [C
        ILOAD 1
        CALOAD
        INVOKEVIRTUAL java/io/PrintStream.println (C)V
       L4
        LINENUMBER 15 L4
        IINC 1 1
        GOTO L1
       L2
        LINENUMBER 18 L2
       FRAME CHOP 1
        RETURN
       L5
        LOCALVARIABLE i I L1 L2 1
        LOCALVARIABLE this Lcom/pingfangx/study/tutorial/learning_the_java_language/data/ReplceTest$TestClass; L0 L5 0
        MAXSTACK = 3
        MAXLOCALS = 2

      // access flags 0x2
      private printWithVariable()V
       L0
        LINENUMBER 21 L0
        ALOAD 0
        GETFIELD com/pingfangx/study/tutorial/learning_the_java_language/data/ReplceTest$TestClass.value : [C
        ASTORE 1
       L1
        LINENUMBER 22 L1
        ICONST_0
        ISTORE 2
       L2
       FRAME APPEND [[C I]
        ILOAD 2
        ALOAD 1
        ARRAYLENGTH
        IF_ICMPGE L3
       L4
        LINENUMBER 23 L4
        GETSTATIC java/lang/System.out : Ljava/io/PrintStream;
        ALOAD 1
        ILOAD 2
        CALOAD
        INVOKEVIRTUAL java/io/PrintStream.println (C)V
       L5
        LINENUMBER 22 L5
        IINC 2 1
        GOTO L2
       L3
        LINENUMBER 25 L3
       FRAME CHOP 1
        RETURN
       L6
        LOCALVARIABLE i I L2 L3 2
        LOCALVARIABLE this Lcom/pingfangx/study/tutorial/learning_the_java_language/data/ReplceTest$TestClass; L0 L6 0
        LOCALVARIABLE val [C L1 L6 1
        MAXSTACK = 3
        MAXLOCALS = 3
    }

    对比 println 部分
    
        GETSTATIC java/lang/System.out : Ljava/io/PrintStream;
        ALOAD 0
        GETFIELD com/pingfangx/study/tutorial/learning_the_java_language/data/ReplceTest$TestClass.value : [C
        ILOAD 1
        CALOAD
        INVOKEVIRTUAL java/io/PrintStream.println (C)V
        
        
        GETSTATIC java/lang/System.out : Ljava/io/PrintStream;
        ALOAD 1
        ILOAD 2
        CALOAD
        INVOKEVIRTUAL java/io/PrintStream.println (C)V
        
    确实是提前调用 GETFIELD，在循环中不再调用