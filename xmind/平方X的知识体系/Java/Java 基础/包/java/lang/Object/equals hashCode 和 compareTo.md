# equals 和 hashCode 是 Object 类的方法，compareTo 是 Comparable 接口的方法
## compareTo
> 强烈推荐 (x.compareTo(y)==0) == (x.equals(y)) 这种做法，但并不是 严格要求这样做。一般来说，任何实现 Comparable 接口和违背此条件的类都应该清楚地指出这一事实。推荐如此阐述：“注意：此类具有与 equals 不一致的自然排序。”

## equals
> 注意：当此方法被重写时，通常有必要重写 hashCode 方法，以维护 hashCode 方法的常规协定，该协定声明相等对象必须具有相等的哈希码。

## hashCode
> 如果根据 equals(Object) 方法，两个对象是相等的，那么对这两个对象中的每个对象调用 hashCode 方法都必须生成相同的整数结果。

> 如果根据 equals(java.lang.Object) 方法，两个对象不相等，那么对这两个对象中的任一对象上调用 hashCode 方法不 要求一定生成不同的整数结果。但是，程序员应该意识到，为不相等的对象生成不同整数结果可以提高哈希表的性能。

如何理解这两句话，主要就是作为 HashMap 的键

如果 equals(Object) == true，意味着两个对象相等。

那么用相等的对象为键，取出的值应该相等。所以如果 hashCode 不相等，则无法存取。

而如果 equals(Object) == false，则 hashCode 可以相等，哈希碰撞。  

如果 hashCode 相等，如何取出键对应的值？

可以看到 hashCode 相等，还要比较 key 的 equals

这也就是 hashCode 和 equals 相关连的一部分

java.util.HashMap#getNode


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