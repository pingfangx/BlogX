# AbstractList<E> extends AbstractCollection<E> implements List<E>
����|AbstractCollection|AbstractList|��ע
-|-|-|-
boolean add(E e);|-|��|���� add(size(), e);
void add(int index, E element);||-|
boolean addAll(Collection<? extends E> c);|��||���������� add
boolean addAll(int index, Collection<? extends E> c);||��|���������� add(index++, e);
E get(int index);||��|
E set(int index, E element);||-|
int indexOf(Object o);||��|������������ ListIterator.previousIndex
int lastIndexOf(Object o);||��|��ǰ���������� ListIterator.nextIndex
boolean remove(Object o);|��||���������� equlas �� null ���� Iterator.remove
E remove(int index);||-|
boolean removeAll(Collection<?> c);|��||���������� contains ���� Iterator.remove
boolean contains(Object o);|��||���������� equals �� null �ж�
boolean containsAll(Collection<?> c);|��||���������� contains �ж�
void clear();|��|��|removeRange(0, size());
boolean retainAll(Collection<?> c);|��||���������� contains ȡ���ж�
int size();|��||
boolean isEmpty();|��||return size() == 0;
Iterator<E> iterator();|��||
ListIterator<E> listIterator();||��|return listIterator(0);
ListIterator<E> listIterator(int index);||��|return new ListItr(index);
List<E> subList(int fromIndex, int toIndex);||��|�ж� RandomAccess
Object[] toArray();|��||
<T> T[] toArray(T[] a);|��||
boolean equals(Object o);|��|��|�����ж� null �� equals
int hashCode();|��|��|������ 32 �ۼ�

