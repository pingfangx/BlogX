0123n

# 0 null
0 表示空
> 对于任何非空引用值 x，x.equals(null) 都应返回 false。

# 1 自反性
1 表示自己
> 对于任何非空引用值 x，x.equals(x) 都应返回 true。

# 2 对称性
2 表示 xy
> 对于任何非空引用值 x 和 y，当且仅当 y.equals(x) 返回 true 时，x.equals(y) 才应返回 true。

# 3 传递性
3 表示 xyz
> 对于任何非空引用值 x、y 和 z，如果 x.equals(y) 返回 true，并且 y.equals(z) 返回 true，那么 x.equals(z) 应返回 true。

# n 一致性
n 表示多次
> 对于任何非空引用值 x 和 y，多次调用 x.equals(y) 始终返回 true 或始终返回 false，前提是对象上 equals 比较中所用的信息没有被修改。