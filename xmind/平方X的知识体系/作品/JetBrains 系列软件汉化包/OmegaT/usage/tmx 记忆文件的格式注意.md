# 不能包含的格式
    ']]>'

    
# 找到无效的 XML 字符 (Unicode:0x2)
    直接搜索 \x02 定位
    
    一个十进制位数，后跟 '<code>.</code>' (<code>'apos;</code>)，接着是表示 <i>a</i> 小数部分的十进制位数
    
    原文是
    followed by '.' ('\u002E')
    在 Javadoc 中是 ({@code '\u005Cu002E'})
    原文为了转义反斜框
    
    所以直接改为 (<code>'\u002E'</code>)
    
    搜索替换
        'apos;
        '\u002E'