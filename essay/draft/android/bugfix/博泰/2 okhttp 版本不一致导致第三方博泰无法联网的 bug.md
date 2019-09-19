项目中使用的 retrofit 与第三方版本不一致，报错
javax.net.ssl.SSLPeerUnverifiedException

    0 = {StackTraceElement@15278} "okhttp3.internal.connection.RealConnection.connectTls(RealConnection.java:330)"
    1 = {StackTraceElement@15279} "okhttp3.internal.connection.RealConnection.establishProtocol(RealConnection.java:283)"
    2 = {StackTraceElement@15280} "okhttp3.internal.connection.RealConnection.connect(RealConnection.java:168)"
    3 = {StackTraceElement@15281} "okhttp3.internal.connection.StreamAllocation.findConnection(StreamAllocation.java:257)"
    4 = {StackTraceElement@15282} "okhttp3.internal.connection.StreamAllocation.findHealthyConnection(StreamAllocation.java:135)"
    5 = {StackTraceElement@15283} "okhttp3.internal.connection.StreamAllocation.newStream(StreamAllocation.java:114)"
    6 = {StackTraceElement@15284} "okhttp3.internal.connection.ConnectInterceptor.intercept(ConnectInterceptor.java:42)"
    7 = {StackTraceElement@15285} "okhttp3.internal.http.RealInterceptorChain.proceed(RealInterceptorChain.java:147)"
    8 = {StackTraceElement@15286} "okhttp3.internal.http.RealInterceptorChain.proceed(RealInterceptorChain.java:121)"
    9 = {StackTraceElement@15287} "okhttp3.internal.cache.CacheInterceptor.intercept(CacheInterceptor.java:93)"
    10 = {StackTraceElement@15288} "okhttp3.internal.http.RealInterceptorChain.proceed(RealInterceptorChain.java:147)"
    11 = {StackTraceElement@15289} "okhttp3.internal.http.RealInterceptorChain.proceed(RealInterceptorChain.java:121)"
    12 = {StackTraceElement@15290} "okhttp3.internal.http.BridgeInterceptor.intercept(BridgeInterceptor.java:93)"
    13 = {StackTraceElement@15291} "okhttp3.internal.http.RealInterceptorChain.proceed(RealInterceptorChain.java:147)"
    14 = {StackTraceElement@15292} "okhttp3.internal.http.RetryAndFollowUpInterceptor.intercept(RetryAndFollowUpInterceptor.java:126)"
    15 = {StackTraceElement@15293} "okhttp3.internal.http.RealInterceptorChain.proceed(RealInterceptorChain.java:147)"
    16 = {StackTraceElement@15294} "okhttp3.internal.http.RealInterceptorChain.proceed(RealInterceptorChain.java:121)"
    17 = {StackTraceElement@15295} "okhttp3.logging.HttpLoggingInterceptor.intercept(HttpLoggingInterceptor.java:225)"
    18 = {StackTraceElement@15296} "okhttp3.internal.http.RealInterceptorChain.proceed(RealInterceptorChain.java:147)"
    19 = {StackTraceElement@15297} "okhttp3.internal.http.RealInterceptorChain.proceed(RealInterceptorChain.java:121)"
    20 = {StackTraceElement@15298} "com.qinggan.mobile.tsp.manager.ServiceManager$3.intercept(ServiceManager.java:251)"
    21 = {StackTraceElement@15299} "okhttp3.internal.http.RealInterceptorChain.proceed(RealInterceptorChain.java:147)"
    22 = {StackTraceElement@15300} "okhttp3.internal.http.RealInterceptorChain.proceed(RealInterceptorChain.java:121)"
    23 = {StackTraceElement@15301} "okhttp3.RealCall.getResponseWithInterceptorChain(RealCall.java:254)"
    24 = {StackTraceElement@15302} "okhttp3.RealCall$AsyncCall.execute(RealCall.java:200)"
    25 = {StackTraceElement@15303} "okhttp3.internal.NamedRunnable.run(NamedRunnable.java:32)"

一开始以为是 retrofit 的问题，但是 rxjava 已经升级 rxjava2。  
想办法保留了 rxjava2，降级了 retrofit，但还是报错。  
后续降级 okhttp 也不行，同时降级 okhttp3:logging-interceptor 才能成功。  
最后发现 retrofit、okhttp、com.squareup.okhttp3:logging-interceptor 都需要降级。  

# okhttp 的依赖
在查看 retrofit 的依赖时，发现并没有在项目中指定对 okhttp 的依赖，于是最终查看依赖发现，  
retrofit、logging-interceptor 都有对 okhttp 的依赖。  
这也是为什么只降级其中某个或某几个都不行的原因，它们内部依赖了一个版本的 okhttp，必须全部降级才行。  
具体而言

    可以指定组，也可以指定到名
    gradlew :app:dependencyInsight --dependency om.squareup.okhttp3 --configuration a_testDebugCompileClasspath
    gradlew :app:dependencyInsight --dependency om.squareup.okhttp3:okhttp --configuration a_testDebugCompileClasspath
    
    com.squareup.okhttp3:okhttp:{strictly 3.12.1} -> 3.12.1
        \--- a_testDebugCompileClasspath
        
    com.squareup.okhttp3:okhttp:3.12.1
        \--- com.squareup.okhttp3:logging-interceptor:3.12.1

    com.squareup.okhttp3:okhttp:3.12.0 -> 3.12.1
        \--- com.squareup.retrofit2:retrofit:2.5.0
        
    com.squareup.okhttp3:okhttp:3.5.0
    \--- io.socket:engine.io-client:0.8.3
         +--- a_testDebugCompileClasspath (requested io.socket:engine.io-client:{strictly 0.8.3})
         \--- io.socket:socket.io-client:0.8.3
              +--- a_testDebugCompileClasspath (requested io.socket:socket.io-client:{strictly 0.8.3})
              \--- project :third:vhalllive

受限于微吼使用的 3.5.0 最终全部统一为 3.5.0