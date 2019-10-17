示例

    @Test
    public void test() {
        Integer n1 = new Integer(47);
        Integer n2 = new Integer(47);
        Assert.assertNotSame(n1, n2);
        Assert.assertEquals(n1, n2);
        Assert.assertNotSame(new Integer(47), new Integer(47));
        //new 是新建对象，但是 valueOf 有缓存
        Assert.assertSame(Integer.valueOf(47), Integer.valueOf(47));
    }

源码中显示，byte int short log 都有缓存机制，除 Integer 可通过配置外（默认也是），都是 -128 到 127 可缓存

缓存使用值加上偏移 128 从缓存中取。



    public static Byte valueOf(byte b) {
        final int offset = 128;
        return ByteCache.cache[(int)b + offset];
    }
    public static Short valueOf(short s) {
        final int offset = 128;
        int sAsInt = s;
        if (sAsInt >= -128 && sAsInt <= 127) { // must cache
            return ShortCache.cache[sAsInt + offset];
        }
        return new Short(s);
    }
    public static Integer valueOf(int i) {
        if (i >= IntegerCache.low && i <= IntegerCache.high)
            return IntegerCache.cache[i + (-IntegerCache.low)];
        return new Integer(i);
    }
    public static Long valueOf(long l) {
        final int offset = 128;
        if (l >= -128 && l <= 127) { // will cache
            return LongCache.cache[(int)l + offset];
        }
        return new Long(l);
    }
    public static Float valueOf(float f) {
        return new Float(f);
    }
    public static Double valueOf(double d) {
        return new Double(d);
    }
    
缓存使用的静态内部类，只有用到时才初始化

    private static class ByteCache {
        private ByteCache(){}

        static final Byte cache[] = new Byte[-(-128) + 127 + 1];

        static {
            for(int i = 0; i < cache.length; i++)
                cache[i] = new Byte((byte)(i - 128));
        }
    }