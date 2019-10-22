synchronized 方法或块都是获取的某对象的锁。

非静态方法和 this 都是获取当前对象的锁

静态方法和 .class 自然是获以类对象的锁


wait、notify、notifyAll 只能在取得锁的同步方法或同步块中调用。