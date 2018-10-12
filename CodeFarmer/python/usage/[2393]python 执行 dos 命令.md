[md]

# 0x01 os.system(command)
[官方文档](https://docs.python.org/3.6/library/os.html#os.system)

```
Execute the command (a string) in a subshell. This is implemented by calling the Standard C function system(), and has the same limitations. Changes to sys.stdin, etc. are not reflected in the environment of the executed command. If command generates any output, it will be sent to the interpreter standard output stream.

On Unix, the return value is the exit status of the process encoded in the format specified for wait(). Note that POSIX does not specify the meaning of the return value of the C system() function, so the return value of the Python function is system-dependent.

On Windows, the return value is that returned by the system shell after running command. The shell is given by the Windows environment variable COMSPEC: it is usually cmd.exe, which returns the exit status of the command run; on systems using a non-native shell, consult your shell documentation.

The subprocess module provides more powerful facilities for spawning new processes and retrieving their results; using that module is preferable to using this function. See the Replacing Older Functions with the subprocess Module section in the subprocess documentation for some helpful recipes.

Availability: Unix, Windows.

在子 shell 中执行命令(一个字符串)。这是通过调用标准 C 函数 system() 来实现的，并且具有相同的限制。执行的命令的环境中不会反映 sys.stdin 等的变化。如果 command 产生任何输出，它将被发送到解释器标准输出流。

在 Unix 上，返回值是以 wait() 格式编码的进程的退出状态。请注意，POSIX 并未指定 C system() 函数的返回值的含义，因此 Python 函数的返回值是与系统相关的。

在 Windows 上，返回值是运行 command 后由系统 shell 返回的值。该 shell 由 Windows 环境变量 COMSPEC 给出：它通常是 cmd.exe，它返回命令运行;在使用非本地 shell 的系统上，请查阅您的 shell 文档。

subprocess 模块为产生新进程和检索结果提供了更强大的功能。使用该模块优于使用此功能。请参阅 subprocess 文档中的 Replacing Older Functions with the subprocess Module 查看有用的帮助。

Availability: Unix, Windows.
```

# 0x02 os.popen(cmd, mode=’r’, buffering=-1)
[官方文档](https://docs.python.org/3.6/library/os.html#os.popen)

```
Open a pipe to or from command cmd. The return value is an open file object connected to the pipe, which can be read or written depending on whether mode is 'r' (default) or 'w'. The buffering argument has the same meaning as the corresponding argument to the built-in open() function. The returned file object reads or writes text strings rather than bytes.

The close method returns None if the subprocess exited successfully, or the subprocess’s return code if there was an error. On POSIX systems, if the return code is positive it represents the return value of the process left-shifted by one byte. If the return code is negative, the process was terminated by the signal given by the negated value of the return code. (For example, the return value might be - signal.SIGKILL if the subprocess was killed.) On Windows systems, the return value contains the signed integer return code from the child process.

This is implemented using subprocess.Popen; see that class’s documentation for more powerful ways to manage and communicate with subprocesses.

打开管道到命令 cmd ，或从命令 cmd 打开管道。返回值是一个连接到管道的打开的文件对象，其可以读或写，取决于 mode 为 'r'(默认值)或 'w'。buffering 参数的含义与内置的 open() 函数的参数相同。返回的文件对象读取或写入文本字符串而不是字节。

如果子进程成功退出，则 close 方法返回 None ，否则如果有错误则返回子进程的返回码。在 POSIX 系统上，如果返回码是正值，它表示进程的返回值左移一个字节。如果返回码是负数，则处理过程由返回码的取反值给出的信号终止。(例如，如果子进程被终止，返回值可能是 - signal.SIGKILL。)在 Windows 系统上，返回值包含来自子进程的有符号整数返回码。

这是通过使用 subprocess.Popen 来实现的。请参阅该类的文档以获取更多有效的方式来管理和与子流程进行通信。
```

# 0x03 subprocess.call
```

在 Python 3.5 之前，这三个函数将高级 API 组成了子进程。您现在可以在很多情况下使用 run()，但大量现有代码调用这些函数。

subprocess.call(args, *, stdin=None, stdout=None, stderr=None, shell=False, cwd=None, timeout=None)¶
运行 args 中描述的命令。等待命令完成，然后返回 returncode 属性。

这相当于：

run(...).returncode
(不支持 input 和 check 参数)

上面显示的参数仅仅是最常见的参数。全功能签名与 Popen 构造函数的基本相同 - 该函数传递除 timeout 外所有提供的参数到那个接口。

注意

使用此功能不要使用 stdout=PIPE 或 stderr=PIPE。子进程会阻塞，如果因管道未被读取而产生足够的输出到管道，导致充满 OS 管道缓冲区。

Changed in version 3.3: timeout was added.

subprocess.check_call(args, *, stdin=None, stdout=None, stderr=None, shell=False, cwd=None, timeout=None)¶
带参数运行命令。等待命令完成。如果返回码为零，则返回，否则引发 CalledProcessError。CalledProcessError 对象在 returncode 属性中包含返回代码。

这相当于：

run(..., check=True)
(除了不支持 input 参数)

上面显示的参数仅仅是最常见的参数。全功能签名与 Popen 构造函数的基本相同 - 该函数传递除 timeout 外所有提供的参数到那个接口。

注意

使用此功能不要使用 stdout=PIPE 或 stderr=PIPE。子进程会阻塞，如果因管道未被读取而产生足够的输出到管道，导致充满 OS 管道缓冲区。

Changed in version 3.3: timeout was added.

subprocess.check_output(args, *, stdin=None, stderr=None, shell=False, cwd=None, encoding=None, errors=None, universal_newlines=False, timeout=None)¶
用参数运行命令并返回其输出。

如果返回码不为零，则会引发 CalledProcessError。CalledProcessError 对象在 returncode 属性中包含返回代码，在 output 属性中的包含任何输出。

这相当于：

run(..., check=True, stdout=PIPE).stdout
上面显示的参数仅仅是最常见的参数。完整的函数签名与 run() 大致相同 - 大多数参数直接传递到该接口。但是，不支持显式传递 input=None 来继承父级的标准输入文件句柄。

默认情况下，此函数将以编码字节的形式返回数据。输出数据的实际编码可能取决于被调用的命令，因此解码到文本通常需要在应用程序级别进行处理。

该行为可以通过设置 universal_newlines 为 True 来重写，如 Frequently Used Arguments 中所述。

要在结果中捕获标准错误，请使用 stderr=subprocess.STDOUT：

>>> subprocess.check_output(
...     "ls non_existent_file; exit 0",
...     stderr=subprocess.STDOUT,
...     shell=True)
'ls: non_existent_file: No such file or directory\n'
New in version 3.1.

Changed in version 3.3: timeout was added.

Changed in version 3.4: Support for the input keyword argument was added.

Changed in version 3.6: encoding and errors were added. See run() for details.
```


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


# subprocess.run
```
推荐的调用子进程的方法是对它可以处理的所有用例使用 run() 函数。对于更高级的用例，可以直接使用底层的 Popen 接口。

在 Python 3.5 中添加了run() 函数;如果您需要保留与旧版本的兼容性，请参阅 Older high-level API 部分。

subprocess.run(args, *, stdin=None, input=None, stdout=None, stderr=None, shell=False, cwd=None, timeout=None, check=False, encoding=None, errors=None)¶
运行 args 中描述的命令。等待命令完成，然后返回一个 CompletedProcess 实例。

上面显示的参数仅仅是最常用的参数，在 Frequently Used Arguments 中进行了介绍(因此在缩写签名中使用了关键字符号)。完整的函数签名与 Popen 构造函数基本相同，除了 timeout, input 和 check, 该函数的所有参数传递给那个接口。

默认情况下这不会捕获 stdout 或 stderr。为此，请为 stdout 和/或 stderr 参数传递 PIPE。

timeout 参数传递给 Popen.communicate()。如果超时过期，子进程将被终止并等待。在子进程终止之后，TimeoutExpired 异常将被重新引发。

input 参数传递给 Popen.communicate()，从而传递给子进程的标准输入。如果使用它，则必须是字节序列，或者如果指定了 encoding 或 errors 或 universal_newlines 为真，则为字符串。使用时，内部 Popen 对象会自动使用 stdin=PIPE 和 stdin 参数也可能不会被使用。

如果 check 为 true，并且该进程以非零退出代码退出，则 CalledProcessError 异常将为抛出。该异常的属性包含参数，退出代码以及 stdout 和 stderr（如果它们被捕获）。

如果指定了 encoding 或 errors，或者 universal_newlines 为 true，则 stdin，stdout 和 stderr 的文件对象将在文本模式下使用指定的 encoding 和 errors 或 io.TextIOWrapper 默认。否则，文件对象以二进制模式打开。
```

# 0x04 subprocess.Popen
[官方文档](https://docs.python.org/3.6/library/subprocess.html#subprocess.Popen)
```
该模块中的底层进程的创建和管理由 Popen 类处理。它提供了很大的灵活性，以便开发人员能够处理不属于便利功能范围的不常见情况。

class subprocess.Popen(args, bufsize=-1, executable=None, stdin=None, stdout=None, stderr=None, preexec_fn=None, close_fds=True, shell=False, cwd=None, env=None, universal_newlines=False, startupinfo=None, creationflags=0, restore_signals=True, start_new_session=False, pass_fds=(), *, encoding=None, errors=None)¶
在新进程中执行子程序。在 POSIX 上，类使用 os.execvp()-类似行为来执行子程序。在 Windows 上，该类使用 Windows CreateProcess() 函数。Popen 的参数如下。

args 应该是一个程序参数序列或者单个字符串。默认情况下，如果 args 是一个序列，则要执行的程序是 args 中的第一个项目。如果 args 是一个字符串，则解释依赖于平台，并在下面进行描述。请参阅 shell 和 executable 参数，以获取与默认行为的其他差异。除非另有说明，否则建议将 args 作为序列传递。

在 POSIX 上，如果 args 是一个字符串，则将该字符串解释为要执行的程序的名称或路径。但是，只有在不向程序传递参数的情况下才能完成此操作。

注意

在确定 args 的正确标记时，尤其是在复杂情况下，shlex.split() 是有用的:

>>> import shlex, subprocess
>>> command_line = input()
/bin/vikings -input eggs.txt -output "spam spam.txt" -cmd "echo '$MONEY'"
>>> args = shlex.split(command_line)
>>> print(args)
['/bin/vikings', '-input', 'eggs.txt', '-output', 'spam spam.txt', '-cmd', "echo '$MONEY'"]
>>> p = subprocess.Popen(args) # Success!
请特别注意，shell 中由空白分隔的选项(例如 -input)和参数(例如 eggs.txt)将放在单独的列表元素中，而参数在 shell 中使用时需要引用或反斜杠转义(例如包含空格的文件名或上面显示的 echo 命令)是单列表元素。

在 Windows 上，如果 args 是一个序列，它将按照 Converting an argument sequence to a string on Windows 中描述的方式转换为字符串。这是因为底层的 CreateProcess() 对字符串进行操作。

shell 参数(默认为 False)指定是否使用 shell 作为要执行的程序。如果 shell 为 True，建议将 args 作为字符串而不是序列传递。

在使用 shell=True 的 POSIX 上，shell 默认为 /bin/sh。如果 args 是一个字符串，则该字符串指定要通过 shell 执行的命令。这意味着该字符串的格式必须与在 shell 提示符下键入时的格式完全相同。这包括，例如，在其中包含空格的引号或反斜线转义文件名。如果 args 是一个序列，则第一个项目指定命令字符串，任何其他项目将被视为 shell 本身的附加参数。也就是说，Popen 等价于：

Popen(['/bin/sh', '-c', args[0], args[1], ...])
在具有 shell=True 的 Windows 上， COMSPEC 环境变量指定了默认 shell。在 Windows 上需要指定 shell=True 的唯一时间是您希望执行的命令内置于 shell 中(例如 dir 或 copy)。您不需要 shell=True 来运行批处理文件或基于控制台的可执行文件。

注意

在使用 shell=True 之前，阅读 Security Considerations 部分。

当创建 stdin / stdout / stderr 管道文件对象时，bufsize 将作为相应的参数提供给 open() 函数：

0 表示无缓冲(读取和写入是一个系统调用，可以返回短)
1 表示缓冲行(只有在 universal_newlines=True 时才可用，即在文本模式下)
任何其他正值意味着使用大约那个大小的缓冲区
负的 bufsize(默认值)表示将使用 io.DEFAULT_BUFFER_SIZE 的系统默认值。
Changed in version 3.3.1: bufsize 现在默认为-1，以默认启用缓冲以匹配大多数代码所期望的行为。在 Python 3.2.4 和 3.3.1 之前的版本中，它错误地默认为 0，这是未缓冲的并允许短读取。这是无意的，并不符合大多数代码预期的 Python 2 的行为。

executable 参数指定要执行的替换程序。这是很少需要的。当 shell=False 时，executable 会替换 args 指定的程序。但是，原始的 args 仍然传递给程序。大多数程序将由 args 指定的程序视为命令名，这可能与实际执行的程序不同。在 POSIX 上，args 名称成为 ps 等实用程序中可执行文件的显示名称。如果 shell=True，则在 POSIX 上，executable 参数为默认的 /bin/sh。

stdin，stdout 和 stderr 分别指定执行程序的标准输入，标准输出和标准错误文件句柄。有效值为 PIPE，DEVNULL 现有文件描述符(正整数)，现有的 file object 和 None。PIPE 表示应该创建一个新的管道。DEVNULL 表示特殊文件 os.devnull 将被使用。使用默认设置 None，不会发生重定向;孩子的文件句柄将从父类继承。此外，stderr 可以是 STDOUT，这表明来自应用程序的 stderr 数据应该被捕获到相同的文件句柄为 stdout。

如果将 preexec_fn 设置为可调用对象，则将在子进程执行之前在子进程中调用此对象。(仅限 POSIX)

警告

preexec_fn 参数在应用程序中存在线程时不安全。在调用 exec 之前，子进程可能会死锁。如果你必须使用它，保持它微不足道！最大限度地减少您调用的库的数量。

注意

如果您需要为孩子修改环境，请使用 env 参数，而不是在 preexec_fn 中执行。start_new_session 参数可以代替以前常用的 preexec_fn 来调用子级中的 os.setsid()。

如果 close_fds 为 true，则除 0，1 和 2 外的所有文件描述符将在执行子进程之前关闭。(POSIX only). 默认值因平台而异：在 POSIX 上始终为 true。在 Windows 上，如果 stdin / stdout / stderr 为 None 则返回 true，否则返回 false。在 Windows 上，如果 close_fds 为 true，那么子进程将不会继承任何句柄。请注意，在 Windows 上，您无法将 close_fds 设置为 true，并通过设置 stdin，stdout 或 stderr 来重定向标准句柄。

Changed in version 3.2: close_fds 的默认值已从 False 更改为如上所述。

pass_fds 是一个可选的文件描述符序列，用于在父代和子代之间保持开放。提供 pass_fds 强制 close_fds 为 True。(仅限 POSIX)

New in version 3.2: 添加了 pass_fds 参数。

如果 cwd 不是 None，那么在执行该子项之前，该函数会将工作目录更改为 cwd。cwd 可以是 str 和 path-like 对象。特别是，如果可执行路径是相对路径，该函数会查找 executable(或 args 中的第一项)相对于 cwd。

Changed in version 3.6: cwd 参数接受 path-like object。

如果 restore_signals 为 true(缺省值)，则 Python 设置为 SIG_IGN 的所有信号都会在执行 exec 之前的子进程中恢复为 SIG_DFL。目前这包括 SIGPIPE，SIGXFZ 和 SIGXFSZ 信号。(仅限 POSIX)

Changed in version 3.2: restore_signals 已添加。

如果 start_new_session 为 true，则将在执行子进程之前在子进程中进行 setsid() 系统调用。(仅限 POSIX)

Changed in version 3.2: start_new_session 已添加。

如果 env 不是 None，它必须是一个映射，为新进程定义环境变量;这些被用来代替继承当前进程环境的默认行为。

注意

如果指定，env 必须提供程序执行所需的任何变量。在 Windows 上，为了运行 side-by-side assembly，指定的 env must 包含有效的 SystemRoot。

如果指定了 encoding 或 errors，则文件对象 stdin，stdout 和 stderr 在文本模式下使用指定的编码和 errors 打开，如上面 Frequently Used Arguments 中所述。如果 universal_newlines 为 True，则它们以默认编码的文本模式打开。否则，它们会以二进制流的形式打开。

New in version 3.6: encoding 和 errors。

如果给出，<startup> <startup> 将是 STARTUPINFO 对象，该对象被传递给底层的 CreateProcess 函数。creationflags 可以是 CREATE_NEW_CONSOLE 或 CREATE_NEW_PROCESS_GROUP。(仅限 Windows)

Popen 通过 with 语句支持上下文管理器：退出时，关闭标准文件描述符，并等待进程。

with Popen(["ifconfig"], stdout=PIPE) as proc:
    log.write(proc.stdout.read())
Changed in version 3.2: 添加了上下文管理器支持。

Changed in version 3.6: 如果子进程仍在运行，Popen 析构函数现在会发出 ResourceWarning 警告。
```

# 0x05 总结
简单说就是有的只能获取结果码（os.system，subprocess.call），有的可以获取输入输出（os.popen,subprocess.Popen）。 

subprocess 比 os 的相关方法更强大。
 
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
                               
                               

        # subprocess 的使用
        process = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE)
        output = process.stdout.read()                               
```


# 0x06 python 调用 os.system 输出乱码
感谢[Wensent_H.《pycharm下 os.system执行命令返回有中文乱码》](http://blog.csdn.net/Wensent_H/article/details/77088623)

将全局编码设置了与系统一样即可。
> File > Settings > Editor > File Encodings > Global Encoding : GBK

[/md]