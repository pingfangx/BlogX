# 1 分割规则
    Function<? super T,? extends R> 
    因此添加规则
    Exception Before: \?After: \s(super|extends)
    即 <? 后跟空白 不分割
    
    因为 rules 是倒序遍历，只需将此规则添加到旧规则之前即可。
    旧规则位于 缺省 中，
    新建语言在缺省之前，添加规则，成功

# 2 文件过滤器
项目属性 > 文件过滤器 > 设为项目专用 > HTML > 选项

## 新增或重写HTML和XHTML文件中的编码声明
仅当 (X)HTML 文件含编码声明时

## 翻译下列属性
全部去掉

## 在下列位置分割新段落：按照 <br> HTML 标签分割段落。
勾上

## 不翻译含下列属性键值对（逗号分隔）的标签内容
    class=codeblock
    代码块
    
    class=PrintHeaders
    不展示的下一页上一页

# 3 输出代码
泛型中使用的 <?> 和 <? 也进行转义，详见对 OmegaT 的修改