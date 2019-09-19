[How do I run a file from MS-DOS?](https://www.computerhope.com/issues/ch000598.htm)

[Open file from the command line on Windows](https://superuser.com/questions/246825)

# 通过文件名打开
    a.md
    
    但是有空格无效，需要加引号
    "a b.md"
    
通过文件名打开的和序仍在当前 dos 环境，或者是维持 cmd 窗口打开状态，

> Finally, it is important to realize that when running an executable file from an MS-DOS shell (running MS-DOS within Windows), the program will still use Windows to run. If you want to run any other file types, you can use the MS-DOS start command and type start <name_of_file>, where <name_of_file> is the file's name.

# 通过 start 命令
[Microsoft DOS start command](https://www.computerhope.com/starthlp.htm)

    start a.md
    
    一样的，有空格要加双引号
    start "a b.md"
    此时却会新打开一个 cmd，因为第一个参数被视为了 title
    
    改为
    start "" "a b.md"