在 Tutorial 中有 Converting Between Numbers and Strings

其中提到将数字转为字符串的时候

    int i;
    // Concatenate "i" with an empty string; conversion is handled for you.
    String s1 = "" + i;

并没有说直接拼接空字符串有性能问题，
那是否会新建 StringBuilder 执行拼接呢？  
还是会编译时优化呢？

测试发现，如果是数字是字面量，与 "" 拼接时会直接被编译器优化。  
甚至包含运算也会直接计算。  
但是如果是参数，那当然是会使用 StringBuilder

    public String test1() {
        return 123 + "";
        //LDC "123"
    }

    public String test2() {
        return 123 + 456 + "";
        //LDC "579"
    }

    public String test3() {
        return 123 + "" + 456;
        //LDC "123456"
    }

    public String test4() {
        return 123 * 456 + "";
        //LDC "56088"
    }

    public String test5(Number number) {
        return number + "";
    }
    
至于

    java.lang.String#valueOf(int)
    java.lang.Integer#toString()
    都是调用
    java.lang.Integer#toString(int)
    