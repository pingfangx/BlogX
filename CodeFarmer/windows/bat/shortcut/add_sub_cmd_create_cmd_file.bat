@echo off

echo 1-д��ע���
echo 2-ɾ��ע���
echo ��ѡ��


rem �½��ӹ��ܣ�ֻ���޸��� 3 ��
set sub_cmd_name=XX.NewMdFile
set sub_cmd_show_name=�½� md �ļ�
set sub_cmd_cmd=D:\workspace\BlogX\CodeFarmer\windows\bat\shortcut\cmd_create_md_file.bat

set sub_cmd_path=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\%sub_cmd_name%


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
set cmd=reg add %sub_cmd_path% /v MUIVerb /d "%sub_cmd_show_name%" /f
echo %cmd%
%cmd%

rem �Ӳ�������
rem %v ��ʾ����ǰĿ¼������˵�� %1 ������Ч���鿴 git ��ʹ�� %v
rem %%v �� bat ��Ҫת��
rem \" ������д��ע���ʱ��Ҫת��
rem ת������д��ע�����ֵΪ "<sub_cmd_cmd>" "%v"
set cmd=reg add %sub_cmd_path%\command /ve /d "\"%sub_cmd_cmd%\" \"%%v\"" /f
echo %cmd%
%cmd%

goto exit

:uninstall
echo ɾ��ע���
rem û������ /f ҪС�ļ��

rem ɾ���Ӳ���
set cmd=reg delete %sub_cmd_path%
echo %cmd%
%cmd%


goto exit

:exit
pause