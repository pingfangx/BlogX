Trados 的对齐有些不足，最后使用 Python 自己实现的。

# en改 和 cn 中部分内容未翻译
    使用 en改 配 cn改 
    同时 ignore_b
    同进 在 AlignHtmlParser.add_data 中添加 v = re.sub(r'\s{4,}', '\n', v)  # 多个空格替换为换行
    
    以 StringBuilder.html 为例
    cn 中方法摘要未翻译，cn改翻译了

    但是 cn改缺少一个 <hr> 标签，造成层次不统一
    在 <!-- ========= START OF TOP NAVBAR ======= --> 之前添加，或者直接替换
    
        xpath=xpath.replace('html/head/body/hr/table','html/head/body/table')

# 部分 Deprecated 未认确翻译
    单独处理 java\lang\class-use\Deprecated.html

    忽略单字符的标签，
    在分割之前添加替换
    en = re.sub(r'Deprecated\.(?!\s)', 'Deprecated. ', en)
