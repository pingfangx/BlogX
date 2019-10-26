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
V putIfAbsent(K key, V value);||
boolean remove(Object key, Object value);||
boolean replace(K key, V oldValue, V newValue);||
V replace(K key, V value);||
ConcurrentNavigableMap<K,V> subMap(K fromKey, boolean fromInclusive, K toKey,   boolean toInclusive);|√
ConcurrentNavigableMap<K,V> headMap(K toKey, boolean inclusive);|√
ConcurrentNavigableMap<K,V> tailMap(K fromKey, boolean inclusive);|√
ConcurrentNavigableMap<K,V> subMap(K fromKey, K toKey);|√
ConcurrentNavigableMap<K,V> headMap(K toKey);|√
ConcurrentNavigableMap<K,V> tailMap(K fromKey);|√
ConcurrentNavigableMap<K,V> descendingMap();|√
public NavigableSet<K> navigableKeySet();|√
NavigableSet<K> keySet();|√
public NavigableSet<K> descendingKeySet();|√