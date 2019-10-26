# SortedSet<E> extends Set<E>
方法|新增|备注
-|-|-
boolean add(E e);||
boolean addAll(Collection<? extends E> c);||
boolean remove(Object o);||
boolean removeAll(Collection<?> c);||
boolean contains(Object o);||
boolean containsAll(Collection<?> c);||
void clear();||
boolean retainAll(Collection<?> c);||
int size();||
boolean isEmpty();||
Iterator<E> iterator();||
Object[] toArray();||
<T> T[] toArray(T[] a);||
boolean equals(Object o);||大小相同且包含所有成员
int hashCode();||
Comparator<? super E> comparator();|√|
E first();|√|
E last();|√|
SortedSet<E> headSet(E toElement);|√|
SortedSet<E> tailSet(E fromElement);|√|
SortedSet<E> subSet(E fromElement, E toElement);|√|