# 生命周期
[Activity | AndroidDevelopers](https://developer.android.google.cn/guide/components/activities.html#Lifecycle)

[IntroductiontoActivities | AndroidDevelopers](https://developer.android.google.cn/guide/components/activities/intro-activities)

![](https://developer.android.google.cn/images/activity_lifecycle.png)

# 三种状态
## 继续
>此Activity位于屏幕前台并具有用户焦点。（有时也将此状态称作“运行中”。）

## 暂停
>另一个Activity位于屏幕前台并具有用户焦点，但此Activity仍可见。也就是说，另一个Activity显示在此Activity上方，并且该Activity部分透明或未覆盖整个屏幕。暂停的Activity处于完全活动状态（Activity对象保留在内存中，它保留了所有状态和成员信息，并与窗口管理器保持连接），但在内存极度不足的情况下，可能会被系统终止。

## 停止
>该Activity被另一个Activity完全遮盖（该Activity目前位于“后台”）。已停止的Activity同样仍处于活动状态（Activity对象保留在内存中，它保留了所有状态和成员信息，但未与窗口管理器连接）。不过，它对用户不再可见，在他处需要内存时可能会被系统终止。

# 生命周期

|方法|说明||
|----|----|----|
|onCreate|首次创建Activity时调用。||
|onRestart|在Activity已停止并即将再次启动前调用。||
|onStart|在Activity即将对用户可见之前调用。如果Activity转入前台，则后接`onResume()`，如果Activity转入隐藏状态，则后接`onStop()`。||
|onResume|在Activity即将开始与用户进行交互之前调用。此时，Activity处于Activity堆栈的顶层，并具有用户输入焦点。||
|onPause|当系统即将开始继续另一个Activity时调用。||
|onStop|在Activity对用户不再可见时调用。||
|onDestory|在Activity被销毁前调用。||
||||
||||

