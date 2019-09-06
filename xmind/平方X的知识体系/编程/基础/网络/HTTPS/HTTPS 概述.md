原本是打开将 https 的密钥协商、数据加密了解清楚的，但是感觉太难了。  
几乎将 8446 翻译了一遍也没有完全搞懂，需要以后有时间，或者确实需要相关知识再认真学习。

[SSL/TLS协议运行机制的概述 - 阮一峰的网络日志](https://www.ruanyifeng.com/blog/2014/02/ssl_tls.html)

[RFC 5246 - The Transport Layer Security (TLS) Protocol Version 1.2](https://tools.ietf.org/html/rfc5246)

[RFC 8446 - The Transport Layer Security (TLS) Protocol Version 1.3](https://tools.ietf.org/html/rfc8446)

# TLS 包含两个主要组件：
* 握手协议(第 4 节)，用于验证通信方，协商加密模式和参数，以及建立共享密钥材料。握手协议旨在抵制篡改；如果连接没有受到攻击，主动攻击者应该不能够强制对等方协商不同的参数。
* 记录协议(第 5 节)，它使用握手协议建立的参数来保护通信对等体之间的通信。记录协议将流量划分为一系列记录，每个记录使用通信密钥独立保护。

# 握手协议
## 密钥交换
* ClientHello
* ServerHello 
* HelloRetryRequest
## 服务器参数
* EncryptedExtensions
* CertificateRequest
## 认证消息
* Certificate
* CertificateVerify
* Finished