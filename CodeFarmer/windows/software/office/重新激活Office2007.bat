@echo off

set file="C:\Documents and Settings\All Users\Application Data\Microsoft\Office\Data\Opa12.dat"
if exist %file% (
    echo ɾ��%file%
    del %file%
) else (
    echo ������%file%
)

set dll="C:\Program Files (x86)\Common Files\microsoft shared\OFFICE12\MSO.DLL"
set dll_back="C:\Program Files (x86)\Common Files\microsoft shared\OFFICE12\MSO.DLL.BAK"

if exist %dll_back% (
    echo ����%dll_back%
) else (
    echo ������ %dll_back%
    goto stop
)

if exist %dll% (
    echo ɾ��%dll%
    del %dll%
)

echo ���� %dll_back% Ϊ %dll%
copy %dll_back% %dll%

:stop
pause