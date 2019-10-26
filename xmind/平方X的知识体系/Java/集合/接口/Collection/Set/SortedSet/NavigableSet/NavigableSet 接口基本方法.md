# NavigableSet<E> extends SortedSet<E>
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
Comparator<? super E> comparator();||
E first();||
E last();||
SortedSet<E> headSet(E toElement);||
SortedSet<E> tailSet(E fromElement);||
SortedSet<E> subSet(E fromElement, E toElement);||
E lower(E e);|√|
E floor(E e);|√|
E ceiling(E e);|√|
E higher(E e);|√|
E pollFirst();|√|
E pollLast()|√|
Iterator<E> iterator();|√|
Iterator<E> descendingIterator();|√|
NavigableSet<E> descendingSet();|√|
SortedSet<E> headSet(E toElement);|√|
SortedSet<E> tailSet(E fromElement);|√|
SortedSet<E> subSet(E fromElement, E toElement);|√|
NavigableSet<E> headSet(E toElement, boolean inclusive);|√|
NavigableSet<E> tailSet(E fromElement, boolean inclusive);|√|
NavigableSet<E> subSet(E fromElement, boolean fromInclusive, E toElement,   boolean toInclusive);|√|