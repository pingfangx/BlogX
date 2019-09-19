@echo off

rem Win7 安装 MacOC 虚拟机时需要的设置
rem 参考 https://techsviewer.com/install-macos-10-14-mojave-virtualbox-windows/
rem pingfangx
rem 20180417

set home=D:\xx\software\program\VirtualBox
set vm_name=MacOS 10.14

set cmd=cd /d %home%
echo %cmd%
%cmd%

set cmd=VBoxManage.exe modifyvm "%vm_name%" --cpuidset 00000001 000106e5 00100800 0098e3fd bfebfbff
echo %cmd%
%cmd%

set cmd=VBoxManage setextradata "%vm_name%" "VBoxInternal/Devices/efi/0/Config/DmiSystemProduct" "iMac11,3"
echo %cmd%
%cmd%

set cmd=VBoxManage setextradata "%vm_name%" "VBoxInternal/Devices/efi/0/Config/DmiSystemVersion" "1.0"
echo %cmd%
%cmd%

set cmd=VBoxManage setextradata "%vm_name%" "VBoxInternal/Devices/efi/0/Config/DmiBoardProduct" "Iloveapple"
echo %cmd%
%cmd%

set cmd=VBoxManage setextradata "%vm_name%" "VBoxInternal/Devices/smc/0/Config/DeviceKey" "ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc"
echo %cmd%
%cmd%

set cmd=VBoxManage setextradata "%vm_name%" "VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC" 1
echo %cmd%
%cmd%


echo 任务完成
pause