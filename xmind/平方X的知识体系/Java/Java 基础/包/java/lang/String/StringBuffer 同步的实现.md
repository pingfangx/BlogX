几乎所有操作的方法都加了 synchronized

搜索
    
    public\s(?!syn)
    
例外包括

# 构造方法
# 部分 insert 重载

        // Note, synchronization achieved via invocations of other StringBuffer methods
        // after narrowing of s to specific type
        // Ditto for toStringCache clearing
        
# indexOf 和 lastIndexOf 重载
        // Note, synchronization achieved via invocations of other StringBuffer methods