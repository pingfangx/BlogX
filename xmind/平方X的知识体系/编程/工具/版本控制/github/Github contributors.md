因为有人提了 pull request ，没有直接 mergin，进行了 rebase，而且修改了 commit，不知道在 contruibutors 中是否还有作者。
经过实测，虽然 contruibutors 中统计的是 commits，但是实际关心的是 commit 的 author 而不是 commiter  
因此可以放心 rebase，只要 author 保留，就在 contruibutors 中有

[I don't see myself in the repository contributors graph](https://help.github.com/enterprise/2.8/user/articles/i-don-t-see-myself-in-the-repository-contributors-graph/)

* 提交要合并到默认分支  
* 用户邮箱应正确在 github 注册