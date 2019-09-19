# 最终结果
    git clone <repository> --depth 1 --branch <branch name> --single-branch


下载omegat的时候，文件非常多，而且github还不稳定，后来终于下好了,400多M。
```
Receiving objects: 100% (101728/101728), 437.93 MiB | 984.00 KiB/s, done.
```

于是找到
[kassadin.《github 下载的zip项目如何再关联回去》](http://blog.csdn.net/a06_kassadin/article/details/72592199)  
转到[How to clone git repository from its zip](https://stackoverflow.com/questions/15681643)  
再转到[How to complete a git clone for a big project on an unstable connection?](https://stackoverflow.com/questions/3954852)

# 备注
后来又想到一个方法，但没测试，下载 zip 再使用 --dissociate --reference  
见[git clone 时引用本地仓库](http://blog.pingfangx.com/2428.html)  
再备注，应该不行吧，项目文件不代表仓库文件

# 0x01 无效 --bare 
[fracjackmac的回复](https://stackoverflow.com/a/31781016)  
```
git clone --bare https://github.com/omegat-org/omegat omegat
```
但是自己测试了一下，还是不行。

# 0x02 无效 init pull
[umläute的答案](https://stackoverflow.com/a/15682258)
```
$ git init
$ git remote add origin https://github.com/user/repo.git
$ git pull
```
实际效果如图，原因应该是我们下载的只是master，pull时又把别的分枝的文件下载了。

# 0x03 无效 init update
[arctelix的回复](https://stackoverflow.com/a/38909009)
同上一个
```
unzip <repo>.zip
cd <repo>
git init
git add .
git remote add origin https://github.com/<user>/<repo>.git
git remote update
git checkout master
```

# 0x04 有效 git clone --depth=1 
[Jakub Narębski的回复](https://stackoverflow.com/a/3957733)
效果还不错

# 0x05 有效 `git clone --depth <Number> <repository> --branch <branch name> --single-branch`
[Ahed Eid的回复](https://stackoverflow.com/a/26488855)