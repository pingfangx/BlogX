@echo off

rem ʾ��
rem pingfangx
rem 20181012

rem cd /the/path/to/github/xmind
rem mvn clean verify
rem /the/path/to/eclipse -nosplash -consoleLog \
rem    -application org.eclipse.equinox.p2.director \
rem    -repository file:/the/path/to/github/xmind/releng/org.xmind.product/target/repository/ \
rem    -installIU org.xmind.cathy.product \
rem    -profile XMindProfile \
rem    -roaming \
rem    -destination /the/path/to/target/xmind \
rem    -p2.os win32|macosx|linux \
rem    -p2.ws win32|cocoa|gtk \
rem    -p2.arch x86|x86_64
    
set mvn_path="E:\file\download\chrome\apache-maven-3.6.1-bin\apache-maven-3.6.1\bin\mvn"
set eclipse_path=D:\software\program\java\eclipse-2019-06\eclipse.exe
set repository_path=F:/git/mind/xmind
set target_module_path="%repository_path%/releng/org.xmind.cathy.target"
set target_path=%repository_path%/build

cd /d %repository_path%
%mvn_path% clean verify
rem 注意 -repository 参数是以 file: 开头的
%eclipse_path% -nosplash -consoleLog ^
    -application org.eclipse.equinox.p2.director ^
    -repository file:///%target_module_path% ^
    -installIU org.xmind.cathy.product ^
    -profile XMindProfile ^
    -roaming ^
    -destination %target_path% ^
    -p2.os win32 ^
    -p2.ws win32 ^
    -p2.arch x86_64
pause