# java.util.Collections#sort(java.util.List<T>)
    public static <T extends Comparable<? super T>> void sort(List<T> list) {
        list.sort(null);
    }
# java.util.List#sort

    default void sort(Comparator<? super E> c) {
        Object[] a = this.toArray();
        Arrays.sort(a, (Comparator) c);
        ListIterator<E> i = this.listIterator();
        for (Object e : a) {
            i.next();
            i.set((E) e);
        }
    }
    java.util.ArrayList#sort
    
    public void sort(Comparator<? super E> c) {
        final int expectedModCount = modCount;
        Arrays.sort((E[]) elementData, 0, size, c);
        if (modCount != expectedModCount) {
            throw new ConcurrentModificationException();
        }
        modCount++;
    }
    
# java.util.Arrays#sort
可以看到由 Collections#sort 转到 List#sort，最后都转到 Arrays#sort  
Arrays 中共有 18 个 sort 的重载方法，其中 7 种基本类型，加 Object 加泛型，共 9 种  
每种类型都提供指定 left right 的方法，应此共 18 个。

## 基本类型数组
java.util.DualPivotQuicksort#sort


## Object[]
    public static void sort(Object[] a, int fromIndex, int toIndex) {
        rangeCheck(a.length, fromIndex, toIndex);
        if (LegacyMergeSort.userRequested)
            legacyMergeSort(a, fromIndex, toIndex);
        else
            ComparableTimSort.sort(a, fromIndex, toIndex, null, 0, 0);
    }

## T[]
    public static <T> void sort(T[] a, int fromIndex, int toIndex,
                                Comparator<? super T> c) {
        if (c == null) {
            sort(a, fromIndex, toIndex);
        } else {
            rangeCheck(a.length, fromIndex, toIndex);
            if (LegacyMergeSort.userRequested)
                legacyMergeSort(a, fromIndex, toIndex, c);
            else
                TimSort.sort(a, fromIndex, toIndex, c, null, 0, 0);
        }
    }
    
    
  
