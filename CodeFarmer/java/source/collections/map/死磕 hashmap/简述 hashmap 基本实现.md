hashmap 中有一个名为 table 的 Node 数组。  
正常情况下，通过 (n-1) & hash(key) 可以取出相应位置的 Node。

## hash 算法
    static final int hash(Object key) {
        int h;
        return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16);
    }
    
取 hashCode 然后与上无符号右移 16 位。

# put 算法
* put 时，取出 (n-1) & hash(key) 位置的 Node，如果为 null，直接放入即可。  
* 如果不为空，每个 Node 都有一个 next，充当链表，找到最后一个，添加到最后一个  
所以新添加的元素在链表的最后。  
* 在链表添加完成后，如果链表长度大于 TREEIFY_THRESHOLD，则 调用 treeifyBin 转为红黑树
* put 执行完后，判断列表的大小，如果大于 threshold，就需要 resize  

# resize 算法
使用无参构造函数

    public HashMap() {
        this.loadFactor = DEFAULT_LOAD_FACTOR; // all other fields defaulted
    }

这个时候，只设置了 loadFactor，别的都没有设置，那么在首次 put 的时候会调用 resize()  
正如 resize 的文档所说一样
    Initializes or doubles table size. 
    
    最基本的就是将容量翻倍，阈值翻倍，其中还有一些初始化状态的处理。
# 初始容量和加载因子如何生效
只需注意带参构造数

    public HashMap(int initialCapacity, float loadFactor) {
        ...
        this.loadFactor = loadFactor;
        this.threshold = tableSizeFor(initialCapacity);
    }
    此时的 threshold 保存的是容量，在首次 add 时将 threshold 作为初始容量
    别的时候都是 threshold = capacity * loadFactor
    
# tableSizeFor 算法

    static final int tableSizeFor(int cap) {
        int n = cap - 1;
        n |= n >>> 1;
        n |= n >>> 2;
        n |= n >>> 4;
        n |= n >>> 8;
        n |= n >>> 16;
        return (n < 0) ? 1 : (n >= MAXIMUM_CAPACITY) ? MAXIMUM_CAPACITY : n + 1;
    }
    通过多次移位，可以得到最高位的 1 后面全部都是 1
    此时加上 1 就得到了一个 > cap 的 2 的幂
    提前减去 1 就能得到 >= cap 的 2 的 幂