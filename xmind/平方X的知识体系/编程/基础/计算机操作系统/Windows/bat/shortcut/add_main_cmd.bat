@echo off

echo 1-д��ע���
echo 2-ɾ��ע���
echo ��ѡ��

rem ���������� ; �ָ�
set sub_cmd_name=XX.NewMdFile;XX.LoginVpn

set main_cmd_name=xx_function
set main_cmd_show_name=XX ����
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
echo д��ע���

rem ���һ��������
set cmd=reg add %main_cmd_path% /v MUIVerb /d "%main_cmd_show_name%" /f
echo %cmd%
%cmd%

rem �����Ӳ���
set cmd=reg add %main_cmd_path% /v SubCommands /d "%sub_cmd_name%" /f
echo %cmd%
%cmd%

goto exit

:uninstall
echo ɾ��ע���
rem û����� /f ҪС�ļ��

rem ɾ��������
set cmd=reg delete %main_cmd_path%
echo %cmd%
%cmd%

goto exit

:exit
pause