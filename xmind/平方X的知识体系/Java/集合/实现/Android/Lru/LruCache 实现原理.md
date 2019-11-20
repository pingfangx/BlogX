在 get set 时还提供了方法

    protected V create(K key) {
        return null;
    }
    protected void entryRemoved(boolean evicted, K key, V oldValue, V newValue) {}

其内部由 LinkedHashMap 支持

        this.map = new LinkedHashMap<K, V>(0, 0.75f, true);
        
# LinkedHashMap
在 get 时回调 java.util.LinkedHashMap#afterNodeAccess

将结点移到最后