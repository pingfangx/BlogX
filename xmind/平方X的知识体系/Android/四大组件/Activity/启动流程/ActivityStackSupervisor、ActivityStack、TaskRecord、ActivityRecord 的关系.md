[ActivityRecord、TaskRecord、ActivityStack以及Activity启动模式详解 - 简书](https://www.jianshu.com/p/94816e52cd77)

# ActivityStackSupervisor
持有 ActivityStack

    /** The stack containing the launcher app. Assumed to always be attached to
     * Display.DEFAULT_DISPLAY. */
    ActivityStack mHomeStack;

    /** The stack currently receiving input or launching the next activity. */
    ActivityStack mFocusedStack;
    
# ActivityStack
持有 TaskRecord

    /**
     * The back history of all previous (and possibly still
     * running) activities.  It contains #TaskRecord objects.
     */
    private final ArrayList<TaskRecord> mTaskHistory = new ArrayList<>();

# TaskRecord
持有 ActivitRecord

    /** List of all activities in the task arranged in history order */
    final ArrayList<ActivityRecord> mActivities;

# ActivityRecord
    An entry in the history stack, representing an activity.
    
配合食用
```
C:\Users\Administrator>adb shell dumpsys activity activities | findstr "Stack.# \*"
  Stack #5: type=standard mode=fullscreen
    * TaskRecord{cf13afe #79 A=com.pingfangx.demo.androidx U=0 StackId=5 sz=1}
      * Hist #0: ActivityRecord{43548f9 u0 com.pingfangx.demo.androidx/.activity.android.app.lifecycle.SingleInstanceActivity t79}
  Stack #4: type=standard mode=fullscreen
    * TaskRecord{10614ac #78 A=com.pingfangx.demo.androidx.lifecycle U=0 StackId=4 sz=2}
      * Hist #1: ActivityRecord{b8a2ddb u0 com.pingfangx.demo.androidx/.activity.android.app.lifecycle.StandardActivity t78}
      * Hist #0: ActivityRecord{8b45832 u0 com.pingfangx.demo.androidx/.activity.android.app.lifecycle.SingleTaskWithAffinityActivity t78
  Stack #3: type=standard mode=fullscreen
    * TaskRecord{2eb6575 #77 A=com.pingfangx.demo.androidx U=0 StackId=3 sz=4}
      * Hist #3: ActivityRecord{f7ba515 u0 com.pingfangx.demo.androidx/.activity.android.app.lifecycle.StandardActivity t77}
      * Hist #2: ActivityRecord{49ffb17 u0 com.pingfangx.demo.androidx/.activity.android.app.lifecycle.SingleTaskActivity t77}
      * Hist #1: ActivityRecord{8d0f009 u0 com.pingfangx.demo.androidx/.activity.android.app.lifecycle.StandardActivity t77}
      * Hist #0: ActivityRecord{9e5c3ad u0 com.pingfangx.demo.androidx/.MainActivity t77}
  Stack #0: type=home mode=fullscreen
    * TaskRecord{4a2090a #2 I=com.google.android.apps.nexuslauncher/.NexusLauncherActivity U=0 StackId=0 sz=1}
      * Hist #0: ActivityRecord{878c366 u0 com.google.android.apps.nexuslauncher/.NexusLauncherActivity t2}
```
* Stack 是指不同的 ActivityStack
* ActivityStack 持有 TaskRecord
* TaskRecord 持有 Hist，即 ActivityRecord 的列表