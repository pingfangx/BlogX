
想要回答问题，自然需要了解 HashMap 的结构。

# transient Node<K,V>[] table;
## 为什么其长度需要是 2 的次方
因为后续将使用 (n - 1) & hash 作为索引从结点数组中获取结点。  
只有 n 为 2 的次方，才能保证 n-1 的二进制完全是 1

如果不满足的话，由于某位上为 0，将造成与运算结果在这一位上丢失。

    如 n=9
    则二进制为 0b 1001
    n-1 = 0b 1000
    那么，如果 hash 的后三位为任何值，如 0b000 0b001 0b010 0b111
    在与运算以后都无法区分，也就无法正常利用 table 中的位置，而造成更多的冲突
    
## hash 的实现
《hashCode 是如何在 HashMap 中生效的》

# get 方法
    public V get(Object key) {
        Node<K,V> e;
        return (e = getNode(hash(key), key)) == null ? null : e.value;
    }
    
    final Node<K,V> getNode(int hash, Object key) {
        Node<K,V>[] tab; Node<K,V> first, e; int n; K k;
        if ((tab = table) != null && (n = tab.length) > 0 &&
            (first = tab[(n - 1) & hash]) != null) {
            if (first.hash == hash && // always check first node
                ((k = first.key) == key || (key != null && key.equals(k))))
                return first;
            if ((e = first.next) != null) {
                if (first instanceof TreeNode)
                    return ((TreeNode<K,V>)first).getTreeNode(hash, key);
                do {
                    if (e.hash == hash &&
                        ((k = e.key) == key || (key != null && key.equals(k))))
                        return e;
                } while ((e = e.next) != null);
            }
        }
        return null;
    }
    
* 对 Object 计算用于 HashMap 的 hash
* (n-1) & hash 求 index 从表中取值
* 如果 k==key 或者 key!=null && key.equals(k) 返回第一个
* 第一个不匹配，如果是树结点，调用 getTreeNode()
* 如果不是树结点，迭代判断

# put 方法
    HashMap put 方法执行图.puml
    
    final V putVal(int hash, K key, V value, boolean onlyIfAbsent,
                   boolean evict) {
        Node<K,V>[] tab; Node<K,V> p; int n, i;
        if ((tab = table) == null || (n = tab.length) == 0)
            n = (tab = resize()).length;
        if ((p = tab[i = (n - 1) & hash]) == null)
            tab[i] = newNode(hash, key, value, null);
        else {
            Node<K,V> e; K k;
            if (p.hash == hash &&
                ((k = p.key) == key || (key != null && key.equals(k))))
                e = p;
            else if (p instanceof TreeNode)
                e = ((TreeNode<K,V>)p).putTreeVal(this, tab, hash, key, value);
            else {
                for (int binCount = 0; ; ++binCount) {
                    if ((e = p.next) == null) {
                        p.next = newNode(hash, key, value, null);
                        if (binCount >= TREEIFY_THRESHOLD - 1) // -1 for 1st
                            treeifyBin(tab, hash);
                        break;
                    }
                    if (e.hash == hash &&
                        ((k = e.key) == key || (key != null && key.equals(k))))
                        break;
                    p = e;
                }
            }
            if (e != null) { // existing mapping for key
                V oldValue = e.value;
                if (!onlyIfAbsent || oldValue == null)
                    e.value = value;
                afterNodeAccess(e);
                return oldValue;
            }
        }
        ++modCount;
        if (++size > threshold)
            resize();
        afterNodeInsertion(evict);
        return null;
    }
    
* Object 计算 key 计算 index 从表中取结点
* 如果结点为空，则直接新建并置于 index 处
* 如果不为空，如果是树结点，则调用 putTreeVal
* 如果不为空，如果是链表结点，则遍历到最后，添加
* 添加后，如果大于树化阈值，则进行树化
* 树化需要判断表 size，如果 < 64 先增大表大小，以减小冲突