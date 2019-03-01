[Tutorial.modules.packages](https://docs.python.org/zh-cn/3/tutorial/modules.html#packages)

[reference.import.packages](https://docs.python.org/zh-cn/3/reference/import.html#packages)


    忽略所有 __init__.py

    package1
        subpackage
            sub.py
        one.py
        test_one.py
    package2
        two.py
        
        
    在 test_one.py 中
    
    import one
    报警告 No module named one，但是运行正常
    要想去除警告，需要将 package1 标记为源码根
    
    from . import one
    不报警告，但是运行报错
    在 tutorial 中有介绍
    > 请注意，相对导入是基于当前模块的名称进行导入的。由于主模块的名称总是 "__main__" ，因此用作Python应用程序主模块的模块必须始终使用绝对导入。
    
    from package2 import two
    正常
    因为 package2 的父目录已经被我预先加到 PYTHONPATH 系统变量中
    如果没有预先设置，则会加载失败 ModuleNotFoundError: No module named 'package2'
    
    from subpackage import sub
    报警告，但是运行正常
    
# 运行配置
## Add content roots to PYTHONPATH
项目根目录
## Add source roots to PYTHONPATH
标记为源码根