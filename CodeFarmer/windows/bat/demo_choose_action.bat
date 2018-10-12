@echo off

rem 选择操作示例
rem pingfangx
rem 20181012

echo 请选择操作
set /p input=
if %input%==1 (
    goto action_1
)
if %input%==2 (
    goto action_2
)
goto exit

:action_1

goto exit

:action_2

goto exit

:exit
pause