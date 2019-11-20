[activity启动流程简述 - xutao20170209的博客 - CSDN博客](https://blog.csdn.net/xutao20170209/article/details/72773185)

前几篇，跟了方法调用，太难了。

这里简单描述一下

* startActivity 最终会转到 AMS
* AMS 会用到 ActivityStarter、ActivityStackSupervisor、ActivityStack
* 暂停当前 Activity
* 启动新的 Activity

根据博文中的说明

    ActivityManagerService.startActivity()
    ActivityStackSupervisor.startActivityMayWait()
    解析intent，并把信息保存在ActivityInfo中。如果有多个activity满足要求，弹出对话框让用户选择。
    
    ActivityStackSupervisor.startActivityLocked()
    根据resultTo参数在activity stack里面查找调用者的ActivityRecord，以及创建被启动activity的ActivityRecord。

    ActivityStackSupervisor.startActivityUncheckedLocked()
    根据启动模式找到或创建activity所属于的任务栈,进行任务栈的相关操作.这里注意一点,如果intent里面的启动模式与AndroidManifest.xml文件里面的启动模式冲突,以AndroidManifest.xml文件为准.

    ActivityStack.startActivityLocked()
    将目标activity添加到task stack的顶端并将其设置为前台任务.

    ActivityStackSupervisor.resumeTopActivitiesLocked()
    ActivityStack.resumeTopActivityInnerLocked()
    暂停当前显示的activity

    ActivityStackSupervisor.startSpecificActivityLocked()
    判断是否需要新建进程，如果不需要，则直接调用realStartActivityLocked启动activity,需要就调用startProcessLocked创建进程。我们这里需要创建进程。

    ActivityManagerService.startProcessLocked()
    
# api 28 的代码

    com.android.server.am.ActivityManagerService#startActivity
    com.android.server.am.ActivityStarter#execute
    ...
    
    com.android.server.am.ActivityStarter#startActivityUnchecked
    根据启动模式确定栈
        
        ActivityRecord reusedActivity = getReusableIntentActivity();
        
    com.android.server.am.ActivityStarter#getReusableIntentActivity
        boolean putIntoExistingTask = ((mLaunchFlags & FLAG_ACTIVITY_NEW_TASK) != 0 &&
                (mLaunchFlags & FLAG_ACTIVITY_MULTIPLE_TASK) == 0)
                || isLaunchModeOneOf(LAUNCH_SINGLE_INSTANCE, LAUNCH_SINGLE_TASK);