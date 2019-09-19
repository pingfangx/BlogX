[More on Defining Functions](https://docs.python.org/3/tutorial/controlflow.html#more-on-defining-functions)

[理解 Python 中的 *args 和 **kwargs](http://kodango.com/variable-arguments-in-python)


# * 用于解包列表或元组，** 用于解包字典
    
> The reverse situation occurs when the arguments are already in a list or tuple but need to be unpacked for a function call requiring separate positional arguments. For instance, the built-in range() function expects separate start and stop arguments. If they are not available separately, write the function call with the *-operator to unpack the arguments out of a list or tuple:

> In the same fashion, dictionaries can deliver keyword arguments with the **-operator:

# *args 和 **kwargs 分别用于默认参数（Default Argument）和关键字参数（Keyword Arguments）

# 各种类型的参数
[Python中位置参数、默认参数、可变参数、命名关键字参数、关键字参数的区别](https://blog.csdn.net/u014745194/article/details/70158926)

[Keyword (Named) Arguments in Python: How to Use Them](http://treyhunner.com/2018/04/keyword-arguments-in-python/)

[PEP 3102 -- Keyword-Only Arguments](https://www.python.org/dev/peps/pep-3102/)
## 必选参数，位置参数  
positional

## 可选参数，默认参数
optional,default

## 关键字参数，命名参数
Keyword,named

## 可变参数
Arbitrary

## 命名关键字参数
Keyword-Only
> This PEP proposes a change to the way that function arguments are assigned to named parameter slots. In particular, it enables the declaration of "keyword-only" arguments: arguments that can only be supplied by keyword and which will never be automatically filled in by a positional argument.

也就是说，必须指定为关键字参数，不会通过位置自动填充。