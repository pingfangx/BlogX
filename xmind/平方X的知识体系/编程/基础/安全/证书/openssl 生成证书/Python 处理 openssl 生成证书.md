# 如何生成
使用 OpenSSL.crypto

[OpenSSL — Python interface to OpenSSL](https://pyopenssl.org/en/stable/api.html)

[How to generate a certificate using pyOpenSSL to make it secure connection?](https://stackoverflow.com/questions/44055029)
# 如何输出
在输出时卡了一会儿，OpenSSl 并没有直接能展示的方法。  
但是 OpenSSL.crypto.dump_privatekey 可以将 key 输出为指定格式，如 crypto.FILETYPE_PEM

有了 pem，可以使用 Crypto.PublicKey.RSA.importKey

