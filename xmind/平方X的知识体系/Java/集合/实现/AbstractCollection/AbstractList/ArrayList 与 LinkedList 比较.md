# 底层实现不同
ArrayList 由 Object[] 实现  
LinkedList 由双链表实现

同于实现的不同，使得 ArrayList 在位置访问时常量时间  
LinkedList 在添加、删除时有常量时间

# 实现的接口不同
    public class ArrayList<E> extends AbstractList<E>
        implements List<E>, RandomAccess, Cloneable, java.io.Serializable
        
    public class LinkedList<E>
    extends AbstractSequentialList<E>
    implements List<E>, Deque<E>, Cloneable, java.io.Serializable

可以看到 ArrayList 实现了 RandomAccess，所以支持常量时间的随机访问

而 LinkedList 实现了 Deque，所以它具有 Queue 和 Deque 的方法

# 时间复杂度
方法|ArrayList|备注|LinkedList|备注
-|-|-|-|-
E get(int index)|O(1)|直接从数组中取|O(n)|需要迭代
boolean add(E e)|O(1)|直接设置，但是可能需要扩容|O(1)|linklast(e)
void add(int index, E element)|O(n)|System.arraycopy|O(n)|需要迭代
void add(0, element)|O(n)|System.arraycopy|O(1)|
E remove(int index)|O(n)|System.arraycopy|O(n)?|不是也需要迭代吗，为什么很多文章说是 O(1)