@echo off

rem ѡ�����ʾ��
rem pingfangx
rem 20181012

echo ��ѡ�����
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