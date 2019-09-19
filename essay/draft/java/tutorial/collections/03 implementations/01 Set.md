常量时间与 log 时间
log 时间是如何计算的

最早插入到最近插入是否翻译正确，实现是怎样的。

关于 HashSet 值得记住的一件事是，迭代在条目数和桶数(capacity (容量))之和中是线性的
原因及修正翻译

初始容量与扩容操作

LinkedHashSet 与 HashSet 具有相同的调整参数，但迭代时间不受容量影响。
原因

CopyOnWriteArraySet  相关操作的时间复杂度