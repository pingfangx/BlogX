由于默认关联是包名，所以会找到相同的栈。

[解开Android应用程序组件Activity的"singleTask"之谜 - 老罗的Android之旅 - CSDN博客](https://blog.csdn.net/Luoshengyang/article/details/6714543)

《Activity 启动时栈的查找与 taskAffinity 的生效》

示例

    C:\Users\Administrator>adb shell dumpsys activity activities | findstr "Run"
        Running activities (most recent first):
            Run #0: ActivityRecord{ef60c2 u0 com.pingfangx.demo.androidx/.activity.android.app.lifecycle.SingleInstanceActivity t38}
        Running activities (most recent first):
            Run #0: ActivityRecord{dfd9eac u0 com.pingfangx.demo.androidx/.activity.android.app.lifecycle.SingleTaskWithAffinityActivity t37}
        Running activities (most recent first):
            Run #2: ActivityRecord{1d56b49 u0 com.pingfangx.demo.androidx/.activity.android.app.lifecycle.SingleTaskActivity t36}
            Run #1: ActivityRecord{565ccdd u0 com.pingfangx.demo.androidx/.activity.android.app.lifecycle.StandardActivity t36}
            Run #0: ActivityRecord{f815440 u0 com.pingfangx.demo.androidx/.MainActivity t36}
        Running activities (most recent first):
            Run #0: ActivityRecord{ada126e u0 com.google.android.apps.nexuslauncher/.NexusLauncherActivity t2}