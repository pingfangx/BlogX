anr 生成于 /data/anr 目录中。

以前的版本只需要 adb pull 就可以拉出来，后来改了权限。

查了一下有的说使用 adb bugreport 试了一下失败。

于是查询了一下，使用 ls -l 查看权限，使用 chmod 修改权限。

    adb shell
    su
    cd data
    chmod -R 777 anr
    cd anr
    ls -l
    adb pull /data/anr D:/adb
    
修改完就可以拉出来了。

如果没有 root 怎么办？cat 也没有权限，估计只有 bugreport 可行了。