
# python 中的反码
    ~5=-6 怎么理解
    
    5=0b101
    ~5=-0b010
    其实不仅仅是后 3 位，而是整个 int 位，如果是 32 位，则其实是
    5=0b    00000000    00000000    00000000    00000101
    ~5=0b   11111111    11111111    11111111    11111010
    最高位是 1 表示为负数
    
    有一个负数，其补码为 0b   11111111    11111111    11111111    11111010
    求该数
    因为负数的补码为其正数的反码 + 1
    减1，得    0b  11111111    11111111    11111111    11111001
    反码得     0b  00000000    00000000    00000000    00000110
    它表示正数 6，也就是说该负数为 -6
    
    负数对应的正数=负数补码-1，再取反码
    
    
在 [BitwiseOperators](https://wiki.python.org/moin/BitwiseOperators)

中有说明

> ~ x
Returns the complement of x - the number you get by switching each 1 for a 0 and each 0 for a 1.   
This is the same as -x - 1.

那么

    ~x=-x-1
    这是为什么
    因为 -x 表示为 x 的补码，即 x 的反码+1
    所以 ~x=x的反码=x的反码+1-1=x的补码-1=-x-1
