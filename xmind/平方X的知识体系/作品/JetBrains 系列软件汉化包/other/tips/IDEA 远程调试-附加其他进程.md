[Attach IntelliJ IDEA debugger to a running Java process](https://stackoverflow.com/questions/21114066)

    Create a Remote run configuration:

    Run -> Edit Configurations...
    Click the "+" in the upper left
    Select the "Remote" option in the left-most pane
    Choose a name (I named mine "remote-debugging")
    Click "OK" to save:
    
    JVM Options
    The configuration above provides three read-only fields. These are options that tell the JVM to open up port 5005 for remote debugging when running your application. Add the appropriate one to the JVM options of the application you are debugging. One way you might do this would be like so:

    export JAVA_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005"
    But it depends on how your run your application. If you're not sure which of the three applies to you, start with the first and go down the list until you find the one that works.

    You can change suspend=n to suspend=y to force your application to wait until you connect with IntelliJ before it starts up. This is helpful if the breakpoint you want to hit occurs on application startup.
    
    
    将 -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005
    添加到 studio64.exe.vmoptions 即可。
    
    suspend=n 不暂停