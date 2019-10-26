# List<E> extends Collection<E>
方法|新增|备注
-|-|-
boolean add(E e);||
void add(int index, E element);|√|
boolean addAll(Collection<? extends E> c);||
boolean addAll(int index, Collection<? extends E> c);|√|
E get(int index);|√|
E set(int index, E element);|√|
int indexOf(Object o);|√|
int lastIndexOf(Object o);|√|
boolean remove(Object o);||
E remove(int index);|√|
boolean removeAll(Collection<?> c);||
boolean contains(Object o);||
boolean containsAll(Collection<?> c);||
void clear();||
boolean retainAll(Collection<?> c);||
int size();||
boolean isEmpty();||
Iterator<E> iterator();||
ListIterator<E> listIterator();|√|
ListIterator<E> listIterator(int index);|√|
List<E> subList(int fromIndex, int toIndex);|√|
Object[] toArray();||
<T> T[] toArray(T[] a);||
boolean equals(Object o);||
int hashCode();||