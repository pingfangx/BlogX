# 问题
Java api 1.6 版本有中文、有英文，想生成翻译记忆库

有两个计划方案
* 用 Python 解析
* 修改 OmegaT 实现

# 查找轮子
之前隐约听说 Trados 是可以实现这个功能的，但是一直没有用过。

经过一番搜索，终于找到了称之为对齐的功能

[什么是翻译对齐？](https://www.sdltrados.cn/cn/solutions/translation-alignment/)

[对齐已翻译文档导入翻译记忆库-Winalign - 百度文库](https://wenku.baidu.com/view/b1b8f66fa98271fe910ef9bf.html)


# WinAlign
[SDL Trados Studio 2014-2015 对齐功能详解 - 百度文库](https://wenku.baidu.com/view/1cc6e556bb4cf7ec4bfed08d.html)

> SDL Trados Studio 2007、2009、2011的对齐都依赖WinAlign,SDL 2014 终于推出了一个替代品,开始虽不能说取代,但最终就是想取代 WinAlign


# Trados 对齐文件的使用
从菜单中选择对齐文档总是报错

需要从翻译记忆库处右键 -> 对齐多个文档

但是添加单个文件可以，添加文件夹，有可能会卡在某个文件，具体原因不清楚。

从 2014 升级到 2019 还是会卡住

后来发现，好像是因为文件过多，所以卡住了，减少目录中的文件数可以成功。

主要是它有进度，结果进度一直不动，所以以为是卡住了。

约 300 个文件的目录需要 10s 以下，时间似乎是与 O(n^2)