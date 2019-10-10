由于对齐效果很不理想，

    这个版本解析出来的结果很像 Trados 解析的结果，体现在
    A <tt>Closeable</tt> is a source or destination of data that can be closed.
    将变为 is a source or destination of data that can be closed.
    因为 A 与后面的属于同一层级，被覆盖
    <tt>Closeable</tt> 与后面在不同层级，被分开
    
于是使用 Python 自己实现了对齐。

见 tool/translatorx/omegat/align_utils.py

# 其他需要处理
## xml:lang
xml:lang 替换为 lang

## 标签
trados 使用 level2 的 tmx，标签处理是类似 bpt ept 的标签包围