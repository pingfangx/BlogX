[Java中的整型移位操作，为什么是“只有数值右端的低5位才有用”？ - SegmentFault 思否](https://segmentfault.com/q/1010000000414831)

> 所以我终于明白英文原文里的“right-hand side”指的并不是某个数值的“右端”，“right-hand side”是一个术语，应该翻译成“右操作数”。

> If you shift a char, byte, or short, it will be promoted to int before the shift takes place, and the result will be an int. Only the five low-order bits of the right-hand side will be used. This prevents you from shifting more than the number of bits in an int. If you’re operating on a long, you’ll get a long result. Only the six low-order bits of the right-hand side will be used, so you can’t shift more than the number of bits in a long.  

> 只有数值右端的低5位才有用。这样可防止我们移位超过int型值所具有的位数。（译注：因为2的5次方为32，而int型值只有32位。）若对
> 一个long类型的数值进行处理，最后得到的结果也是lo吨。此时只会用到数值右端的低6位，以防止移位超过long型数值具有的位数。

数值右端应理解为右操作数


    @Test
    public void test_shift() {
        /*
         * 10000000000000000000000000000000
         * 10000000000000000000000000000000
         * 1000000000000000000000000000000000000000000000000000000000000000
         * 1000000000000000000000000000000000000000000000000000000000000000
         * 右操作数只有低5位（对于 Long 是 6 位）有效
         */
        int j = 1;
        System.out.println(Integer.toBinaryString(j << 0b11111));
        System.out.println(Integer.toBinaryString(j << 0b11111_1));
        long l = 1;
        System.out.println(Long.toBinaryString(l << 0b11111_1));
        System.out.println(Long.toBinaryString(l << 0b11111_11));
    }