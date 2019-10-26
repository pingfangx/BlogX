# AbstractSet<E> extends AbstractCollection<E> implements Set<E>
方法|实现|备注
-|-|-
boolean add(E e);|-|
boolean addAll(Collection<? extends E> c);|√|迭代，调用 add
boolean remove(Object o);|√|迭代，根据 equlas 或 null 调用 Iterator.remove
boolean removeAll(Collection<?> c);|√√|根据大小迭代自身或参数
boolean contains(Object o);|√|迭代，根据 equals 或 null 判断
boolean containsAll(Collection<?> c);|√|迭代，调用 contains 判断
void clear();|√|迭代，调用 Iterator.remove
boolean retainAll(Collection<?> c);|√|迭代，根据 contains 取返判断
int size();|×|
boolean isEmpty();|√|return size() == 0;
Iterator<E> iterator();|×|
Object[] toArray();|√|Arrays.copyOf,Array.newInstance,System.arraycopy
<T> T[] toArray(T[] a);|√|
boolean equals(Object o);|×√|判断 Set、size 然后 containsAll
int hashCode();|×√|迭代累加