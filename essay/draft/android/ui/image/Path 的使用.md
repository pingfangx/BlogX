[Path 文档](https://developer.android.google.cn/reference/android/graphics/Path)

[安卓自定义View进阶-Path之基本操作](http://www.gcssloop.com/customview/Path_Basic/)

[android path + fillType](https://blog.csdn.net/xiexiangyu92/article/details/79339369)

[非零环绕数规则和奇-偶规则（Non-Zero Winding Number Rule&&Odd-even Rule）](https://blog.csdn.net/freshforiphone/article/details/8273023)

[Nonzero-rule](https://en.wikipedia.org/wiki/Nonzero-rule)

[Even–odd rule](https://en.wikipedia.org/wiki/Even%E2%80%93odd_rule)

# fillType
判断一个点是否在曲线内部，从一个点引一条射线到曲线外部

## Even–odd rule
如果射线与边相交的数量为奇数，则认为在内部

## Nonzero-rule
如果射线与顺时针相关，-1，与逆时针相关 +1  
不为 0 则在内部（因为以不为 0 判断，所以 +1 -1 不重要）