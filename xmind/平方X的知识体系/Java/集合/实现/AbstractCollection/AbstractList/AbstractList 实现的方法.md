# AbstractList<E> extends AbstractCollection<E> implements List<E>
方法|AbstractCollection|AbstractList|备注
-|-|-|-
boolean add(E e);|-|√|调用 add(size(), e);
void add(int index, E element);||-|
boolean addAll(Collection<? extends E> c);|√||迭代，调用 add
boolean addAll(int index, Collection<? extends E> c);||√|迭代，调用 add(index++, e);
E get(int index);||×|
E set(int index, E element);||-|
int indexOf(Object o);||√|向后迭代，返回 ListIterator.previousIndex
int lastIndexOf(Object o);||√|向前迭代，返回 ListIterator.nextIndex
boolean remove(Object o);|√||迭代，根据 equlas 或 null 调用 Iterator.remove
E remove(int index);||-|
boolean removeAll(Collection<?> c);|√||迭代，根据 contains 调用 Iterator.remove
boolean contains(Object o);|√||迭代，根据 equals 或 null 判断
boolean containsAll(Collection<?> c);|√||迭代，调用 contains 判断
void clear();|√|√|removeRange(0, size());
boolean retainAll(Collection<?> c);|√||迭代，根据 contains 取返判断
int size();|×||
boolean isEmpty();|√||return size() == 0;
Iterator<E> iterator();|×||
ListIterator<E> listIterator();||√|return listIterator(0);
ListIterator<E> listIterator(int index);||√|return new ListItr(index);
List<E> subList(int fromIndex, int toIndex);||√|判断 RandomAccess
Object[] toArray();|√||
<T> T[] toArray(T[] a);|√||
boolean equals(Object o);|×|√|迭代判断 null 或 equals
int hashCode();|×|√|迭代乘 32 累加

