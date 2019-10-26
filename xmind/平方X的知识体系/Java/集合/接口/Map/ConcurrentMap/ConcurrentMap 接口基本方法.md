# ConcurrentMap<K, V> extends Map<K, V>
方法|新增|备注
-|-|-
V get(Object key);||
V put(K key, V value);||
void putAll(Map<? extends K, ? extends V> m);||
V remove(Object key);||
boolean containsKey(Object key);||
boolean containsValue(Object value);||
int size();||
boolean isEmpty();||
void clear();||
Set<K> keySet();||
Collection<V> values();||
Set<Map.Entry<K, V>> entrySet();||
boolean equals(Object o);||
int hashCode();||
V putIfAbsent(K key, V value);|√|
boolean remove(Object key, Object value);|√|
boolean replace(K key, V oldValue, V newValue);|√|
V replace(K key, V value);|√|