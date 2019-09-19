类似 Answer: ...  
之类的问答，被认为是一个语句，其实是可以拆分的，前面的 Answer 翻译，后面的内容再单独翻译。  

于是添加分割规则

    断句
    前模式
    后模式
    备注
    
    
    ^(Question|Answer|Exercise|Answer.+Exercises?|Lesson|Q|A):
    \s
    在问答时常见，因为问题与回答重复了，只是前面多了不同的单词，于是在 : 之后断句
    
    (True or False):
    \s
    因为可能在 Answer: 之后，所以不需要 ^
    
    Note</s0>:
    \s
    注意冒号后分隔
    
    .
    \(The\sJava™\sTutorials
    标题括号前分隔
    
    \(
    The\sJava™\sTutorials
    标题括号后分隔
    
    The\sJava™\sTutorials
    \)
    标题结尾括号分隔
    
    [\w>]\s
    >\s[a-zA-Z<]
    标题与导航的 > 前分隔，前面是字母或标签，后面是空格加字母或标签
    
    [\w>]\s>
    \s[a-zA-Z<]
    标题与导航的 > 后分隔
    
    