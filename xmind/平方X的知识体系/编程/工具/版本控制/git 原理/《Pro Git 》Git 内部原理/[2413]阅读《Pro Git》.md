[md]

[Pro Git](https://git-scm.com/book/zh/v2)

20171016第一遍读完，感觉非常好，要多学习。

---

## 1.1 起步 - 关于版本控制
* 本地版本控制系统
* 集中化的版本控制系统
* 分布式版本控制系统
## 1.2 起步 - Git 简史
## 1.3 起步 - Git 基础
阅读后，又再读了[coding.《使用原理视角看 Git》](https://blog.coding.net/blog/principle-of-Git)  
[阅读《使用原理视角看 Git》](http://blog.pingfangx.com/2412.html)

# 2. Git 基础
## 2.3 Git 基础 - 查看提交历史
```
git log -2
$ git log --pretty=oneline
```


# 3. Git 分支
## 3.1 Git 分支 - 分支简介
查看一个分支的 tree 对象
```
cat .git/HEAD
cat .git/refs/heads/master
git cat-file -p <object>
```
通过 cat-file 一个 tree 对象,看到其保存的是文件 blob 对象，如果是文件夹，则又会是一下 tree 对象。  
带要支情况查看log
```
git log --oneline --decorate --graph --all
```

## 3.6 Git 分支 - 变基
>只对尚未推送或分享给别人的本地修改执行变基操作清理历史，从不对已推送至别处的提交执行变基操作

merge 在当前分支执行，merge 要合并的分支。  
rebase 在当前分支执行，rebase 到目标分支。

# 7. Git 工具
## 7.2 Git 工具 - 交互式暂存
> 如果运行 git add 时使用 -i 或者 --interactive 选项，Git 将会进入一个交互式终端模式，显示类似下面的东西

>也可以不必在交互式添加模式中做部分文件暂存 - 可以在命令行中使用 git add -p 或 git add --patch 来启动同样的脚本。


## 7.3 Git 工具 - 储藏与清理
很多命令可以学习
```
$ git stash --keep-index
$ git clean -n -d -x
```

## 7.5 Git 工具 - 搜索
```
$ git log -S <content> --oneline
```
译文中 -S 后面没有接空格，测试时发现有没有空格都可以正常搜索。

## 7.6 Git 工具 - 重写历史
```
$ git commit --amend
$ git rebase -i HEAD~3
filter-branch
```

## 7.7 Git 工具 - 重置揭密
可以多读几遍

## 7.8 Git 工具 - 高级合并
没有认真看

## 7.9 Git 工具 - Rerere
> reuse recorded resolution

## 7.10 Git 工具 - 使用 Git 调试
bisect 在这一节介绍


# 8. 自定义 Git

# 10. Git 内部原理
## 10.4 Git 内部原理 - 包文件
这一节解开了自己对 git 文件存储的疑惑。  
虽然每个不相同的文件都保存快照，但是也可以进行打包。
>事实上 Git 可以那样做。 Git 最初向磁盘中存储对象时所使用的格式被称为“松散（loose）”对象格式。 但是，Git 会时不时地将多个这些对象打包成一个称为“包文件（packfile）”的二进制文件，以节省空间和提高效率。 当版本库中有太多的松散对象，或者你手动执行 git gc 命令，或者你向远程服务器执行推送时，Git 都会这样做。

# A1.1 Appendix A: 其它环境中的 Git - 图形界面
>  你可以通过点击文件名左侧的图标来将该文件在暂存状态与未暂存状态之间切换，你也可以通过选中一个文件名来查看它的详情。




[/md]