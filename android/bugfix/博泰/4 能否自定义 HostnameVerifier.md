认证为于 okhttp3.internal.connection.RealConnection#connectTls

      // Verify that the socket's certificates are acceptable for the target host.
      if (!address.hostnameVerifier().verify(address.url().host(), sslSocketSession)) {

      查看 Address 的构造函数调用
      okhttp3.internal.http.RetryAndFollowUpInterceptor#createAddress
            
    
      private Address createAddress(HttpUrl url) {
        SSLSocketFactory sslSocketFactory = null;
        HostnameVerifier hostnameVerifier = null;
        CertificatePinner certificatePinner = null;
        if (url.isHttps()) {
          sslSocketFactory = client.sslSocketFactory();
          hostnameVerifier = client.hostnameVerifier();
          certificatePinner = client.certificatePinner();
        }

        return new Address(url.host(), url.port(), client.dns(), client.socketFactory(),
            sslSocketFactory, hostnameVerifier, certificatePinner, client.proxyAuthenticator(),
            client.proxy(), client.protocols(), client.connectionSpecs(), client.proxySelector());
      }
      
    hostnameVerifier 由  OkHttpClient 设置，只要创建时设置就可以了。
    但是旧版使用的 okhttp3.internal.tls.DistinguishedNameParser#DistinguishedNameParser 是包私有的，  
    不能直接复制旧版 HostnameVerifier 的代码
    
并且修改了认证就不安全了，还是应该由他们更新证书。