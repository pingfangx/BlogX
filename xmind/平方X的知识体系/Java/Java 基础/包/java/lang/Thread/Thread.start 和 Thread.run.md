# code
    
    public void run() {
        if (target != null) {
            target.run();
        }
    }
    
    public synchronized void start() {
        /**
         * This method is not invoked for the main method thread or "system"
         * group threads created/set up by the VM. Any new functionality added
         * to this method in the future may have to also be added to the VM.
         *
         * A zero status value corresponds to state "NEW".
         */
        if (threadStatus != 0)
            throw new IllegalThreadStateException();

        /* Notify the group that this thread is about to be started
         * so that it can be added to the group's list of threads
         * and the group's unstarted count can be decremented. */
        group.add(this);

        boolean started = false;
        try {
            start0();
            started = true;
        } finally {
            try {
                if (!started) {
                    group.threadStartFailed(this);
                }
            } catch (Throwable ignore) {
                /* do nothing. If start0 threw a Throwable then
                  it will be passed up the call stack */
            }
        }
    }
    
可以看到 run 是直接运行了，甚至没有新建线程，但可以多次调用

而 start 是真正的新线程执行，只可以调用一次 start
    
# 测试

    @Test
    public void test_startAndRun() {
        Runnable runnable = () -> System.out.println("当前线程为 " + Thread.currentThread());
        Thread thread = new Thread(runnable);
        thread.run();//当前线程为 Thread[main,5,main]
        thread.start();//当前线程为 Thread[Thread-0,5,main]
        thread.run();//当前线程为 Thread[main,5,main]
        thread.start();//java.lang.IllegalThreadStateException
    }
