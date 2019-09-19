TODO
E set(int index, E element);
E remove(int index);

而 java.util.Collection#remove 返回的是 boolean

> addAll 操作从指定位置开始插入指定 Collection 的所有元素。元素按照指定的 Collection 的迭代器返回的顺序插入。

这是因为使用 for-each 结构

# 排序算法用的什么
sorts a List using a merge sort algorithm, which provides a fast, stable sort.