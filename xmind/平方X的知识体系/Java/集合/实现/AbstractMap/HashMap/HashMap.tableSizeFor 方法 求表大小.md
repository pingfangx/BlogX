# 表的大小
表的大小需要为 2 的幂，已经在其他文章中介绍过，那么如何求得一个大于等于指定容量的 2 的幂。

    static final int tableSizeFor(int cap) {
        int n = cap - 1;
        n |= n >>> 1;
        n |= n >>> 2;
        n |= n >>> 4;
        n |= n >>> 8;
        n |= n >>> 16;
        return (n < 0) ? 1 : (n >= MAXIMUM_CAPACITY) ? MAXIMUM_CAPACITY : n + 1;
    }
    通过多次移位，可以得到最高位的 1 后面全部都是 1
    此时加上 1 就得到了一个 > cap 的 2 的幂
    提前减去 1 就能得到 >= cap 的 2 的 幂
