在 中断状态标志 中提到

> 当线程通过调用静态方法 Thread.interrupted 检查中断时，将清除中断状态。非静态 isInterrupted 方法，它是一个线程用于查询另一个线程的中断状态，不会更改中断状态标志。

详见文档说明

    java.lang.Thread#interrupted
    public static boolean interrupted() {
        return currentThread().isInterrupted(true);
    }
    
    java.lang.Thread#isInterrupted()
    public boolean isInterrupted() {
        return isInterrupted(false);
    }

    private native boolean isInterrupted(boolean ClearInterrupted);