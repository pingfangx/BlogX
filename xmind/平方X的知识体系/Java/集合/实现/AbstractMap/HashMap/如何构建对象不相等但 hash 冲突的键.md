# HashMap 中的 hash 算法

    static final int hash(Object key) {
        int h;
        return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16);
    }
    
    tab[(n - 1) & hash]

# 包装类的 hash 算法
类型|hash
-|-
Byte|return (int)value;
Short|return (int)value;
Integer|return value;
Long|return (int)(value ^ (value >>> 32));
Float|return floatToIntBits(value);
Double|long bits = doubleToLongBits(value); return (int)(bits ^ (bits >>> 32));
Boolean|return value ? 1231 : 1237;
Character|return (int)value;

# 构建 hash 冲突的 Long
可以看到 Long 是最好构建冲突的，只需要 (1L << (32 + i)) + (1L << i) 在异或之后就会得到 0

# get 调用过程