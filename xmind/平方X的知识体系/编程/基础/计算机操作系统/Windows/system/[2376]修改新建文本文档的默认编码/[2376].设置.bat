@echo 复制文件
copy "[2376].template.txt" "C:\Windows\SHELLNEW\template.txt"

@echo.
@echo 写入注册表
reg add "HKEY_CLASSES_ROOT\.txt\ShellNew" /v "FileName" /t REG_SZ /d "C:\Windows\ShellNew\template.txt" /f

pause