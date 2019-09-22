re 表示的是 regular expression

方法命名有点难记，简单整理一下  
不过用多了就记熟了。

方法|简介|备注
-|-|-
**compile**|编译|
**search**|搜索第一个并返回，或返回 None|
**match**|仅从开头匹配|
**fullmatch**|完整匹配|
**split**|分割|
**findall**|返回组列表|
**finditer**|返回 match 迭代器|
**sub**|替换|substitute
**subn**|指定替换数量|
**escape**|转义|


示例

    import re

    if __name__ == '__main__':
        # 编译
        print(re.compile(r'\d'))  # re.compile('\\d')
        # 搜索一个
        print(re.search(r'\d', 'a123'))  # <_sre.SRE_Match object; span=(1, 2), match='1'>
        # 需要从头匹配
        print(re.match(r'\d', 'a123'))  # None
        print(re.match(r'\d', '123'))  # <_sre.SRE_Match object; span=(0, 1), match='1'>
        # 完整匹配
        print(re.fullmatch(r'\d', '123'))  # None
        print(re.split(r'\d', 'a123'))  # ['a', '', '', '']
        # 查找所有，按分组返回
        print(re.findall(r'\d', 'a1234'))  # ['1', '2', '3', '4']
        print(re.findall(r'((\d)(\d))', 'a1234'))  # [('12', '1', '2'), ('34', '3', '4')]
        # 迭代器
        print(re.finditer(r'\d', 'a123'))  # <callable_iterator object at 0x06C597F0>
        # 替换
        print(re.sub(r'\d', lambda x: str(int(x.group()) + 1), 'a123'))  # a234
        # 指定替换数量
        print(re.sub(r'\d', lambda x: str(int(x.group()) + 1), 'a123', 2))  # a233
        # 转义
        print(re.escape(r'\d'))  # \\d
