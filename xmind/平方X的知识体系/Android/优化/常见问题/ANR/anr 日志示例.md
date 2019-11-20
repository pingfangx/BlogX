[安卓应用无响应，你真的了解吗？](https://mp.weixin.qq.com/s?__biz=MzI5NjE3NzA4Mg==&mid=2650359967&idx=1&sn=7d59915254a6a346c4d5eda369141eb6&chksm=f445b44ac3323d5c458405f6500d50e875fd374e629bbc7158a1d7105a581766a28706444764&mpshare=1&scene=1&srcid=&pass_ticket=L9MQbF6uhaOTmPU7yqV4H7YT2ItYKOL0RacATooz4V7SEWvXnButGHwaERsWeKsp#rd)
# 输入
    "main" prio=5 tid=1 Sleeping
      | group="main" sCount=1 dsCount=0 flags=1 obj=0x7421e9e8 self=0x79201c214c00
      | sysTid=11129 nice=-10 cgrp=default sched=0/0 handle=0x7920a1a7e548
      | state=S schedstat=( 1365410914 511951033 815 ) utm=116 stm=20 core=1 HZ=100
      | stack=0x7fffe5e52000-0x7fffe5e54000 stackSize=8MB
      | held mutexes=
      at java.lang.Thread.sleep(Native method)
      - sleeping on <0x0b37a959> (a java.lang.Object)
      at java.lang.Thread.sleep(Thread.java:373)
      - locked <0x0b37a959> (a java.lang.Object)
      at java.util.concurrent.TimeUnit.sleep(TimeUnit.java:391)
      at com.pingfangx.demo.androidx.base.extension.DebugExtensionKt.threadSleep(DebugExtension.kt:20)
      at com.pingfangx.demo.androidx.activity.android.app.anr.AnrDemo$onCreate$1.onClick(AnrDemo.kt:23)
      at android.view.View.performClick(View.java:6597)
      at android.view.View.performClickInternal(View.java:6574)
      at android.view.View.access$3100(View.java:778)
      at android.view.View$PerformClick.run(View.java:25885)
      at android.os.Handler.handleCallback(Handler.java:873)
      at android.os.Handler.dispatchMessage(Handler.java:99)
      at android.os.Looper.loop(Looper.java:193)
      at android.app.ActivityThread.main(ActivityThread.java:6669)
      at java.lang.reflect.Method.invoke(Native method)
      at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:493)
      at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:858)

# BroadcastReceiver
    "main" prio=5 tid=1 Sleeping
      | group="main" sCount=1 dsCount=0 flags=1 obj=0x7421e9e8 self=0x79201c214c00
      | sysTid=13381 nice=-10 cgrp=default sched=0/0 handle=0x7920a1a7e548
      | state=S schedstat=( 1431325310 462049115 836 ) utm=114 stm=29 core=1 HZ=100
      | stack=0x7fffe5e52000-0x7fffe5e54000 stackSize=8MB
      | held mutexes=
      at java.lang.Thread.sleep(Native method)
      - sleeping on <0x03b9b746> (a java.lang.Object)
      at java.lang.Thread.sleep(Thread.java:373)
      - locked <0x03b9b746> (a java.lang.Object)
      at java.util.concurrent.TimeUnit.sleep(TimeUnit.java:391)
      at com.pingfangx.demo.androidx.base.extension.DebugExtensionKt.threadSleep(DebugExtension.kt:20)
      at com.pingfangx.demo.androidx.activity.android.content.receiver.LifecycleReceiver.checkAndTimeOut(ReceiverDemo.kt:50)
      at com.pingfangx.demo.androidx.activity.android.content.receiver.LifecycleReceiver.onReceive(ReceiverDemo.kt:41)
      at android.app.ActivityThread.handleReceiver(ActivityThread.java:3379)
      at android.app.ActivityThread.access$1200(ActivityThread.java:199)
      at android.app.ActivityThread$H.handleMessage(ActivityThread.java:1661)
      at android.os.Handler.dispatchMessage(Handler.java:106)
      at android.os.Looper.loop(Looper.java:193)
      at android.app.ActivityThread.main(ActivityThread.java:6669)
      at java.lang.reflect.Method.invoke(Native method)
      at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:493)
      at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:858)
      