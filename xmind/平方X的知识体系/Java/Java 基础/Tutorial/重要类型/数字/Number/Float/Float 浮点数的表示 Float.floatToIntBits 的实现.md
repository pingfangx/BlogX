
正常的 IEEE 754 表示

见 FloatToIntBitsTest

测试结果
    
    
    float                = 5.0
    int                  = 5
    int binary           = 0b 00000101
    int                  = 1.01 * 2^2
    exponent             = 2
    offset exponent      = 129
    1 sign               = 0
    2 offset e binary    = 0b 10000001
    3 mantissa           = 01
    1+2+3                = 0b 0 10000001 01
    floatToIntBits       = 0b 0 10000001 01000000000000000000000