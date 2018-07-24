@echo off

rem APK Signature Scheme v2
rem pingfangx

rem 初始化变量
set apk_signer_path="D:\xx\software\program\android\sdk\build-tools\27.0.3\apksigner.bat"
set keystore_path="D:\xx\software\program\android\AndroidSdkHome\.android\debug.keystore"
set apk_path="F:\xx\file\useless\apk\other\bili\iBiliPlayer-bili.apk"

rem 生成命令
set cmd=%apk_signer_path% sign -ks %keystore_path% %apk_path%

rem 输出并执行
echo %cmd%
%cmd%

rem 结束暂停
:stop
pause