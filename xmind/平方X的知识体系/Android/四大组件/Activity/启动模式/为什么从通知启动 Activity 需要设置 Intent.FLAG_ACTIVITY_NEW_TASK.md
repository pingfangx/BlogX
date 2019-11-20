[任务和返回栈  |  Android Developers](https://developer.android.google.cn/guide/components/tasks-and-back-stack.html)

>  有些实体（如通知管理器）始终在外部任务中启动 Activity，而从不作为其自身的一部分启动 Activity，因此它们始终将 FLAG_ACTIVITY_NEW_TASK 放入传递给 startActivity() 的 Intent 中。

因为启动的任务与其不在一个任务中

所以从通知、从 Service 启动都需要