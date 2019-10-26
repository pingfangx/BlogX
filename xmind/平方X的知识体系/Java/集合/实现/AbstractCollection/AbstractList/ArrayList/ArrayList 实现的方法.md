## ArrayList<E> extends AbstractList<E> implements List<E>, RandomAccess, Cloneable, java.io.Serializable
方法|Abstract Collection|Abstract List|ArrayList|备注
-|-|-|-|-
boolean add(E e);|-|√|√|扩容 elementData[size++] = e
void add(int index, E element);||-|√|System.arraycopy
boolean addAll(Collection<? extends E> c);|√||√|迭代，调用 add
boolean addAll(int index, Collection<? extends E> c);||√|√|迭代，调用 add(index++, e);
E get(int index);||×|√|rangeCheck(index); return (E) elementData[index];
E set(int index, E element);||-|√|rangeCheck(index); elementData[index] = element;
int indexOf(Object o);||√|√|迭代，根据 equlas 或 null 判断
int lastIndexOf(Object o);||√|√|向前迭代，根据 equlas 或 null 判断
boolean remove(Object o);|√||√|迭代，根据 equlas 或 null 调用 fastRemove(index);
E remove(int index);||-|√|System.arraycopy
boolean removeAll(Collection<?> c);|√||√|return batchRemove(c, false);
boolean contains(Object o);|√||√|return indexOf(o) >= 0;
boolean containsAll(Collection<?> c);|√|||迭代，调用 contains 判断
void clear();|√|√|√|迭代，elementData[i] = null;
boolean retainAll(Collection<?> c);|√||√|return batchRemove(c, true);
int size();|×||√|return size;
boolean isEmpty();|√||√|return size == 0;
Iterator<E> iterator();|×||√|return new Itr();
ListIterator<E> listIterator();||√|√|return listIterator(0);
ListIterator<E> listIterator(int index);||√|√|cursor 直接操作底层 elementData
List<E> subList(int fromIndex, int toIndex);||√||判断 RandomAccess
Object[] toArray();|√|||
<T> T[] toArray(T[] a);|√|||
boolean equals(Object o);|×|√||迭代判断 null 或 equals
int hashCode();|×|√||迭代乘 32 累加

