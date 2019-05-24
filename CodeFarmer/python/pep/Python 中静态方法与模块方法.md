[Module function vs staticmethod vs classmethod vs no decorators: Which idiom is more pythonic?](https://stackoverflow.com/questions/11788195)
# 相关方法概念
## function
模块方法 Module function
## staticmethod
静态方法
## classmethod
类方法
## Regular method
常规方法？

    class A:
        def foo(x):
            print(x)
    A.foo(5)

这是不正确的用法。  
[glglgl 的回答](https://stackoverflow.com/a/16378764)
> In Py2, A.foo gets transformed to an unbound method and thus requires its first argument be an instance of the class it "lives" in. Calling it with something else will fail.

> In Py3, this check has been dropped and A.foo is just the original function object. So you can call it with everything as first argument, but I wouldn't do it. The first parameter of a method should always be named self and have the semantics of self.

# 场景
如果类方法的 self 没有使用，则会提示可以变为静态方法

    Method 'test' may be 'static'
    Inspection info: This inspection detects any methods which may safely be made static.
    然后可选
    Make function from method
    Make method static
    
于是问是来了
# 选择 function 还是 static method
一开始我也是纠结模块方法会不会在加载模块时影响性能，会不会污染命名空间。

## module function
* 避免 Foo.Foo.f() 问题
* 污染模块命名空间
* 无法继承
## static method
* 与类关联，与模块独立
* 可以重写


[BrenBarn](https://stackoverflow.com/a/11788267)  
> The most straightforward way to think about it is to think in terms of what type of object the method needs in order to do its work.  
> If your method needs access to an instance, make it a regular method.  
> If it needs access to the class, make it a classmethod.  
> If it doesn't need access to the class or the instance, make it a function.  
> There is rarely a need to make something a staticmethod, but if you find you want a function to be "grouped" with a class (e.g., so it can be overridden) even though it doesn't need access to the class, I guess you could make it a staticmethod.

[smci](https://stackoverflow.com/a/16079946)  
> If it doesn't need access to the class or the instance,  
> but is thematically related to the class (typical example: helper functions and conversion functions used by other class methods or used by alternate constructors),  
> then use staticmethod  
> else make it a module function

# 总结
推荐的还是使用 module function。
如果与类关联（如助手函数和转换函数）或与类一起分组，则使用 static method