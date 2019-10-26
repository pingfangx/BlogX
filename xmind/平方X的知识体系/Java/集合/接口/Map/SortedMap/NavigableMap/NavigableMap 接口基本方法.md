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
Comparator<? super K> comparator();||
SortedMap<K,V> subMap(K fromKey, K toKey);||
SortedMap<K,V> headMap(K toKey);||
SortedMap<K,V> tailMap(K fromKey);||
K firstKey();||
K lastKey();||
Map.Entry<K,V> lowerEntry(K key);|√|
K lowerKey(K key);|√|
Map.Entry<K,V> floorEntry(K key);|√|
K floorKey(K key);|√|
Map.Entry<K,V> ceilingEntry(K key);|√|
K ceilingKey(K key);|√|
Map.Entry<K,V> higherEntry(K key);|√|
K higherKey(K key);|√|
Map.Entry<K,V> firstEntry();|√|
Map.Entry<K,V> lastEntry();|√|
Map.Entry<K,V> pollFirstEntry();|√|
Map.Entry<K,V> pollLastEntry();|√|
NavigableMap<K,V> descendingMap();|√|
NavigableSet<K> navigableKeySet();|√|
NavigableSet<K> descendingKeySet();|√|
SortedMap<K,V> subMap(K fromKey, K toKey);|√|
SortedMap<K,V> headMap(K toKey);|√|
SortedMap<K,V> tailMap(K fromKey);|√|
NavigableMap<K,V> subMap(K fromKey, boolean fromInclusive, K toKey,   boolean toInclusive);|√|
NavigableMap<K,V> headMap(K toKey, boolean inclusive);|√|
NavigableMap<K,V> tailMap(K fromKey, boolean inclusive);|√|