介绍这个方法是因为中间的数字，是表示优先级，而不是线程 id

一开始看到两个不同的进程，线程都是 Thread[main,5,main]，还以为是同一个，吓我一跳。

    public String toString() {
        ThreadGroup group = getThreadGroup();
        if (group != null) {
            return "Thread[" + getName() + "," + getPriority() + "," +
                           group.getName() + "]";
        } else {
            return "Thread[" + getName() + "," + getPriority() + "," +
                            "" + "]";
        }
    }