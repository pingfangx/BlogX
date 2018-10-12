@echo off

echo 1-写入注册表
echo 2-删除注册表
echo 请选择



set sub_cmd_name=XX.NewMdFile
set sub_cmd_cmd=D:\workspace\BlogX\CodeFarmer\windows\bat\create_md_file.bat
set sub_cmd_path=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\%sub_cmd_name%

set main_cmd_name=xx_function
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

rem 子操作名称
set cmd=reg add %sub_cmd_path% /v MUIVerb /d "新建 md 文件" /f
echo %cmd%
%cmd%

rem 子操作操作
rem %v 表示传当前目录，网上说的 %1 测试无效，查看 git 是使用 %v
rem %%v 是 bat 需要转义
rem \" 是引号写入注册表时需要转义
rem 转义后最后写入注册表的值为 "<sub_cmd_cmd>" "%v"
set cmd=reg add %sub_cmd_path%\command /ve /d "\"%sub_cmd_cmd%\" \"%%v\"" /f
echo %cmd%
%cmd%


rem 添加一个主操作
set cmd=reg add %main_cmd_path% /v MUIVerb /d "XX 功能" /f
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

rem 删除子操作
set cmd=reg delete %sub_cmd_path%
echo %cmd%
%cmd%


rem 删除主操作
set cmd=reg delete %main_cmd_path%
echo %cmd%
%cmd%

goto exit

:exit
pause