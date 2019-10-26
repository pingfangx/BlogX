Q:
* hash(key)
* index

# hash(key)
取 hash ，然后与无符号右移 16 位异或

    static final int hash(Object key) {
        int h;
        return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16);
    }

## 为什么要与无符号右移 16 位的结果异或
因为部分 hash 分布不均，比如 Float.hashCode 调用的是 Float.floatToIntBits

浮点数的二进制表示，整数都分布在高位，所以需要将值散列到低位

## 为什么要用异或
只有异或才能保证平均。

值|&|\||^
-|-|-|-
00|0|0|0
01|0|1|1
10|0|1|1
11|1|1|0

# 取 index 的方法，根据 hash 取元素的方法
    tab[(n - 1) & hash]
