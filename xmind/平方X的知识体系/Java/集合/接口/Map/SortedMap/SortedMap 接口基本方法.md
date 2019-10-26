# SortedMap<K,V> extends Map<K,V>
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
Comparator<? super K> comparator();|√|
SortedMap<K,V> subMap(K fromKey, K toKey);|√|
SortedMap<K,V> headMap(K toKey);|√|
SortedMap<K,V> tailMap(K fromKey);|√|
K firstKey();|√|
K lastKey();|√|