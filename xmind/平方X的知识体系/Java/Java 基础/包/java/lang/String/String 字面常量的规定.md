JLS 3.10.5

* 编译时计算得到的字符串，当作字面常量对待
* 运行时通过连接运算得到的字符串是新创建的，因此会区分对待
* 通过显式地限定运算（intern）复到的字符串，得到的结果与任何之前存在的具有相同内容的字面常量字符串是相同的字符串


# 为什么连接运算得到的字符串是新创建的？
因为 java.lang.StringBuilder#toString

    public String toString() {
        // Create a copy, don't share the array
        return new String(value, 0, count);
    }
