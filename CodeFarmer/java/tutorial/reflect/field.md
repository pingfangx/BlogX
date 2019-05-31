> 但是常用的字段包括 this$0，用于内部类（即非静态成员类的嵌套类）引用最外层的封闭类

    对于类
    
    public class FieldTest {
        public class A {
            public class B {
                public class C {
                }
            }
        }
    }
    
    生成相关字节码
    final synthetic Lcom/pingfangx/study/tutorial/reflect/FieldTest; this$0
  
    public FieldTest$A(FieldTest this$0) {
        this.this$0 = this$0;
    }
    
    public FieldTest$A$B(A this$1) {
        this.this$1 = this$1;
    }
    public FieldTest$A$B$C(B this$2) {
        this.this$2 = this$2;
    }

    可以看到确实与描述一致，$this$0 是用于 最外层的封闭类，内部的依次为 $this$1 $this$2