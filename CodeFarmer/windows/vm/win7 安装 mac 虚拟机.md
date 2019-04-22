Xcode 最新 10.1  
需要 macOS 10.13.6

# 1 下载相关文件
找到  
[How to Install macOS Mojave Final on VirtualBox on Windows PC](https://techsviewer.com/install-macos-10-14-mojave-virtualbox-windows/)

该网站有各版本的可供下载。

[Category - VirtualBox](https://techsviewer.com/category/virtual-machine/virtualbox/)

Google Drive 下载不了，可以从提供的 Media-fire 下载。

# 3 添加虚拟机
## 命名
* Name MacOS 10.14
* Type MacOS
* Version macOS 64-bit
## 分配内存 一半
## 选择硬盘文件 选择 vmdk

# 4 编辑虚拟机
* 系统 > 主板，可以修改内存
* 系统 > 处理器，分配 cpu 为 1/2
* 显示 > 显存大小增大
* 存储 > 勾上使用主机 I/O

# 5 命令行修改
    cd "C:\Program Files\Oracle\VirtualBox\"
    VBoxManage.exe modifyvm "Your VM Name" --cpuidset 00000001 000106e5 00100800 0098e3fd bfebfbff
    VBoxManage setextradata "Your VM Name" "VBoxInternal/Devices/efi/0/Config/DmiSystemProduct" "iMac11,3"
    VBoxManage setextradata "Your VM Name" "VBoxInternal/Devices/efi/0/Config/DmiSystemVersion" "1.0"
    VBoxManage setextradata "Your VM Name" "VBoxInternal/Devices/efi/0/Config/DmiBoardProduct" "Iloveapple"
    VBoxManage setextradata "Your VM Name" "VBoxInternal/Devices/smc/0/Config/DeviceKey" "ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc"
    VBoxManage setextradata "Your VM Name" "VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC" 1
    
# QA
* 鼠标不可用
[Fix Mouse & Keyboard Stuck on macOS Mojave on VirtualBox](https://www.geekrar.com/fix-mouse-keyboard-stuck-macos-mojave-virtualbox/)