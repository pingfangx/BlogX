
[How can I get VirtualBox to run at 1366x768?](https://superuser.com/questions/443445)

里面方法都试了，又升级了版本，差点想放弃了。


    1
    VBoxManage controlvm "Name of VM" setvideomodehint 1366 768 32
    
    2
    VBoxManage.exe setextradata "Windows 8 RTM Evaluation" CustomVideoMode1 1366x768x32
    
    3
    VBoxManage setextradata global GUI/MaxGuestResolution any
    VBoxManage setextradata "Win 10" "CustomVideoMode1" "1366x786x32"
    
最后更限定具体主机和虚拟机才找到

[Change MacOS X guest screen resolution for VirtualBox](https://superuser.com/a/1264540)

    VBoxManage setextradata "mac" "VBoxInternal2/EfiGraphicsResolution" "1920x1080"
    终于成功
    太大了，改为 1366x768 也成功了。
    
    下面还有答案
    VBoxManage setextradata "vmname" VBoxInternal2/EfiGopMode 3
    0 – 640×480
    1 – 800×600
    2 – 1024×768
    3 – 1280×1024
    4 – 1440×900
    5 – 1920×1200 
    
    经过测试无效，可能是被其他设置覆盖了。
    
可以查看配置文件

    C:\Users\Admin\VirtualBox VMs\MacOS 10.14

    如果与 host 的屏幕 1920*1080 一样大，则只有全屏才能良好的展示。于是略微缩小一点
    1900*960
    结果自动变为了 1080*720