# BlockingQueue<E> extends Queue<E>
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
boolean equals(Object o);||
int hashCode();||
boolean add(E e);||抛出异常
boolean offer(E e);||如果该元素已添加到此队列，则返回 true；否则返回 false
E remove();||抛出异常
E poll();||队列的头，如果此队列为空，则返回 null
E element();||抛出异常
E peek();||此队列的头；如果此队列为空，则返回 null
void put(E e) throws InterruptedException;|√|
E take() throws InterruptedException;|√|
boolean offer(E e, long timeout, TimeUnit unit) throws InterruptedException;|√|
E poll(long timeout, TimeUnit unit) throws InterruptedException;|√|
int remainingCapacity();|√|
int drainTo(Collection<? super E> c);|√|
int drainTo(Collection<? super E> c, int maxElements);|√|