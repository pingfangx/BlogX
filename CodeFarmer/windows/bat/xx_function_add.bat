@echo off

echo 1-д��ע���
echo 2-ɾ��ע���
echo ��ѡ��



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
echo д��ע���

rem �Ӳ�������
set cmd=reg add %sub_cmd_path% /v MUIVerb /d "�½� md �ļ�" /f
echo %cmd%
%cmd%

rem �Ӳ�������
rem %v ��ʾ����ǰĿ¼������˵�� %1 ������Ч���鿴 git ��ʹ�� %v
rem %%v �� bat ��Ҫת��
rem \" ������д��ע���ʱ��Ҫת��
rem ת������д��ע����ֵΪ "<sub_cmd_cmd>" "%v"
set cmd=reg add %sub_cmd_path%\command /ve /d "\"%sub_cmd_cmd%\" \"%%v\"" /f
echo %cmd%
%cmd%


rem ���һ��������
set cmd=reg add %main_cmd_path% /v MUIVerb /d "XX ����" /f
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

rem ɾ���Ӳ���
set cmd=reg delete %sub_cmd_path%
echo %cmd%
%cmd%


rem ɾ��������
set cmd=reg delete %main_cmd_path%
echo %cmd%
%cmd%

goto exit

:exit
pause