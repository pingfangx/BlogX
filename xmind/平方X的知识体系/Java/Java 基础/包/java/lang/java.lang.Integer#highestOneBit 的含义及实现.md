# java.lang.Integer#highestOneBit
> 返回具有至多单个 1 位的 int 值，在指定的 int 值中最高位（最左边）的 1 位的位置。

将最高位的 1 保留，其余位置为 0

# 实现

    public static int highestOneBit(int i) {
        // HD, Figure 3-1
        i |= (i >>  1);
        i |= (i >>  2);
        i |= (i >>  4);
        i |= (i >>  8);
        i |= (i >> 16);
        return i - (i >>> 1);
    }
    
    public static long highestOneBit(long i) {
        // HD, Figure 3-1
        i |= (i >>  1);
        i |= (i >>  2);
        i |= (i >>  4);
        i |= (i >>  8);
        i |= (i >> 16);
        i |= (i >> 32);
        return i - (i >>> 1);
    }
    将所以位置为 1，然后减去次高的所有位为 1