Python 中可迭代的都是可迭代对象。

Java 中数组是可迭代的，那数组是否是可迭代对象呢？

    
    @Test
    public void test() {
        Object[] array = {};
        Class<? extends Object[]> clazz = array.getClass();
        System.out.println("class=" + clazz);
        System.out.println(clazz.isArray());
        System.out.println(Iterable.class.isInstance(array));
        System.out.println(Iterator.class.isInstance(array));
    }

测试结果，不是可迭代对象，也不是迭代器，那 Array 是如何实现迭代的呢？