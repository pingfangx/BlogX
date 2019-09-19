cipher_suites 和 extensions 同时存在于 ClientHello 和 ServerHello 中
# cipher_suites
    uint8 CipherSuite[2];

加密套件虽然只有两个字节，但是不代表只能表示两个信息。  
实际上，加密套件表示密钥交换使用的算法(Key Exchange)、数据加密的算法(Cipher)、消息认证的算法(MAC)  
见 Appendix C.  Cipher Suite Definitions，如

    CipherSuite TLS_RSA_WITH_AES_128_CBC_SHA          = { 0x00,0x2F };
    
# supported_signature_algorithms
见 7.4.1.4.1 节
数据在 ClientHello 的 extensions 中  
当扩展类型为 signature_algorithms 时，在 extension_data 字段中可以包含 supported_signature_algorithms

支持的签名算法也包括签名和哈希，但只是用在握手阶段的。  
客户端向服务器表明可以在数字签名中使用哪些签名/散列算法对  
服务器接下来会在 ServerHello 后向客户端发送 Certificate 消息，  
其中包含的签名就需要用客户端表明的支持的签名算法来签名。  


