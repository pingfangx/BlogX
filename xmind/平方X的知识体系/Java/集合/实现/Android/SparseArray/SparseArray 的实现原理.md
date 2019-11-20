# Sparse
 [spɑːs] 稀疏的
# 简述
## SparseArray 内部用一个 int[] 保存 key，用 Object[] 保存值

    private int[] mKeys;
    private Object[] mValues;
    private int mSize;
    
## SparseArray 虽然名为 Array，但是实现的是类似 Map 的功能
且没有实现任何集合接口，其父类是 Object
    public class SparseArray<E> implements Cloneable
    
## 如何存储数据
用 int 作为键，键在 mKeys 中通过二分查找确定一个位置，然后该位置对应 mValues 中的值

## 优点
时间换空间

# 相关方法
## put

    public void put(int key, E value) {
        int i = ContainerHelpers.binarySearch(mKeys, mSize, key);

        if (i >= 0) {
            mValues[i] = value;
        } else {
            i = ~i;

            if (i < mSize && mValues[i] == DELETED) {
                mKeys[i] = key;
                mValues[i] = value;
                return;
            }

            if (mGarbage && mSize >= mKeys.length) {
                gc();

                // Search again because indices may have changed.
                i = ~ContainerHelpers.binarySearch(mKeys, mSize, key);
            }

            mKeys = GrowingArrayUtils.insert(mKeys, mSize, i, key);
            mValues = GrowingArrayUtils.insert(mValues, mSize, i, value);
            mSize++;
        }
    }
    
## get
    public E get(int key, E valueIfKeyNotFound) {
        int i = ContainerHelpers.binarySearch(mKeys, mSize, key);

        if (i < 0 || mValues[i] == DELETED) {
            return valueIfKeyNotFound;
        } else {
            return (E) mValues[i];
        }
    }
    
## 初始化容量

    public SparseArray() {
        this(10);
    }
    public SparseArray(int initialCapacity) {
        if (initialCapacity == 0) {
            mKeys = EmptyArray.INT;
            mValues = EmptyArray.OBJECT;
        } else {
            mValues = ArrayUtils.newUnpaddedObjectArray(initialCapacity);
            mKeys = new int[mValues.length];
        }
        mSize = 0;
    }
    public static Object[] newUnpaddedObjectArray(int minLen) {
        return (Object[])VMRuntime.getRuntime().newUnpaddedArray(Object.class, minLen);
    }
    这里创建的数组的大小为 minLen + 1，为什么 + 1 不太清楚
## 扩容
    com.android.internal.util.GrowingArrayUtils#insert(int[], int, int, int)
    
    public static int[] insert(int[] array, int currentSize, int index, int element) {
        assert currentSize <= array.length;

        if (currentSize + 1 <= array.length) {
            System.arraycopy(array, index, array, index + 1, currentSize - index);
            array[index] = element;
            return array;
        }

        int[] newArray = ArrayUtils.newUnpaddedIntArray(growSize(currentSize));
        System.arraycopy(array, 0, newArray, 0, index);
        newArray[index] = element;
        System.arraycopy(array, index, newArray, index + 1, array.length - index);
        return newArray;
    }
    com.android.internal.util.GrowingArrayUtils#growSize
    
    public static int growSize(int currentSize) {
        return currentSize <= 4 ? 8 : currentSize * 2;
    }
    
## 二分查找的结果处理

    static int binarySearch(int[] array, int size, int value) {
        int lo = 0;
        int hi = size - 1;

        while (lo <= hi) {
            final int mid = (lo + hi) >>> 1;
            final int midVal = array[mid];

            if (midVal < value) {
                lo = mid + 1;
            } else if (midVal > value) {
                hi = mid - 1;
            } else {
                return mid;  // value found
            }
        }
        return ~lo;  // value not present
    }
    如果未找到，则取反（成为负数，用于调用方判断）
    调用方再取反，作为插入位置
    