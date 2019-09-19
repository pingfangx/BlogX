[Removing sensitive data from a repository](https://help.github.com/articles/removing-sensitive-data-from-a-repository/)

    git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch PATH-TO-YOUR-FILE-WITH-SENSITIVE-DATA' --prune-empty --tag-name-filter cat -- --all

## 命令解析
    git filter-branch --index-filter <command>
    用于执行
    
    --force
    git filter-branch refuses to start with an existing temporary directory or when there are already refs starting with refs/original/, unless forced.

### 后面的参数
    --prune-empty --tag-name-filter cat -- --all
    
    --prune-empty
    将空提交删除。  

    --tag-name-filter cat
    重写tag

    -- --all  
    [--] [<rev-list options>…​]
    rev-list 的选项，--all 所有提交对象

### 执行的命令
    git rm --cached --ignore-unmatch
    --ignore-unmatch
    退出零状态即使没有文件匹配。

# 实际使用
    1 通过 git log -- <FILE-PATH> 查看 与文件相关的 log
    2 git rev-list head~4..head 查看 head4（不含）到 head（含）的所有 revision
    3 使用 --dry-run 测试  
    git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch --dry-run <FILE-PATH>' --prune-empty --tag-name-filter cat -- head~4..head
    测试时运后应该会提示
    WARNING: Ref '' is unchanged

    4 正式运行
    Ref '' was rewritten

其中

    FILE-PATH 在使用时可以表示为 /\*.zip，在 git-rm 的文档中有说明。
    