# AbstractMap
    public abstract class AbstractMap<K,V> implements Map<K,V>
    
方法|实现|备注
-|-|-
V get(Object key);|√|迭代，根据 equals 或 null 判断
V put(K key, V value);|-|
void putAll(Map<? extends K, ? extends V> m);|√|迭代，调用 put
V remove(Object key);|√|迭代，根据 equlas 或 null 调用 Iterator.remove
boolean containsKey(Object key);|√|迭代，根据 equals 或 null 判断
boolean containsValue(Object value);|√|迭代，根据 equals 或 null 判断
int size();|√|return entrySet().size();
boolean isEmpty();|√|return size() == 0;
void clear();|√|entrySet().clear();
Set<K> keySet();|√|
Collection<V> values();|√|
Set<Map.Entry<K, V>> entrySet();|×|
boolean equals(Object o);|√|迭代判断，判断为 null 的 key 需要 containsKey
int hashCode();|√|迭代累加