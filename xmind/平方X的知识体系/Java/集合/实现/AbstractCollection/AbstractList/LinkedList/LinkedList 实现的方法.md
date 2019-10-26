## LinkedList
    public class LinkedList<E>
    extends AbstractSequentialList<E>
    implements List<E>, Deque<E>, Cloneable, java.io.Serializable

方法|Abstract Collection|Abstract List|Abstract Sequential List|Linked List|备注
-|-|-|-|-|-
boolean add(E e);|-|√||√|linkLast(e);
void add(int index, E element);||-|√|√|linkLast(element); linkBefore(element, node(index));
boolean addAll(Collection<? extends E> c);|√|||√|return addAll(size, c);
boolean addAll(int index, Collection<? extends E> c);||√|√|√|
E get(int index);||×|√|√|return node(index).item;
E set(int index, E element);||-|√|√|
int indexOf(Object o);||√||√|first 向后迭代
int lastIndexOf(Object o);||√||√|last 向前迭代
boolean remove(Object o);|√|||√|unlink(x);
E remove(int index);||-|√|√|return unlink(node(index));
boolean removeAll(Collection<?> c);|√||||
boolean contains(Object o);|√|||√|return indexOf(o) != -1;
boolean containsAll(Collection<?> c);|√||||
void clear();|√|√||√|迭代置为 null
boolean retainAll(Collection<?> c);|√||||
int size();|×|||√|return size;
boolean isEmpty();|√||||
Iterator<E> iterator();|×||||
ListIterator<E> listIterator();||√|||
ListIterator<E> listIterator(int index);||√||√|
List<E> subList(int fromIndex, int toIndex);||√|||
Object[] toArray();|√||||
<T> T[] toArray(T[] a);|√||||
boolean equals(Object o);|×|√|||
int hashCode();|×|√|||
void linkFirst(E e)||||√|new Node<>(null, e, f); 加首部处理
void linkLast(E e)||||√|new Node<>(l, e, null); 加尾部处理
void linkBefore(E e, Node<E> succ)||||√|
E unlinkFirst(Node<E> f)||||√|
E unlinkLast(Node<E> l)||||√|
E unlink(Node<E> x)||||√|
E getFirst()||||√|
E getLast()||||√|
E removeFirst()||||√|return unlinkFirst(f);
E removeLast()||||√|return unlinkLast(l);
void addFirst(E e)||||√|linkFirst(e);
void addLast(E e)||||√|linkLast(e);
E peek()||||√|return (f == null) ? null : f.item;
E element()||||√|return getFirst();
E poll()||||√|return (f == null) ? null : unlinkFirst(f);
E remove()||||√|return removeFirst();
boolean offer(E e)||||√|return add(e);
boolean offerFirst(E e)||||√|addFirst(e);
boolean offerLast(E e)||||√|addLast(e);
E peekFirst()||||√|return (f == null) ? null : f.item;
E peekLast()||||√|return (l == null) ? null : l.item;
E pollFirst()||||√|return (f == null) ? null : unlinkFirst(f);
E pollLast()||||√|return (l == null) ? null : unlinkLast(l);
void push(E e)||||√|addFirst(e);
E pop()||||√|return removeFirst();
boolean removeFirstOccurrence(Object o)||||√|return remove(o);
boolean removeLastOccurrence(Object o)||||√|last 向前迭代，调用 unlink(x)
