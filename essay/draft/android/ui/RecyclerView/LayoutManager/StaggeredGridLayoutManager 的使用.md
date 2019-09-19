# 加载更多添加数据时错位
[StaggeredGridLayoutManager瀑布流错乱和顶部空白问题解决](http://www.voidcn.com/article/p-dzqujkne-bqr.html)

提到 staggeredGridLayoutManager.setGapStrategy(StaggeredGridLayoutManager.GAP_HANDLING_NONE); 不可用

测试不会跳动，但是顶部会空白。

[RecyclerView瀑布流的那些坑](https://blog.csdn.net/Silence_Sep/article/details/86611265)  
提到应该使用 notifyItemRangeInserted 和 notifyItemRangeChanged