# 相当于 java.lang.Class#isInstance
    public boolean isInstance(Object obj) {
        if (obj == null) {
            return false;
        }
        return isAssignableFrom(obj.getClass());
    }
    
    public boolean isAssignableFrom(Class<?> cls) {
        if (this == cls) {
            return true;  // Can always assign to things of the same type.
        } else if (this == Object.class) {
            return !cls.isPrimitive();  // Can assign any reference to java.lang.Object.
        } else if (isArray()) {
            return cls.isArray() && componentType.isAssignableFrom(cls.componentType);
        } else if (isInterface()) {
            // Search iftable which has a flattened and uniqued list of interfaces.
            Object[] iftable = cls.ifTable;
            if (iftable != null) {
                for (int i = 0; i < iftable.length; i += 2) {
                    if (iftable[i] == this) {
                        return true;
                    }
                }
            }
            return false;
        } else {
            if (!cls.isInterface()) {
                for (cls = cls.superClass; cls != null; cls = cls.superClass) {
                    if (cls == this) {
                        return true;
                    }
                }
            }
            return false;
        }
    }


# instanceof 不需要判断 null
> Condition 'o != null' covered by subsequent condition 'o instanceof XX'

> Or in a condition like obj != null && obj instanceof String, the null-check is redundant as instanceof operator implies non-nullity.


# null 不是任何东西的实例
因为 == null 就返回 false 了