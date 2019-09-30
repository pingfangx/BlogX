过程

    原始方法
    public static Object max(Collection coll)

    转为泛型
    public static <T> T max(Collection<T> coll)
    
    由于 T 要可比，所以用上界形参
    public static <T extends Comparable<T>> T max(Collection<T> coll)
    
    Comparable 可以是其超类型，使用下界通配符
    public static <T extends Comparable<? super T>> T max(Collection<T> coll)
    
    幅于类型擦除变为了
    public static Comparable max(Collection coll)
    需要使用多重边界
    public static <T extends Object & Comparable<? super T>> T max(Collection coll)
    
    实际 JDK 中的签名
    public static <T extends Object & Comparable<? super T>> T max(Collection<? extends T> coll) {