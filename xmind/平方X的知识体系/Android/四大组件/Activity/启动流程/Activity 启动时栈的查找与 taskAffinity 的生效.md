# singleTask 堆栈
    findTaskLocked:1179, ActivityStack (com.android.server.am)
    findTaskLocked:3437, ActivityStackSupervisor (com.android.server.am)
    getReusableIntentActivity:1802, ActivityStarter (com.android.server.am)
    startActivityUnchecked:1234, ActivityStarter (com.android.server.am)
    startActivity:1200, ActivityStarter (com.android.server.am)
    startActivity:868, ActivityStarter (com.android.server.am)
    startActivity:544, ActivityStarter (com.android.server.am)
    startActivityMayWait:1099, ActivityStarter (com.android.server.am)
    execute:486, ActivityStarter (com.android.server.am)
    startActivityAsUser:5120, ActivityManagerService (com.android.server.am)
    startActivityAsUser:5094, ActivityManagerService (com.android.server.am)
    startActivity:5085, ActivityManagerService (com.android.server.am)
    onTransact$startActivity$:10084, IActivityManager$Stub (android.app)
    onTransact:122, IActivityManager$Stub (android.app)
    onTransact:3291, ActivityManagerService (com.android.server.am)
    execTransact:731, Binder (android.os)
    
    com.android.server.am.ActivityStack#findTaskLocked
                if (task.rootAffinity.equals(target.taskAffinity)) {
                    if (DEBUG_TASKS) Slog.d(TAG_TASKS, "Found matching affinity candidate!");
                    // It is possible for multiple tasks to have the same root affinity especially
                    // if they are in separate stacks. We save off this candidate, but keep looking
                    // to see if there is a better candidate.
                    result.r = r;
                    result.matchedByRootAffinity = true;
                }
                
    找到以后返回到
    com.android.server.am.ActivityStarter#startActivityUnchecked
        
        ActivityRecord reusedActivity = getReusableIntentActivity();
        不为空
        
# singleTaskWithAffinity 则返回空
创建栈

    create:2210, TaskRecord (com.android.server.am)
    createTaskRecord:5187, ActivityStack (com.android.server.am)
    setTaskFromReuseOrCreateNewTask:2053, ActivityStarter (com.android.server.am)
    startActivityUnchecked:1411, ActivityStarter (com.android.server.am)
    startActivity:1200, ActivityStarter (com.android.server.am)
    startActivity:868, ActivityStarter (com.android.server.am)
    startActivity:544, ActivityStarter (com.android.server.am)
    startActivityMayWait:1099, ActivityStarter (com.android.server.am)
    execute:486, ActivityStarter (com.android.server.am)
    startActivityAsUser:5120, ActivityManagerService (com.android.server.am)
    startActivityAsUser:5094, ActivityManagerService (com.android.server.am)
    startActivity:5085, ActivityManagerService (com.android.server.am)
    onTransact$startActivity$:10084, IActivityManager$Stub (android.app)
    onTransact:122, IActivityManager$Stub (android.app)
    onTransact:3291, ActivityManagerService (com.android.server.am)
    execTransact:731, Binder (android.os)