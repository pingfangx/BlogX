@echo off

rem �½�һ�� md �ļ�
rem pingfangx
rem 20181012

rem ��Ϊ�Ѿ���Ŀ¼�������� f ��չ
set current_dir=%~f1

echo Ŀ��Ŀ¼ %current_dir%

echo �������ļ���
set /p input=
if "%input%"=="" (
    goto exit
)

set source_file="C:\Windows\ShellNew\template.txt"
set target_file="%current_dir%\%input%.md"

echo �½��ļ� %target_file%
copy %source_file% %target_file%

rem ���ļ�
%target_file%

goto exit

:exit