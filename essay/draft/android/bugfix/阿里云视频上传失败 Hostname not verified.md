# 报错信息
    javax.net.ssl.SSLPeerUnverifiedException: Hostname out-20171225111017099-7vvgwfv25o.oss-cn-shanghai.aliyuncs.com not verified:
        certificate: sha256/rts8As0mrhaXSeAmIMNbwLKXuMiwkeUfu62WmpdSzBk=
        DN: CN=*.oss-cn-shanghai.aliyuncs.com,O=DO_NOT_TRUST,OU=Created by http://www.fiddler2.com
        subjectAltNames: [*.oss-cn-shanghai.aliyuncs.com]
        at okhttp3.internal.connection.RealConnection.connectTls(RealConnection.java:330)
        at okhttp3.internal.connection.RealConnection.establishProtocol(RealConnection.java:283)
        at okhttp3.internal.connection.RealConnection.connect(RealConnection.java:168)
        at okhttp3.internal.connection.StreamAllocation.findConnection(StreamAllocation.java:257)
        at okhttp3.internal.connection.StreamAllocation.findHealthyConnection(StreamAllocation.java:135)
        at okhttp3.internal.connection.StreamAllocation.newStream(StreamAllocation.java:114)
        at okhttp3.internal.connection.ConnectInterceptor.intercept(ConnectInterceptor.java:42)
        at okhttp3.internal.http.RealInterceptorChain.proceed(RealInterceptorChain.java:147)
        at okhttp3.internal.http.RealInterceptorChain.proceed(RealInterceptorChain.java:121)
        at okhttp3.internal.cache.CacheInterceptor.intercept(CacheInterceptor.java:93)
        at okhttp3.internal.http.RealInterceptorChain.proceed(RealInterceptorChain.java:147)
        at okhttp3.internal.http.RealInterceptorChain.proceed(RealInterceptorChain.java:121)
        at okhttp3.internal.http.BridgeInterceptor.intercept(BridgeInterceptor.java:93)
        at okhttp3.internal.http.RealInterceptorChain.proceed(RealInterceptorChain.java:147)
        at okhttp3.internal.http.RetryAndFollowUpInterceptor.intercept(RetryAndFollowUpInterceptor.java:126)
        at okhttp3.internal.http.RealInterceptorChain.proceed(RealInterceptorChain.java:147)
        at okhttp3.internal.http.RealInterceptorChain.proceed(RealInterceptorChain.java:121)
        at okhttp3.RealCall.getResponseWithInterceptorChain(RealCall.java:254)
        at okhttp3.RealCall.execute(RealCall.java:92)
        at com.alibaba.sdk.android.oss.network.OSSRequestTask.call(OSSRequestTask.java:148)
        at com.alibaba.sdk.android.oss.network.OSSRequestTask.call(OSSRequestTask.java:215)
        at com.alibaba.sdk.android.oss.network.OSSRequestTask.call(OSSRequestTask.java:36)
        at java.util.concurrent.FutureTask.run(FutureTask.java:266)
        at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1167)
        at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:641)
        at java.lang.Thread.run(Thread.java:784)
        
# 验证失败
    com.alibaba.sdk.android.oss.internal.InternalRequestOperation#InternalRequestOperation
        OkHttpClient.Builder builder = new OkHttpClient.Builder()
                .followRedirects(false)
                .followSslRedirects(false)
                .retryOnConnectionFailure(false)
                .cache(null)
                .hostnameVerifier(new HostnameVerifier() {
                    @Override
                    public boolean verify(String hostname, SSLSession session) {
                        return HttpsURLConnection.getDefaultHostnameVerifier().verify(endpoint.getHost(), session);
                    }
                });

后来发现，原本能上传的 app 也失败了。
甚至官方 demo 也不行。

以为是手机时间不对，最后发现是手机开代理了。