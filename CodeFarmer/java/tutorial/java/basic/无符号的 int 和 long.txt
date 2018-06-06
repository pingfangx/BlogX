
> In Java SE 8 and later, you can use the int data type to represent an unsigned 32-bit integer, which has a minimum value of 0 and a maximum value of 232-1. 

阅读了 [How to use the unsigned Integer in Java 8 and Java 9?](https://stackoverflow.com/questions/25556017)  
和 [Unsigned Integer Arithmetic API now in JDK 8](https://blogs.oracle.com/darcy/unsigned-integer-arithmetic-api-now-in-jdk-8)

经过测试我们知道，int 最大值是 -2147483638~2147483647  
引入了无符号机制，但实际的存储没有发生变化，但是可以用相关的 unsigned 方法进行计算、输出。
    
    public static String toUnsignedString(int i) {
        return Long.toString(toUnsignedLong(i));
    }
    
    /**
     * Converts the argument to a {@code long} by an unsigned
     * conversion.  In an unsigned conversion to a {@code long}, the
     * high-order 32 bits of the {@code long} are zero and the
     * low-order 32 bits are equal to the bits of the integer
     * argument.
     *
     * Consequently, zero and positive {@code int} values are mapped
     * to a numerically equal {@code long} value and negative {@code
     * int} values are mapped to a {@code long} value equal to the
     * input plus 2<sup>32</sup>.
     * 因此，零和正的 int 值被映射到一个数字相等的 long 值，而负的 int 值被映射到一个 long 其值等于输入值加上 2 的 32 次方。
     *
     * @param  x the value to convert to an unsigned {@code long}
     * @return the argument converted to {@code long} by an unsigned
     *         conversion
     * @since 1.8
     */
    public static long toUnsignedLong(int x) {
        return ((long) x) & 0xffffffffL;
    }
    通过无符号转换将参数转换为 long。
    在无符号转换为 long 时，long 的高32位为零，而低32位等于整数参数的二进制位（即负数最高位的 1 也保留）。
    因此，零和正的 int 值被映射到一个数字相等的 long 值，而负的 int 值被映射到一个 long 其值等于输入值加上 2 的 32 次方。
    
    正数好理解。
    负数，如 -1
    -1=             0b0_11111111111111111111111111111111
    1L<<32=         0b1_00000000000000000000000000000000
    -1+(1L<<32)=    0b0_11111111111111111111111111111111
    为什么说加上 2 的 32 次方呢，因为加上后就变为对应的正值了。  
    而源码中的计算，首先转为 long
    (long)-1=       0b1111111111111111111111111111111111111111111111111111111111111111
    0xffffffffL=    0b0000000000000000000000000000000011111111111111111111111111111111
    与上以后        0b0000000000000000000000000000000011111111111111111111111111111111
    
    如 2 的 31 次方
    1<<31=-2147482648=  0b0_10000000000000000000000000000000
    1L<<32=             0b1_00000000000000000000000000000000
    (1<<31)+(1L<<32)=   0b0_10000000000000000000000000000000
    这里是因为 1<<31 相当于负的 2^31，加上 2^32 = 2^31
    源码中的计算
    (long)(1<<31)=      0b1111111111111111111111111111111110000000000000000000000000000000
    0xffffffffL=        0b0000000000000000000000000000000011111111111111111111111111111111
    与上以后            0b0000000000000000000000000000000010000000000000000000000000000000
    
    结果是算对了，但是还是不好理解，反正简单说就是，原来用来表示负数的 1 ，现在用来放在最高位表示数值了。
    
