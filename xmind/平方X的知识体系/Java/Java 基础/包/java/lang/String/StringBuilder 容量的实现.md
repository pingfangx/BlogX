# 初始容量
    java.lang.StringBuilder#StringBuilder()
    
    public StringBuilder() {
        super(16);
    }
    
    
    AbstractStringBuilder(int capacity) {
        value = new char[capacity];
    }
# 获取
    java.lang.AbstractStringBuilder#capacity
    
    public int capacity() {
        return value.length;
    }
# 自动扩容
    java.lang.AbstractStringBuilder#append(char)
    
    public AbstractStringBuilder append(char c) {
        ensureCapacityInternal(count + 1);
        value[count++] = c;
        return this;
    }
    
# 扩容实现
    使用 java.util.Arrays#copyOf(char[], int) 即 java.lang.System#arraycopy 实现
    在计算新容量时注意溢出
    
    java.lang.AbstractStringBuilder#ensureCapacity
    
    public void ensureCapacity(int minimumCapacity) {
        if (minimumCapacity > 0)
            ensureCapacityInternal(minimumCapacity);
    }
    
    private void ensureCapacityInternal(int minimumCapacity) {
        // overflow-conscious code
        if (minimumCapacity - value.length > 0) {
            value = Arrays.copyOf(value,
                    newCapacity(minimumCapacity));
        }
    }
    
    java.lang.AbstractStringBuilder#newCapacity
    private int newCapacity(int minCapacity) {
        // overflow-conscious code
        int newCapacity = (value.length << 1) + 2;
        if (newCapacity - minCapacity < 0) {
            newCapacity = minCapacity;
        }
        return (newCapacity <= 0 || MAX_ARRAY_SIZE - newCapacity < 0)
            ? hugeCapacity(minCapacity)//扩大为 minCapacity 指定
            : newCapacity;//扩大两倍再加 2
    }
    
    java.lang.AbstractStringBuilder#hugeCapacity
    private int hugeCapacity(int minCapacity) {
        if (Integer.MAX_VALUE - minCapacity < 0) { // overflow
            throw new OutOfMemoryError();
        }
        return (minCapacity > MAX_ARRAY_SIZE)
            ? minCapacity : MAX_ARRAY_SIZE;
    }
    
    private static final int MAX_ARRAY_SIZE = Integer.MAX_VALUE - 8;
    
    
# 缩小
    java.lang.AbstractStringBuilder#trimToSize
    
    public void trimToSize() {
        if (count < value.length) {
            value = Arrays.copyOf(value, count);
        }
    }
    java.util.Arrays#copyOf(char[], int)
    
    public static char[] copyOf(char[] original, int newLength) {
        char[] copy = new char[newLength];
        System.arraycopy(original, 0, copy, 0,
                         Math.min(original.length, newLength));
        return copy;
    }