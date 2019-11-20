# 栈
    java.lang.IllegalArgumentException: Service Intent must be explicit: Intent { act= }
        at android.app.ContextImpl.validateServiceIntent(ContextImpl.java:1458)
        at android.app.ContextImpl.startServiceCommon(ContextImpl.java:1499)
        at android.app.ContextImpl.startService(ContextImpl.java:1471)
        at android.content.ContextWrapper.startService(ContextWrapper.java:654)
        
[服务概览  |  Android Developers](https://developer.android.google.cn/guide/components/services#ExtendingIntentService)        
> 注意：为确保应用的安全性，在启动 Service 时，请始终使用显式 Intent，且不要为服务声明 Intent 过滤器。使用隐式 Intent 启动服务存在安全隐患，因为您无法确定哪些服务会响应 Intent，而用户也无法看到哪些服务已启动。从 Android 5.0（API 级别 21）开始，如果使用隐式 Intent 调用 bindService()，则系统会抛出异常。

实测 startService 也会报错。