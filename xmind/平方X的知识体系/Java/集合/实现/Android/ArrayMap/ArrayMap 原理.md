与 SparseArray 类似，持有一个 

    int[] mHashes;
    Object[] mArray;
    
添加时，计算 hash，使用二分法查找 hash 在 hash 数组中的位置。

找到则设置，没找到则添加到指定位置。