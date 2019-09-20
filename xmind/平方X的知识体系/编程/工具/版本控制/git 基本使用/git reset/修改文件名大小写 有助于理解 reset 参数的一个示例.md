相关参数
    
    --soft
    只重置 head
    
    --mixed
    重置索引不重置工作树

如果要修改文件名的大小写，reset --soft 是无法实现的，因为文件已经添加到索引中

在这种情况下，就需要使用 reset --mixed