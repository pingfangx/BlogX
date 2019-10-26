# AbstractSet<E> extends AbstractCollection<E> implements Set<E>
����|ʵ��|��ע
-|-|-
boolean add(E e);|-|
boolean addAll(Collection<? extends E> c);|��|���������� add
boolean remove(Object o);|��|���������� equlas �� null ���� Iterator.remove
boolean removeAll(Collection<?> c);|�̡�|���ݴ�С������������
boolean contains(Object o);|��|���������� equals �� null �ж�
boolean containsAll(Collection<?> c);|��|���������� contains �ж�
void clear();|��|���������� Iterator.remove
boolean retainAll(Collection<?> c);|��|���������� contains ȡ���ж�
int size();|��|
boolean isEmpty();|��|return size() == 0;
Iterator<E> iterator();|��|
Object[] toArray();|��|Arrays.copyOf,Array.newInstance,System.arraycopy
<T> T[] toArray(T[] a);|��|
boolean equals(Object o);|����|�ж� Set��size Ȼ�� containsAll
int hashCode();|����|�����ۼ�