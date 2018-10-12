在获取 md5 等时，返回的摘要是 byte[]  
如何解析为 String 呢

查看 [相关问题](https://stackoverflow.com/questions/332079)

我们找到 [Hex.encodeHex](http://commons.apache.org/proper/commons-codec/apidocs/src-html/org/apache/commons/codec/binary/Hex.html#line.149)

    protected static char[] encodeHex(final byte[] data, final char[] toDigits) {
        final int l = data.length;
        final char[] out = new char[l << 1];
        // two characters form the hex value.
        for (int i = 0, j = 0; i < l; i++) {
            out[j++] = toDigits[(0xF0 & data[i]) >>> 4];
            out[j++] = toDigits[0x0F & data[i]];
        }
        return out;
    }
    
来自 [apache/commons-codec](https://github.com/apache/commons-codec/blob/trunk/src/main/java/org/apache/commons/codec/binary/Hex.java)

[Apache Commons](https://zh.wikipedia.org/wiki/Apache_Commons)

很精炼的代码，真优美。  
详细解读一下

一个十六进制，只需要 4 bit  
而一个字节，一 byte 有 8 位，可以表示 2 个十六进制。  
encodeHex 的过程，就是将每个 byte 表示的十交进制解析出来。  
如果 byte 是 0001 0001 ，那么表示的十六进制也就是 11  

# 位运算
    protected static char[] encodeHex(final byte[] data, final char[] toDigits) {
        final int l = data.length;
        // 2 倍长度
        final char[] out = new char[l << 1];
        // 每个 byte 可表示 2 个十六进制
        for (int i = 0, j = 0; i < l; i++) {
            //先取按位与，得出高 4 位，再无符号右移
            out[j++] = toDigits[(0xF0 & data[i]) >>> 4];
            //按位与，得出低 4 位
            out[j++] = toDigits[0x0F & data[i]];
        }
        return out;
    }

那是否可以使用 java.lang.Integer#toString(int, int) 呢？  
或者是 java.lang.Integer#toHexString 呢？

不行，因为 byte 表示的范围是 -128-127，
# 为什么按位与 0xFF 之后就没有正负的问题了
0b11111111 表示 255，但在 byte 中表示 -1

负数用正数补码表示  
补码即反码+1

现得到了 -1，这个 -1 由 byte 转为 Int 时，即在前面添加了 24 位的 1  
按位与 0xFF 只保留了后 8 位，于是得到一个正数，其值为 128
