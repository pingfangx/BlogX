# AbstractQueue<E> extends AbstractCollection<E> implements Queue<E>
方法|新增|实现|备注
-|-|-|-
boolean add(E e);||--|
boolean addAll(Collection<? extends E> c);||√|迭代，调用 add
boolean remove(Object o);||√|迭代，根据 equlas 或 null 调用 Iterator.remove
boolean removeAll(Collection<?> c);||√|迭代，根据 contains 调用 Iterator.remove
boolean contains(Object o);||√|迭代，根据 equals 或 null 判断
boolean containsAll(Collection<?> c);||√|迭代，调用 contains 判断
void clear();||√√|while (poll() != null)
boolean retainAll(Collection<?> c);||√|迭代，根据 contains 取返判断
int size();||×|
boolean isEmpty();||√|return size() == 0;
Iterator<E> iterator();||×|
Object[] toArray();||√|Arrays.copyOf,Array.newInstance,System.arraycopy
<T> T[] toArray(T[] a);||√|
boolean equals(Object o);||×|
int hashCode();||×|
boolean add(E e);|√|√|调用 offer
boolean offer(E e);|√|×|
E remove();|√|√|调用 poll
E poll();|√|×|
E element();|√|√|调用 peek
E peek();|√|×|