# 需求
实现类似 Trados 的对齐文档的功能，需要识别每个元素。

要能生成元素的 xpath，没有好的方法，只好解析 html 记录标签

因此需要解析 html 的方法

## 坑
有部分文档的如 META 标签，只有开标签，没有闭标签。

# HTMLParser
分别在 handle_starttag 和 handle_endtag

也可以在 handle_startendtag 中处理开闭标签

但是有部分可能文档不规范，只有开标签，没有闭标签。

# BeautifulSoup
