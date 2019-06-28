# 1 检查已有译文
[ReactiveX文档中文翻译](https://legacy.gitbook.com/book/mcxiaoke/rxdocs/details)

[reactivex.github.io/documentation/cn/](https://github.com/ReactiveX/reactivex.github.io/tree/develop/documentation/cn)

# 2 评价是否需要翻译
虽然已经有译文了，但还是想翻译一下。  
* 是否有价值，该文档介绍的内容是什么，自己是否需要学习  
如果是很重要的内容，确实直接阅读英文会好一些，翻译一遍可以一句一句地读，加深理解和记忆
* 复杂度，是否可以流畅地阅读英文  
如果简单地就不用译了，直接读就好了

# 3 翻译源的选取
一般是不赞同直接将英文 markdown 翻译为中文。  
应该导入 OmegaT 项目，翻译词条生成中文文件。

## 选择 markdown 还是 html
### markdown
* 方便移植
* 但是由于断行被认为是多个片段，其实就该连在一起

### html
* 一般都不太推荐

后来发现，可以将 .markdown 的文件过滤器设为 html 而不要选 纯文本。  
正好符合 reactivex.github.io 的 markdown 格式，可能因为其内容本身就不是 markdown 而是转为了 html