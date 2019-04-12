# 堆栈
    4 = {StackTraceElement@15775} "retrofit2.OkHttpCall.parseResponse(OkHttpCall.java:223)"
    5 = {StackTraceElement@15776} "retrofit2.OkHttpCall.execute(OkHttpCall.java:186)"
    6 = {StackTraceElement@15777} "retrofit2.adapter.rxjava.CallExecuteOnSubscribe.call(CallExecuteOnSubscribe.java:40)"
    7 = {StackTraceElement@15778} "retrofit2.adapter.rxjava.CallExecuteOnSubscribe.call(CallExecuteOnSubscribe.java:24)"
    8 = {StackTraceElement@15779} "retrofit2.adapter.rxjava.BodyOnSubscribe.call(BodyOnSubscribe.java:36)"
    9 = {StackTraceElement@15780} "retrofit2.adapter.rxjava.BodyOnSubscribe.call(BodyOnSubscribe.java:28)"
    10 = {StackTraceElement@15781} "rx.Observable.unsafeSubscribe(Observable.java:10327)"
    11 = {StackTraceElement@15782} "rx.internal.operators.OperatorSubscribeOn$SubscribeOnSubscriber.call(OperatorSubscribeOn.java:100)"
    12 = {StackTraceElement@15783} "rx.internal.schedulers.CachedThreadScheduler$EventLoopWorker$1.call(CachedThreadScheduler.java:230)"
    13 = {StackTraceElement@15784} "rx.internal.schedulers.ScheduledAction.run(ScheduledAction.java:55)"
    14 = {StackTraceElement@15785} "java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:458)"
    15 = {StackTraceElement@15786} "java.util.concurrent.FutureTask.run(FutureTask.java:266)"
    16 = {StackTraceElement@15787} "java.util.concurrent.ScheduledThreadPoolExecutor$ScheduledFutureTask.run(ScheduledThreadPoolExecutor.java:301)"
    17 = {StackTraceElement@15788} "java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1167)"
    18 = {StackTraceElement@15789} "java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:641)"
    19 = {StackTraceElement@15790} "java.lang.Thread.run(Thread.java:764)"

    
    retrofit2.OkHttpCall#execute
        return parseResponse(call.execute());
        
    该方法有两步，一是 execute 二是 parseResponse
    
    execute
    3 = {StackTraceElement@16375} "okhttp3.internal.http.RealInterceptorChain.proceed(RealInterceptorChain.java:121)"
    4 = {StackTraceElement@16376} "okhttp3.RealCall.getResponseWithInterceptorChain(RealCall.java:254)"
    5 = {StackTraceElement@16377} "okhttp3.RealCall.execute(RealCall.java:92)"
    6 = {StackTraceElement@16378} "retrofit2.OkHttpCall.execute(OkHttpCall.java:186)"
    
    parseResponse
    2 = {StackTraceElement@16489} "retrofit2.converter.gson.GsonResponseBodyConverter.convert(GsonResponseBodyConverter.java:37)"
    3 = {StackTraceElement@16490} "retrofit2.converter.gson.GsonResponseBodyConverter.convert(GsonResponseBodyConverter.java:27)"
    4 = {StackTraceElement@16491} "retrofit2.OkHttpCall.parseResponse(OkHttpCall.java:223)"
    5 = {StackTraceElement@16492} "retrofit2.OkHttpCall.execute(OkHttpCall.java:186)"
    
所以，要么添加 interceptor 修改 body  
要么修改 converter 转换数据