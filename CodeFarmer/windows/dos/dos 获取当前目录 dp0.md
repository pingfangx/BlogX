[Command-line reference](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-xp/bb490890(v%3dtechnet.10))

# %0 与 %1
[Command line parameters](http://www.robvanderwoude.com/parameters.php)

%0 is the program name as it was called,  
%1 is the first command line parameter,  
%2 is the second command line parameter,  
and so on till %9.

# %~dp0
~ 是扩展，%0 是第一个参数，因此是扩展第一个参数  
~ 的文档在 for /? 中

    另外，FOR 变量参照的替换已被增强。您现在可以使用下列
    选项语法:

         %~I          - 删除任何引号(")，扩展 %I
         %~fI        - 将 %I 扩展到一个完全合格的路径名
         %~dI        - 仅将 %I 扩展到一个驱动器号
         %~pI        - 仅将 %I 扩展到一个路径
         %~nI        - 仅将 %I 扩展到一个文件名
         %~xI        - 仅将 %I 扩展到一个文件扩展名
         %~sI        - 扩展的路径只含有短名
         %~aI        - 将 %I 扩展到文件的文件属性
         %~tI        - 将 %I 扩展到文件的日期/时间
         %~zI        - 将 %I 扩展到文件的大小
         %~$PATH:I   - 查找列在路径环境变量的目录，并将 %I 扩展
                       到找到的第一个完全合格的名称。如果环境变量名
                       未被定义，或者没有找到文件，此组合键会扩展到
                       空字符串

    可以组合修饰符来得到多重结果:

         %~dpI       - 仅将 %I 扩展到一个驱动器号和路径
         %~nxI       - 仅将 %I 扩展到一个文件名和扩展名
         %~fsI       - 仅将 %I 扩展到一个带有短名的完整路径名
         %~dp$PATH:I - 搜索列在路径环境变量的目录，并将 %I 扩展
                       到找到的第一个驱动器号和路径。
         %~ftzaI     - 将 %I 扩展到类似输出线路的 DIR

    在以上例子中，%I 和 PATH 可用其他有效数值代替。%~ 语法
    用一个有效的 FOR 变量名终止。选取类似 %I 的大写变量名
    比较易读，而且避免与不分大小写的组合键混淆。