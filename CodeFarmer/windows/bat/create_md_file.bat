@echo off

rem 新建一个 md 文件
rem pingfangx
rem 20181012

rem 因为已经是目录，所以用 f 扩展
set current_dir=%~f1

echo 目标目录 %current_dir%

echo 请输入文件名
set /p input=
if "%input%"=="" (
    goto exit
)

set source_file="C:\Windows\ShellNew\template.txt"
set target_file="%current_dir%\%input%.md"

echo 新建文件 %target_file%
copy %source_file% %target_file%

rem 打开文件
%target_file%

goto exit

:exit