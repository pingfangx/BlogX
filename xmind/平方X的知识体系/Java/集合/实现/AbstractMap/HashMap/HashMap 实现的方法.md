# HashMap
    public class HashMap<K,V> extends AbstractMap<K,V>
        implements Map<K,V>, Cloneable, Serializable 

方法|Abstract Map|HashMap|备注
-|-|-|-
V get(Object key);|√|√|getNode(hash(key), key)
V put(K key, V value);|-|√|putVal
void putAll(Map<? extends K, ? extends V> m);|√|√|
V remove(Object key);|√|√|removeNode
boolean containsKey(Object key);|√|√|return getNode(hash(key), key) != null;
boolean containsValue(Object value);|√|√|
int size();|√|√|return size;
boolean isEmpty();|√|√|return size == 0;
void clear();|√|√|迭代将 tab 置空
Set<K> keySet();|√|√|
Collection<V> values();|√|√|
Set<Map.Entry<K, V>> entrySet();|×|√|
boolean equals(Object o);|√||
int hashCode();|√||