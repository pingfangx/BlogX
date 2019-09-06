# pem
已经知道了 pem 证书文件的基本结构

    -----BEGIN CERTIFICATE-----
    -----END CERTIFICATE-----
    
中间是 base64 编码的数据。

# der
openssl base64 -d -in <file> -out <file>

生成的文件，其内容为 der 编码的文件。  

DER 是 ASN.1 语言使用的一种编码。

# ASN.1
详见《X.509 ASN.1 DER》

[OPENSSL中RSA私钥文件（PEM格式）解析【一】_任家_新浪博客](http://blog.sina.com.cn/s/blog_4fcd1ea30100yh4s.html)

[RSA公钥文件（PEM）解析 - mxiaomi的专栏 - CSDN博客](https://blog.csdn.net/xuanshao_/article/details/51679824)

经过两天的仔细阅读，终于读懂了前 4 个字节，虽然没有什么用，但还是很有成就感

# 基本规则

    30 82 04 b8
基本编码规则在 X.690 中第 8 节定义

The encoding of a data value shall consist of four components which shall appear in the following order:
* identifier octets 
* length octets
* contents octets 
* end-of-contents octets 

第一个字节为 identifier octets，第 2-4 个字节是 length octets

## identifier octets 30
30 表示类型为 SEQUENCE  
根据定义
> The identifier octets shall encode the ASN.1 tag (class and number) of the type of the data value.

ASN.1 tag 在 X.680 中第 8 节定义

将 30 转为二进制，表示 0b00110000  

根据 X.690 8.1.2.2 中的描述  
这是一个低标签号，只用一个字节表示  
其中第 8、7 位为 0 0 表示标签类型为 Universal  
第 6 位为 1 表示该类型是结构类型  
后 5 位表示标签号，0b10000 表示 16，对应 X.680 8.6 中的 Sequence

## length octets 82 04 b8
长度字为确定形式，长形式。  
长形式的初始字节为 82，转为二进制为 0b10000010  
根据 X.690 8.1.3 中的定义，
第 8 位为 1，后 7 位表示后续长度字节的长度，10 表示后续 2 个字节表示长度。

04 b8 转为十进制为 1208，表示内容为 1208 个字节。

