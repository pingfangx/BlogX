启动脚本后就会出现错误

    nohup ./tieba_sign.py &

    Exit code: 255

    再输入命令都提示
    # ls
    QEMU-KVM Agent is not running inside VE
    Exit code: 722999
    
服务 stop 再 start 都不行，我甚至提交工单了。  
后来发现 force stop 就可以了。

[搬瓦工 KiwiVM 后台 Root Shell – Basic / Advanced / Interactive 的区别-Bandwagonhost中文网](https://www.bandwagonhost.net/3657.html)

知道可能是不应该用 basic，使用 Advanced

    直接执行无效
    
    ./root/xx/tieba_sign/tieba_sign.py &
    
    改为下述成功
    cd root/xx/tieba_sign/
    nohup ./tieba_sign.py &