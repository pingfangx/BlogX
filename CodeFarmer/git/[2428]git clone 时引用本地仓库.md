[md]

克隆时想要引用本地仓库，但本地仓库又经过修改，不能直接复制。  
想起 git clone 时的一些参数，于是进行查看。

[参考项目](https://github.com/pingfangx/TranslatorX/tree/develop-git_docs)
## --shared -s
```
$ git clone -s <repository>
$ git clone -s D:/workspace/github/test/1/test
```
repository 是本地的仓库，克隆后有 git 一些文件，但是 objects 中没有对象。  
如果进行删除分枝等操作要小心（见原文）。

## --reference
```
$ git clone --reference <repository> <repository>
$ git clone --reference D:/workspace/github/test/1/test https://github.com/pingfangx/test.git
```
自动设置 .git/objects/info/alternates 以从引用仓库获取对象。  
引用，不复制对象。

## --dissociate
```
$ git clone --dissociate --reference <repository> <repository>
$ git clone --dissociate --reference D:/workspace/github/test/1/test https://github.com/pingfangx/test.git
```
就是我需要的，会复制对象（已打包，在 .git/objects/pack中）

最后的日志如下
```
$ git clone --dissociate --reference E:\\xx\\work\\file\\github\\omegat https://github.com/pingfangx/omegat.git
Cloning into 'omegat'...
remote: Counting objects: 889, done.
remote: Compressing objects: 100% (20/20), done.
remote: Total 889 (delta 537), reused 539 (delta 532), pack-reused 335
Receiving objects: 100% (889/889), 306.80 KiB | 37.00 KiB/s, done.
Resolving deltas: 100% (632/632), completed with 285 local objects.
Counting objects: 102420, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (23882/23882), done.
Writing objects: 100% (102420/102420), done.
Total 102420 (delta 70134), reused 102245 (delta 69959)
Checking out files: 100% (4475/4475), done.

```

[/md]