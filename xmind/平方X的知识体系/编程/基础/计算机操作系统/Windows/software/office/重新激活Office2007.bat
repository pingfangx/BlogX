@echo off

set file="C:\Documents and Settings\All Users\Application Data\Microsoft\Office\Data\Opa12.dat"
if exist %file% (
    echo 删除%file%
    del %file%
) else (
    echo 不存在%file%
)

set dll="C:\Program Files (x86)\Common Files\microsoft shared\OFFICE12\MSO.DLL"
set dll_back="C:\Program Files (x86)\Common Files\microsoft shared\OFFICE12\MSO.DLL.BAK"

if exist %dll_back% (
    echo 存在%dll_back%
) else (
    echo 不存在 %dll_back%
    goto stop
)

if exist %dll% (
    echo 删除%dll%
    del %dll%
)

echo 复制 %dll_back% 为 %dll%
copy %dll_back% %dll%

:stop
pause