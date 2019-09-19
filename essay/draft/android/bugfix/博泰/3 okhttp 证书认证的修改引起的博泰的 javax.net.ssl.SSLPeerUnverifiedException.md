当 okhttp 为 3.5.0 时正常，当升级为 3.12.0 时报错
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

抛出位置为

    onFailure:78, ExecutorCallAdapterFactory$ExecutorCallbackCall$1 (retrofit2)
    callFailure:141, OkHttpCall$1 (retrofit2)
    onFailure:136, OkHttpCall$1 (retrofit2)
    execute:215, RealCall$AsyncCall (okhttp3)
    run:32, NamedRunnable (okhttp3.internal)
    runWorker:1167, ThreadPoolExecutor (java.util.concurrent)
    run:641, ThreadPoolExecutor$Worker (java.util.concurrent)
    run:764, Thread (java.lang)
    
    错误发生于 okhttp3.RealCall.AsyncCall#execute
    链一直处理到 okhttp3.internal.connection.ConnectInterceptor#intercept
    最后在 okhttp3.internal.connection.RealConnection#connectTls 抛出错误
    下断验证过程
    
    verifyHostname:74, OkHostnameVerifier (okhttp3.internal.tls)
    verify:58, OkHostnameVerifier (okhttp3.internal.tls)
    verify:49, OkHostnameVerifier (okhttp3.internal.tls)
    connectTls:325, RealConnection (okhttp3.internal.connection)
    establishProtocol:283, RealConnection (okhttp3.internal.connection)
    connect:168, RealConnection (okhttp3.internal.connection)
    findConnection:257, StreamAllocation (okhttp3.internal.connection)
    findHealthyConnection:135, StreamAllocation (okhttp3.internal.connection)
    newStream:114, StreamAllocation (okhttp3.internal.connection)
    intercept:42, ConnectInterceptor (okhttp3.internal.connection)
    proceed:147, RealInterceptorChain (okhttp3.internal.http)
    proceed:121, RealInterceptorChain (okhttp3.internal.http)
    intercept:93, CacheInterceptor (okhttp3.internal.cache)
    proceed:147, RealInterceptorChain (okhttp3.internal.http)
    proceed:121, RealInterceptorChain (okhttp3.internal.http)
    intercept:93, BridgeInterceptor (okhttp3.internal.http)
    proceed:147, RealInterceptorChain (okhttp3.internal.http)
    intercept:126, RetryAndFollowUpInterceptor (okhttp3.internal.http)
    proceed:147, RealInterceptorChain (okhttp3.internal.http)
    proceed:121, RealInterceptorChain (okhttp3.internal.http)
    intercept:212, HttpLoggingInterceptor (okhttp3.logging)
    proceed:147, RealInterceptorChain (okhttp3.internal.http)
    proceed:121, RealInterceptorChain (okhttp3.internal.http)
    intercept:251, ServiceManager$3 (com.qinggan.mobile.tsp.manager)
    proceed:147, RealInterceptorChain (okhttp3.internal.http)
    proceed:121, RealInterceptorChain (okhttp3.internal.http)
    getResponseWithInterceptorChain:254, RealCall (okhttp3)
    execute:200, RealCall$AsyncCall (okhttp3)
    run:32, NamedRunnable (okhttp3.internal)
    runWorker:1167, ThreadPoolExecutor (java.util.concurrent)
    run:641, ThreadPoolExecutor$Worker (java.util.concurrent)
    run:764, Thread (java.lang)
    
    断到 okhttp3.internal.tls.OkHostnameVerifier#verifyHostname(java.lang.String, java.security.cert.X509Certificate)
      private boolean verifyHostname(String hostname, X509Certificate certificate) {
        hostname = hostname.toLowerCase(Locale.US);
        List<String> altNames = getSubjectAltNames(certificate, ALT_DNS_NAME);
        for (String altName : altNames) {
          if (verifyHostname(hostname, altName)) {
            return true;
          }
        }
        return false;
      }
    此时 altNames 为空，返回 false，查看 3.5.0 中的处理
    
      private boolean verifyHostname(String hostname, X509Certificate certificate) {
        hostname = hostname.toLowerCase(Locale.US);
        boolean hasDns = false;
        List<String> altNames = getSubjectAltNames(certificate, ALT_DNS_NAME);
        for (int i = 0, size = altNames.size(); i < size; i++) {
          hasDns = true;
          if (verifyHostname(hostname, altNames.get(i))) {
            return true;
          }
        }

        if (!hasDns) {
          X500Principal principal = certificate.getSubjectX500Principal();
          // RFC 2818 advises using the most specific name for matching.
          String cn = new DistinguishedNameParser(principal).findMostSpecific("cn");
          if (cn != null) {
            return verifyHostname(hostname, cn);
          }
        }

        return false;
      }
      
# 什么时候取消了 cn 认证
查看 okhttp 的仓库  
cd84d79c3574de81f23802f832f2ead6ad38a735

    OkHostnameVerifier: Don't fall back to CN verification. (#3764)

    The use of Common Name was deprecated in RFC 2818 (May 2000), section 3.1:

      Although the use of the Common Name is existing practice, it is
      deprecated and Certification Authorities are encouraged to use the
      dNSName instead.

    In 2017, Chrome 58, Firefox 48, and Opera 45 web browsers removed this
    fallback, with Chrome leaving it configurable for enterprise deployments
    (see https://www.chromestatus.com/feature/4981025180483584).
    Android is removing it in http://r.android.com/581382 .
    
该提交合并于 3.10 及以后的提交，因此 3.10 以后的版本都不能用了。  
[OkHostnameVerifier: Don't fall back to CN verification.](https://github.com/square/okhttp/pull/3764)

# 取消的是什么意思
api 访问的 https://wlappgw-pros.pateo.com.cn/   
直接查看 https://www.pateo.com.cn/ 发现提示连接不安全（因为含 http 的图片）。  
而访问 https://wlappgw-pros.pateo.com.cn/     
直接提示您的连接不是私密连接
F12 -> security 中可以看到  
> Certificate - Subject Alternative Name missing  
> The certificate for this site does not contain a Subject Alternative Name extension containing a domain name or IP address.


正常的证书，查看详细信息都有  
使用者 CN=  
使用者备用名称 DNS Name=

而它的证书缺少 DNS Name，所以 okhttp 升级后认证失效。

# 相关移除说明
从提交中提供的地址查看  
[Support for commonName matching in Certificates (removed)](https://www.chromestatus.com/feature/4981025180483584)

> RFC 2818 describes two methods to match a domain name against a certificate - using the available names within the subjectAlternativeName extension, or, in the absence of a SAN extension, falling back to the commonName.

> The fallback to the commonName was deprecated in RFC 2818 (published in 2000), but support still remains in a number of TLS clients, often incorrectly.