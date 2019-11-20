# 使用 ThreadLocal 保证每个线程的 Looper 是线程的实例变量
    android.os.Looper#prepare(boolean)


    private static void prepare(boolean quitAllowed) {
        if (sThreadLocal.get() != null) {
            throw new RuntimeException("Only one Looper may be created per thread");
        }
        sThreadLocal.set(new Looper(quitAllowed));
    }
    
    static final ThreadLocal<Looper> sThreadLocal = new ThreadLocal<Looper>();
    
# 在 prepare 时判断是否有

# ThreadLocal 原理
Thread 中有一个 threadLocals 字段，
ThreadLocal.ThreadLocalMap threadLocals = null;

其类型为 ThreadLocal.ThreadLocalMap

调用 java.lang.ThreadLocal#get
时执行 Thread.currentThread() 获取当前线程，以当前 ThreadLocal 为键（内部计算 hash 计算 index）获取对应的对象。