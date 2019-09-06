[基于 OpenSSL 自建 CA 和颁发 SSL 证书](https://www.jianshu.com/p/79c284e826fa)

[基于 OpenSSL 的 CA 建立及证书签发](https://www.cnblogs.com/popsuper1982/p/3843772.html)

使用 help 查看相关操作，不太详细，可查看  
[Documentation](https://www.openssl.org/docs/manmaster/man1/)

# 0 建立目录
由于会使用相关的配置，在使用 CA 时需要相应的目录，需要手动建立。

    demoCA/
        newcerts/
        private/
        serial(序号，内容为 01 即可)
        index.txt

# 1 建立 CA
## 1.1 生成 ca 根密钥
[genrsa](https://www.openssl.org/docs/manmaster/man1/genrsa.html)  
> generate an RSA private key


    不指定加密
    openssl genrsa -out ./demoCA/private/cakey.pem 4096
    
## 1.2 生成 CA 证书请求
[req](https://www.openssl.org/docs/manmaster/man1/req.html)
> 	PKCS#10 certificate request and certificate generating utility

    生成时只指定 CN 测试一下
    openssl req -new -days 3650 -key ./demoCA/private/cakey.pem -out careq.pem
    
    -new
    This option generates a new certificate request. 
    
    -days n
    When the -x509 option is being used this specifies the number of days to certify the certificate for, otherwise it is ignored. n should be a positive integer. The default is 30 days.
    
    -key filename
    指定私钥
    
## 1.3 自签发 CA 根证书
[ca](https://www.openssl.org/docs/manmaster/man1/ca.html)
> sample minimal CA application

    openssl ca -selfsign -in careq.pem -out ./demoCA/cacert.pem
    
## 23合成一步
    openssl req -new -x509 -days 3650 -key ./demoCA/private/cakey.pem -out ./demoCA/cacert.pem
    
# 2 为用户颁发证书
## 2.1 生成用户 RSA 密钥
    openssl genrsa -out userkey.pem 4096
## 2.2 生成用户证书请求
    openssl req -new -days 365 -key userkey.pem -out userreq.pem
## 2.3 使用 CA 签发证书
    openssl ca -in userreq.pem -out usercert.pem