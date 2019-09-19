# 官方文档 命令行操作
[Keep your fork synced](https://help.github.com/articles/fork-a-repo/#keep-your-fork-synced)

    查看
    git remote -v
    
    如果没有 upstream 则添加
    git remote add upstream <>
    
然后 [Syncing a fork](https://help.github.com/articles/syncing-a-fork/)

    git fetch upstream
    git merge upstream/master
    
# 网页 pull request 操作
[Syncing your fork to the original repository via the browser](https://github.com/KirstieJane/STEMMRoleModels/wiki/Syncing-your-fork-to-the-original-repository-via-the-browser)

[github上fork了别人的项目后，再同步更新别人的提交](https://blog.csdn.net/qq1332479771/article/details/56087333)

文档中写得很清楚  
点击 compare 进入 Comparing changes  
这个时候仔细看，实际是转到了 upstream  
注意简头指向  
base fork 选择自己的仓库  
head fork 选择 upstream

# github 或 jetbrains 客户端操作
[gitlab或github下fork后如何同步源的新更新内容？](https://www.zhihu.com/question/28676261)

