[LeakCanary 内存泄露监测原理研究 - 简书](https://www.jianshu.com/p/5ee6b471970e)

# 使用
LeakCanary.install(this);

# 原理
* Application.registerActivityLifecycleCallbacks()
* 通过ReferenceQueue+WeakReference，来判断对象是否被回收
* MessageQueue中加入一个IdleHandler来得到主线程空闲回调

Activity销毁调用onActivityDestroyed的时候，LeakCanary就会获取这个Activity，然后对其进行分析，看是否有内存泄露

KeyedWeakReference 是带有一个名字的弱引用，用 Activity 创建弱引用，同时传递 ReferenceQueue

然后从队列中获取软引用，获取到说明已被回收，从保存的名字中移除。

如果没有回收，则报告