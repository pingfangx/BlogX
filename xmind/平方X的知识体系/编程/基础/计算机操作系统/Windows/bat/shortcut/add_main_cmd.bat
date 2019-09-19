@echo off

echo 1-写入注册表
echo 2-删除注册表
echo 请选择

rem 多个子命令，用 ; 分隔
set sub_cmd_name=XX.NewMdFile;XX.LoginVpn

set main_cmd_name=xx_function
set main_cmd_show_name=XX 功能
set main_cmd_path=HKCR\Directory\Background\shell\%main_cmd_name%

set /p input=
if %input%==1 (
    goto install
)
if %input%==2 (
    goto uninstall
)
goto exit

:install
echo 写入注册表

rem 添加一个主操作
set cmd=reg add %main_cmd_path% /v MUIVerb /d "%main_cmd_show_name%" /f
echo %cmd%
%cmd%

rem 关联子操作
set cmd=reg add %main_cmd_path% /v SubCommands /d "%sub_cmd_name%" /f
echo %cmd%
%cmd%

goto exit

:uninstall
echo 删除注册表
rem 没有添加 /f 要小心检查

rem 删除主操作
set cmd=reg delete %main_cmd_path%
echo %cmd%
%cmd%

goto exit

:exit
pause