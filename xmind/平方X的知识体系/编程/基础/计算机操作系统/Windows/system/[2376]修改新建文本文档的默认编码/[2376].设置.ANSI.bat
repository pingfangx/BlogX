@echo �����ļ�
copy "[2376].template.txt" "C:\Windows\SHELLNEW\template.txt"

@echo.
@echo д��ע���
reg add "HKEY_CLASSES_ROOT\.txt\ShellNew" /v "FileName" /t REG_SZ /d "C:\Windows\ShellNew\template.txt" /f

pause