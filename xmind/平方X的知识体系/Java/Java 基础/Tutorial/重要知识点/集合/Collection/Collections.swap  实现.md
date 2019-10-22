1.4 添加的方法，这应该是为了兼容泛型之前
# java.util.Collections#swap(java.util.List<?>, int, int)
    @SuppressWarnings({"rawtypes", "unchecked"})
    public static void swap(List<?> list, int i, int j) {
        // instead of using a raw type here, it's possible to capture
        // the wildcard but it will require a call to a supplementary
        // private method
        final List l = list;
        l.set(i, l.set(j, l.get(i)));
    }