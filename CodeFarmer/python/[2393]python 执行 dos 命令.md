[md]

# 0x01 os.system(command)
[官方文档](https://docs.python.org/3.6/library/os.html#os.system)

# 0x02 os.popen(cmd, mode=’r’, buffering=-1)
[官方文档](https://docs.python.org/3.6/library/os.html#os.popen)

# 0x03 subprocess.call
## 3.1 [Older high-level API](https://docs.python.org/3.6/library/subprocess.html#older-high-level-api)
* subprocess.call(args, *, stdin=None, stdout=None, stderr=None, shell=False, cwd=None, timeout=None)
* subprocess.check_call(args, *, stdin=None, stdout=None, stderr=None, shell=False, cwd=None, timeout=None)
* subprocess.check_output(args, *, stdin=None, stderr=None, shell=False, cwd=None, encoding=None, errors=None, universal_newlines=False, timeout=None)

## 3.2 [Replacing Older Functions with the subprocess Module](https://docs.python.org/3.6/library/subprocess.html#replacing-older-functions-with-the-subprocess-module)
## Replacing os.system()
```
sts = os.system("mycmd" + " myarg")
# becomes
sts = call("mycmd" + " myarg", shell=True)
```

# 0x04 subprocess.Popen
[官方文档](https://docs.python.org/3.6/library/subprocess.html#subprocess.Popen)

# 0x05 总结
简单说就是有的只能获取结果码，有的可以获取输入输出。  
但是我的git clone 还是不能实现，应该是我没有仔细看文档，不想再复杂了。  
（补充：后来发现，生成 .py 后用命令行执行是有输出的，直接在 pycharm 执行没有输出，我记得在哪里已经补充过了呀。）
```

        cmd='git clone **项目'
        print(os.system(cmd))  # 0
        print(os.popen(cmd).readlines())  # []
        print(subprocess.call(cmd,shell=True))  # 0
        print(subprocess.Popen(cmd, shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                               universal_newlines=True).stdout.readlines())  # []
```
然后 help > ** 文件，都是成功的，但要注意 3.2 所说，shell=True，默认的False不能执行。
```
        cmd='help > **文件'
        print(os.system(cmd))  # 1
        print(os.popen(cmd).readlines())  # []
        print(subprocess.call(cmd,shell=True))  # 1
        print(subprocess.Popen(cmd, shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                               universal_newlines=True).stdout.readlines())  # []
```

# 0x06 python 调用 os.system 输出乱码
感谢[Wensent_H.《pycharm下 os.system执行命令返回有中文乱码》](http://blog.csdn.net/Wensent_H/article/details/77088623)

将全局编码设置了与系统一样即可。
> File > Settings > Editor > File Encodings > Global Encoding : GBK

[/md]