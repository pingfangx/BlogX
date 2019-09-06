## Little endian 和 Big endian
[字节顺序](https://zh.wikipedia.org/wiki/%E5%AD%97%E8%8A%82%E5%BA%8F)

> 如果最低有效位在最高有效位的前面，则称小端序；反之则称大端序。
简单理解为位数从高到低，也就是说按顺序排，就是大端序，换了顺序就是小端序。

便于理解记忆，endian 是端、尾的意思。  
从左向右，如果是 Big-endian 说明是尾端大，也就是从左到右升序。  
反之 Little-endian 即为从左到右降序。


# 网络序
> 网络传输一般采用大端序，也被称之为网络字节序，或网络序。IP协议中定义大端序为网络字节序。

> Many IETF RFCs use the term network order, meaning the order of transmission for bits and bytes over the wire in network protocols. Among others, the historic RFC 1700 (also known as Internet standard STD 2) has defined the network order for protocols in the Internet protocol suite to be big-endian, hence the use of the term "network byte order" for big-endian byte order.[23]

> However, not all protocols use big-endian byte order as the network order. 