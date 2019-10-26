Q:
* 既然是线程局部的，能否用类实例变量代替

R:
* [Java中ThreadLocal的实际用途是啥？ - 知乎](https://www.zhihu.com/question/341005993)


# Api 文档
> 该类提供了线程局部 (thread-local) 变量。这些变量不同于它们的普通对应物，因为访问某个变量（通过其 get 或 set 方法）的每个线程都有自己的局部变量，它独立于变量的初始化副本。ThreadLocal 实例通常是类中的 private static 字段，它们希望将状态与某一个线程（例如，用户 ID 或事务 ID）相关联。

如文档所说，它一般是 static 的，所以既想用 static，又想线程独立，只能用 ThreadLocal  
可以用于单例、工具类等使用场景。

# 原理
## ThreadLocal.set()
    public void set(T value) {
        Thread t = Thread.currentThread();
        ThreadLocalMap map = getMap(t);
        if (map != null)
            map.set(this, value);
        else
            createMap(t, value);
    }
    
    java.lang.ThreadLocal#getMap
    ThreadLocalMap getMap(Thread t) {
        return t.threadLocals;
    }
    
    java.lang.ThreadLocal#createMap
    void createMap(Thread t, T firstValue) {
        t.threadLocals = new ThreadLocalMap(this, firstValue);
    }
## ThreadLocal.get()

    public T get() {
        Thread t = Thread.currentThread();
        ThreadLocalMap map = getMap(t);
        if (map != null) {
            ThreadLocalMap.Entry e = map.getEntry(this);
            if (e != null) {
                @SuppressWarnings("unchecked")
                T result = (T)e.value;
                return result;
            }
        }
        return setInitialValue();
    }
    
所以可以看到，每个线程都有 threadLocals，也就相当于线程的类变量了。
以 ThreadLocal 为 key 在 map 中保存值。

## java.lang.ThreadLocal.ThreadLocalMap
弱引用 Entry
        static class Entry extends WeakReference<ThreadLocal<?>> {
        