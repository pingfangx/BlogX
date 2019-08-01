java.util.Arrays#sort(int[], int, int)
  
> Implementation note: The sorting algorithm is a Dual-Pivot Quicksort by Vladimir Yaroslavskiy, Jon Bentley, and Joshua Bloch. This algorithm offers O(n log(n)) performance on many data sets that cause other quicksorts to degrade to quadratic performance, and is typically faster than traditional (one-pivot) Quicksort implementations.
# java.util.DualPivotQuicksort#sort(int[], int, int, int[], int, int)
    小于 286
        是：小于 47？
            是：插入排序
            否：双轴快速排序
        否：结构性好不好？
            是：归并排序
            否：双轴快速排序