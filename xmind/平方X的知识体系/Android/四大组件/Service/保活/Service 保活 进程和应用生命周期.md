# 服务
[服务概览  |  Android Developers](https://developer.android.google.cn/guide/components/services)

> 只有在内存过低且必须回收系统资源以供拥有用户焦点的 Activity 使用时，Android 系统才会停止服务。如果将服务绑定到拥有用户焦点的 Activity，则它其不太可能会终止；如果将服务声明为在前台运行，则其几乎永远不会终止。如果服务已启动并长时间运行，则系统逐渐降低其在后台任务列表中的位置，而服务被终止的概率也会大幅提升—如果服务是启动服务，则您必须将其设计为能够妥善处理系统执行的重启。如果系统终止服务，则其会在资源可用时立即重启服务，但这还取决于您从 onStartCommand() 返回的值。如需了解有关系统会在何时销毁服务的详细信息，请参阅进程和线程文档。

# 进程和应用生命周期
[Processes and Application Lifecycle  |  Android 开发者  |  Android Developers](https://developer.android.google.cn/guide/components/activities/process-lifecycle)

* 前台进程
* 可见进程
* 服务进程
* 缓存进程

以前还分为后台进程和空进程，后来被合并为缓存进程。

