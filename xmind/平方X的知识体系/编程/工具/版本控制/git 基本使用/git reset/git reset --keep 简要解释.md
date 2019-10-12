# 文档

    git reset [--soft | --mixed [-N] | --hard | --merge | --keep] [-q] [<commit>]
    
# 说明
> Resets index entries and updates files in the working tree that are different between <commit> and HEAD. If a file that is different between <commit> and HEAD has local changes, reset is aborted.
    
> 重置索引项并更新 <commit> 和 HEAD 之间不同的工作树中的文件。如果在 <commit> 和 HEAD 之间不同的文件有本地更改，则重置将中止。

# 解释
    意思是将索引重置到 <commit>
    
    更新 <commit> 和 HEAD 之间不同的工作树中的文件
    是指，如果 <commit> 与 HEAD 之前有某些文件变更了，就重置到 <commit> 的状态。
    keep 的意思是，如果某文件在 <commit> 与 HEAD 中没有变更，就不处理它
    这样，如果 working 中有对该文件的修改，则会 keep
    
> “reset --keep”表示用于删除当前分支中的某些最后提交时，保留工作树中的更改。如果要删除的提交中的更改与要保留的工作树中的更改之间可能存在冲突，则不允许重置。这就是为什么不允许在工作树和头之间以及头和目标之间都有更改。为了安全起见，当存在未合并的条目时，也不允许这样做。    


# 示例
## 删除不必要的提交
## 在另一方 push --force 后接受 orign/ 的提交，但是保留本地更改
