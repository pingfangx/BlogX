# 整体包
    完整包
    0000   f0 9f c2 18 ec e3 40 8d 5c 4e 3b a3 08 00 45 00
    0010   00 3c 08 3e 40 00 40 06 6d 34 c0 a8 01 57 dc b5
    0020   26 95 9b e5 01 bb bc b6 19 a5 00 00 00 00 a0 02
    0030   20 00 be 5f 00 00 02 04 05 b4 01 03 03 02 04 02
    0040   08 0a 00 28 30 37 00 00 00 00

    数据链路层
    0000   f0 9f c2 18 ec e3 40 8d 5c 4e 3b a3 08 00
    
    网络层
    0000                                             45 00
    0010   00 3c 08 3e 40 00 40 06 6d 34 c0 a8 01 57 dc b5
    0020   26 95
    
    传输层
    0020         9b e5 01 bb bc b6 19 a5 00 00 00 00 a0 02
    0030   20 00 be 5f 00 00 02 04 05 b4 01 03 03 02 04 02
    0040   08 0a 00 28 30 37 00 00 00 00

# 数据链路层 以太网 MAC 帧
    0000   f0 9f c2 18 ec e3 40 8d 5c 4e 3b a3 08 00
    
    Ethernet II, Src: Giga-Byt_4e:3b:a3 (40:8d:5c:4e:3b:a3), Dst: Ubiquiti_18:ec:e3 (f0:9f:c2:18:ec:e3)
    Destination: Ubiquiti_18:ec:e3 (f0:9f:c2:18:ec:e3)
    Source: Giga-Byt_4e:3b:a3 (40:8d:5c:4e:3b:a3)
    Type: IPv4 (0x0800)

    
    f0 9f c2 18 ec e3
    目的地址
    
    40 8d 5c 4e 3b a3
    源地址，此处为本机地址
    可以通过 ipconfig /all 查看
    物理地址. . . . . . . . . . . . . : 40-8D-5C-4E-3B-A3
    
    08 00
    类型，0x0800 表示上层是 IP
    
# 网络层 IP 数据报

    0000                                             45 00
    0010   00 3c 08 3e 40 00 40 06 6d 34 c0 a8 01 57 dc b5
    0020   26 95
   
    Internet Protocol Version 4, Src: 192.168.1.87, Dst: 220.181.38.149
    0100 .... = Version: 4
    .... 0101 = Header Length: 20 bytes (5)
    Differentiated Services Field: 0x00 (DSCP: CS0, ECN: Not-ECT)
    Total Length: 60
    Identification: 0x083e (2110)
    Flags: 0x4000, Don't fragment
    Time to live: 64
    Protocol: TCP (6)
    Header checksum: 0x6d34 [validation disabled]
    [Header checksum status: Unverified]
    Source: 192.168.1.87
    Destination: 220.181.38.149
    
    45
    0b01000101  版本 4（IPv4），首部长度 5 个32位字，即5*4=20字节，从 0x000d-0x0021 共 20 字节
    
    00
    区分服务
    
    00 3c
    总长度，60，首部与数据之和，从 0x000d-0x004a
    
    08 3e
    标识
    
    40 00
    标志与片偏移，其中0x40=0b01000000，标志为高 3 位，1 表示DF，Don't Fragment
    
    40
    生存时间，0x40=64
    
    06
    协议，06 表示 TCP
    
    6d 34
    检验和
    
    c0 a8 01 57
    源地址
    0xc0=192
    0xa8=168
    0x01=1
    0x57=87
    
    dc b5 26 95
    目的地址
    0xdc=220
    0xb5=181
    0x26=38
    0x95=149
    
# 传输层 TCP 报文段
    0020         9b e5 01 bb bc b6 19 a5 00 00 00 00 a0 02
    0030   20 00 be 5f 00 00 02 04 05 b4 01 03 03 02 04 02
    0040   08 0a 00 28 30 37 00 00 00 00
    
    Transmission Control Protocol, Src Port: 39909, Dst Port: 443, Seq: 0, Len: 0
    Source Port: 39909
    Destination Port: 443
    [Stream index: 0]
    [TCP Segment Len: 0]
    Sequence number: 0    (relative sequence number)
    [Next sequence number: 0    (relative sequence number)]
    Acknowledgment number: 0
    1010 .... = Header Length: 40 bytes (10)
    Flags: 0x002 (SYN)
        000. .... .... = Reserved: Not set
        ...0 .... .... = Nonce: Not set
        .... 0... .... = Congestion Window Reduced (CWR): Not set
        .... .0.. .... = ECN-Echo: Not set
        .... ..0. .... = Urgent: Not set
        .... ...0 .... = Acknowledgment: Not set
        .... .... 0... = Push: Not set
        .... .... .0.. = Reset: Not set
        .... .... ..1. = Syn: Set
        .... .... ...0 = Fin: Not set
        [TCP Flags: ··········S·]
    Window size value: 8192
    [Calculated window size: 8192]
    Checksum: 0xbe5f [unverified]
    [Checksum Status: Unverified]
    Urgent pointer: 0
    Options: (20 bytes), Maximum segment size, No-Operation (NOP), Window scale, SACK permitted, Timestamps
        TCP Option - Maximum segment size: 1460 bytes
        TCP Option - No-Operation (NOP)
        TCP Option - Window scale: 2 (multiply by 4)
        TCP Option - SACK permitted
        TCP Option - Timestamps: TSval 2633783, TSecr 0
            Kind: Time Stamp Option (8)
            Length: 10
            Timestamp value: 2633783
            Timestamp echo reply: 0
    [Timestamps]

    9b e5
    源端口 0x9be5=39909
    
    01 bb
    目的端口 0x01bb=443
    
    bc b6 19 a5
    序号
    
    00 00 00 00
    确认号
    
    a0 02
    数据偏移、保留、控制位
    0xa002=0b10100000 00000010
    前4位表示数据偏移，即首部长度，0b1010=10，表示 10 个 32 位字，即 40 个字节。
    40 字节是 0x0022-0x0049
    
    后续6位为保留
    最后5位为控制位，SYN 位设为1
    
    20 00
    窗口，0x2000=8192
    
    be 5f
    检验和
    
    00 00
    紧急指针
    
    到此为止，是 20 字节的固定首部，后续 20 字节是选项
    
