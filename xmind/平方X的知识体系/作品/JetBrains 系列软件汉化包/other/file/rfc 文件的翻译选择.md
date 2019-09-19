rfc 中限制宽度，宽度到了就换行。

# 下载 html 文件
文件中使用了 pre 标签，还是不好解析

# 下载 txt 文件
## 当作 html
想要去除换行，改扩展名当作 html 解析  
但是标题与正文之前的换行也被忽略，连不一起了，失败

## 当作纯文本
修改文件过滤器，分割段落依据
* 断行  
遇到换行就分割，导致一个句子分成多段。
* 空行  
基本满足，但是只是多个行连在一起，没有自动去除换行
* 从不  
不换行，以标点换行，类似 html，标题与正文连在一起


# 结论
最后没有合适的解决方案，只能手动将换行删除  
写了 Python 脚本，同时记录修改前、后的文件，方便比较。

    process_line_break_for_translation.py
    
    
# 后来发现
[Internet-Draft Archive Tool](https://tools.ietf.org/id/)

中的是标准的 html 格式，甚至 xml 也应该是可以的。  
之前只是点了 txt、pdf 和 html 就是没试一下 draft

后业又再发现，早期的类似 rfc5246 还是只有 txt 和 pdf 两种格式