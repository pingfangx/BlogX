# 结构
    nested class 嵌套类
        static nested class 静态嵌套类
        non-static nested class 非静态嵌套类（inner class 内部类）
            local calss 局部类
            anoymous class 匿名类
                lambda expressions lambda 表达式
                    函数式接口
                    聚合操作
                    方法引用

内部类的创建 new A().B() 让我想起了曾经的时光。

# 何时使用嵌套类，本地类，匿名类和 Lambda 表达式
名称|静态嵌套类|内部类|局部类|匿名类|Lambda|备注
-|-|-|-|-|-|-
英文|static nested class|inner class|local class|anoymous class|lambda expressions|
访问封闭类的非公共字段和方法|×|√|√|√|√|编译器生成的合成字段或合成方法
访问(方法的)局部变量或方法参数|×|×|√|√|√|final 与遮蔽
创建多个类实例|√|√|√|×|×|
访问类的构造函数|√|√|√|×|×|
命名类|√|√|√|×|×|
声明字段或方法|√|√|√|√|×|