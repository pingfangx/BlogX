# 方法表
方法|返回值|备注
-|-|-
V get(Object key);||
V put(K key, V value);|以前与 `key` 关联的值，如果没有针对 `key` 的映射关系，则返回 `null`。|
void putAll(Map<? extends K, ? extends V> m);||
V remove(Object key);|以前与 `key` 关联的值；如果没有 `key` 的映射关系，则返回 `null`。|
boolean containsKey(Object key);||
boolean containsValue(Object value);||
int size();||
boolean isEmpty();||
void clear();||
Set<K> keySet();||
Collection<V> values();||
Set<Map.Entry<K, V>> entrySet();||
boolean equals(Object o);|
int hashCode();|