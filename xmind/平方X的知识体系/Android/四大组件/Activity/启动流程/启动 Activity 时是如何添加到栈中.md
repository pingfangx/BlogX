# 堆栈
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


    private int startActivityUnchecked(final ActivityRecord r, ActivityRecord sourceRecord,
            IVoiceInteractionSession voiceSession, IVoiceInteractor voiceInteractor,
            int startFlags, boolean doResume, ActivityOptions options, TaskRecord inTask,
            ActivityRecord[] outActivity) {}
            
    此时
    sourceRecord 中的 task 包启 MainActivity
    r 的 task 为 null
    
    
# 添加到栈顶
    addActivityAtIndex:1208, TaskRecord (com.android.server.am)
    addActivityToTop:1190, TaskRecord (com.android.server.am)
    addOrReparentStartingActivity:2277, ActivityStarter (com.android.server.am)
    setTaskFromSourceRecord:2180, ActivityStarter (com.android.server.am)
    startActivityUnchecked:1413, ActivityStarter (com.android.server.am)
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

# 到底添加到了哪个栈中
《ActivityStackSupervisor、ActivityStack、TaskRecord、ActivityRecord 的关系》

ActivityStack 持有 TaskRecord， TaskRecord 持有 ActivityRecord 的列表

所以最终是添加到 TaskRecord 持有的 ActivityRecord 列表中

数据结构使用的是 ArrayList
    /**
     * The back history of all previous (and possibly still
     * running) activities.  It contains #TaskRecord objects.
     */
    private final ArrayList<TaskRecord> mTaskHistory = new ArrayList<>();