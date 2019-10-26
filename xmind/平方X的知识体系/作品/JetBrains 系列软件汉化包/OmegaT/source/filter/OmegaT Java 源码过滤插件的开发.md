# 需求
* 解析出来的内容，能够与生成的 javaDoc 的 html 文档的翻译记忆库兼容
* 块注释和行注释都支持

# 技术要点
## 如何把 doc 读出来
正则匹配

## 如何处理解析与生成结果
《OmegaT 过滤器的加载与处理》

不需要特别处理，调用 AbstractFilter.processEntry，有回调时添加到解析项

翻译时则生成翻译结果

## 标签如何处理
《OmegaT 标签的处理流程及手动处理标签》

参考 FilterVisitor 手动实现