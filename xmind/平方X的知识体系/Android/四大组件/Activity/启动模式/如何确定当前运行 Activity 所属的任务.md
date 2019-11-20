使用 adb 查看正在运行的 Activity

    adb shell dumpsys activity activities | findstr "Run"

输出结果用的 t<\d\d> 就是表示 Task id