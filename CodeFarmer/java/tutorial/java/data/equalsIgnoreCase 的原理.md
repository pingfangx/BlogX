# 首先看 java.lang.String#equals

    
    public boolean equals(Object anObject) {
        //同一对象
        if (this == anObject) {
            return true;
        }
        if (anObject instanceof String) {
            String anotherString = (String)anObject;
            int n = value.length;
            //判断长度
            if (n == anotherString.value.length) {
                //取值
                char v1[] = value;
                char v2[] = anotherString.value;
                int i = 0;
                while (n-- != 0) {
                    //依次比较
                    if (v1[i] != v2[i])
                        return false;
                    i++;
                }
                return true;
            }
        }
        return false;
    }
    
    
    
    public boolean equalsIgnoreCase(String anotherString) {
        return (this == anotherString) ? true
                : (anotherString != null)
                && (anotherString.value.length == value.length)
                && regionMatches(true, 0, anotherString, 0, value.length);
    }
    
    
    java.lang.String#regionMatches(boolean, int, java.lang.String, int, int)
    public boolean regionMatches(boolean ignoreCase, int toffset,
            String other, int ooffset, int len) {
        char ta[] = value;
        int to = toffset;
        char pa[] = other.value;
        int po = ooffset;
        // Note: toffset, ooffset, or len might be near -1>>>1.
        if ((ooffset < 0) || (toffset < 0)
                || (toffset > (long)value.length - len)
                || (ooffset > (long)other.value.length - len)) {
            return false;
        }
        while (len-- > 0) {
            char c1 = ta[to++];
            char c2 = pa[po++];
            if (c1 == c2) {
                //相等，继续比较
                continue;
            }
            if (ignoreCase) {
                // If characters don't match but case may be ignored,
                // try converting both characters to uppercase.
                // If the results match, then the comparison scan should
                // continue.
                //转为大写
                char u1 = Character.toUpperCase(c1);
                char u2 = Character.toUpperCase(c2);
                if (u1 == u2) {
                    continue;
                }
                // Unfortunately, conversion to uppercase does not work properly
                // for the Georgian alphabet, which has strange rules about case
                // conversion.  So we need to make one last check before
                // exiting.
                if (Character.toLowerCase(u1) == Character.toLowerCase(u2)) {
                    continue;
                }
            }
            //不相等，返回 false
            return false;
        }
        return true;
    }
    
# java.lang.String.CaseInsensitiveComparator#compare

        public int compare(String s1, String s2) {
            int n1 = s1.length();
            int n2 = s2.length();
            int min = Math.min(n1, n2);
            for (int i = 0; i < min; i++) {
                char c1 = s1.charAt(i);
                char c2 = s2.charAt(i);
                if (c1 != c2) {
                    c1 = Character.toUpperCase(c1);
                    c2 = Character.toUpperCase(c2);
                    if (c1 != c2) {
                        c1 = Character.toLowerCase(c1);
                        c2 = Character.toLowerCase(c2);
                        if (c1 != c2) {
                            // No overflow because of numeric promotion
                            return c1 - c2;
                        }
                    }
                }
            }
            return n1 - n2;
        }
        
# 格鲁吉亚字母
文档说 格鲁吉亚字母 有例外，写了测试却发现并没有。

    73 与 304，即 I,İ,小写相等 i,i，但是大写不相等I,İ 
    75 与 8490，即 K,K,小写相等 k,k，但是大写不相等K,K 
    105 与 304，即 i,İ,小写相等 i,i，但是大写不相等I,İ 
    107 与 8490，即 k,K,小写相等 k,k，但是大写不相等K,K 
    197 与 8491，即 Å,Å,小写相等 å,å，但是大写不相等Å,Å 
    223 与 7838，即 ß,ẞ,小写相等 ß,ß，但是大写不相等ß,ẞ 
    229 与 8491，即 å,Å,小写相等 å,å，但是大写不相等Å,Å 
    920 与 1012，即 Θ,ϴ,小写相等 θ,θ，但是大写不相等Θ,ϴ 
    937 与 8486，即 Ω,Ω,小写相等 ω,ω，但是大写不相等Ω,Ω 
    952 与 1012，即 θ,ϴ,小写相等 θ,θ，但是大写不相等Θ,ϴ 
    969 与 8486，即 ω,Ω,小写相等 ω,ω，但是大写不相等Ω,Ω 