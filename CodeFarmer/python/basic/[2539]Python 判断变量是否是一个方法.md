[蚁方阵《Python判断对象是否是function的三种方法》](https://blog.csdn.net/yiifaa/article/details/78046331)

[How do I detect whether a Python variable is a function?](https://stackoverflow.com/questions/624926)

最后选择 callable
# callable
> If this is for Python 2.x or for Python 3.2+, you can also use callable(). It used to be deprecated, but is now undeprecated, so you can use it again. You can read the discussion here: http://bugs.python.org/issue10518. You can do this with:

    callable(obj)
# hasattr
If this is for Python 3.x but before 3.2, check if the object has a __call__ attribute. You can do this with:

    hasattr(obj, '__call__')
# FunctionTypes
The oft-suggested types.FunctionTypes approach is not correct because it fails to cover many cases that you would presumably want it to pass, like with builtins:

    >>> isinstance(open, types.FunctionType)
    False

    >>> callable(open)
    True
    
# isfunction
    >>> from inspect import isfunction
    >>> def f(): pass
    >>> isfunction(f)
    True
    >>> isfunction(lambda x: x)
    True