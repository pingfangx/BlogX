相关文章很多，简单使用了一下，最难的还是过滤。

# 简单使用
完整安装，不要取消 Pcap

分为捕获过滤器和显示过滤器

# 过滤百度
由于 ping 的地址有时候还会变，所以应该在开发者工具中查看 Remote Address  
然后过滤

    ip.addr == <address>
    
