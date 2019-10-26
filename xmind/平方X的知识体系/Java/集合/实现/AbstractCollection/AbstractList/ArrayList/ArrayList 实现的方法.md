## ArrayList<E> extends AbstractList<E> implements List<E>, RandomAccess, Cloneable, java.io.Serializable
����|Abstract Collection|Abstract List|ArrayList|��ע
-|-|-|-|-
boolean add(E e);|-|��|��|���� elementData[size++] = e
void add(int index, E element);||-|��|System.arraycopy
boolean addAll(Collection<? extends E> c);|��||��|���������� add
boolean addAll(int index, Collection<? extends E> c);||��|��|���������� add(index++, e);
E get(int index);||��|��|rangeCheck(index); return (E) elementData[index];
E set(int index, E element);||-|��|rangeCheck(index); elementData[index] = element;
int indexOf(Object o);||��|��|���������� equlas �� null �ж�
int lastIndexOf(Object o);||��|��|��ǰ���������� equlas �� null �ж�
boolean remove(Object o);|��||��|���������� equlas �� null ���� fastRemove(index);
E remove(int index);||-|��|System.arraycopy
boolean removeAll(Collection<?> c);|��||��|return batchRemove(c, false);
boolean contains(Object o);|��||��|return indexOf(o) >= 0;
boolean containsAll(Collection<?> c);|��|||���������� contains �ж�
void clear();|��|��|��|������elementData[i] = null;
boolean retainAll(Collection<?> c);|��||��|return batchRemove(c, true);
int size();|��||��|return size;
boolean isEmpty();|��||��|return size == 0;
Iterator<E> iterator();|��||��|return new Itr();
ListIterator<E> listIterator();||��|��|return listIterator(0);
ListIterator<E> listIterator(int index);||��|��|cursor ֱ�Ӳ����ײ� elementData
List<E> subList(int fromIndex, int toIndex);||��||�ж� RandomAccess
Object[] toArray();|��|||
<T> T[] toArray(T[] a);|��|||
boolean equals(Object o);|��|��||�����ж� null �� equals
int hashCode();|��|��||������ 32 �ۼ�

