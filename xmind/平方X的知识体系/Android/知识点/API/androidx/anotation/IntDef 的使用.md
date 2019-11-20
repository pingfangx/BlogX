注解，类似于枚举的作用，限制所注解的参数、返回值等应该是它的 value 指明的常量。

# 参照

    @IntDef({VISIBLE, INVISIBLE, GONE})
    @Retention(RetentionPolicy.SOURCE)
    public @interface Visibility {}
    
    public void setVisibility(@Visibility int visibility) {
        setFlags(visibility, VISIBILITY_MASK);
    }
# 定义
标准注解的定义

    /**
     * IntDef 注解
     * 在 test 中不会提示警告，所以放在源码中
     *
     * @author pingfangx
     * @date 2019/10/27
     */
    public class IntDefTest {
        private static final int TYPE_A = 0;
        private static final int TYPE_B = 1;
        private static final int FLAG_A = 1;
        private static final int FLAG_B = 2;

        @Type
        private int mType;
        @Flag
        private int mFlag;

        @IntDef(value = {TYPE_A, TYPE_B})
        @Retention(RetentionPolicy.SOURCE)//只需保留在源码中，用于编译检查
        public @interface Type {}

        @IntDef(value = {FLAG_A, FLAG_B}, flag = true)
        @Retention(RetentionPolicy.SOURCE)
        public @interface Flag {}

        public void setType(@Type int type) {
            mType = type;
        }

        @Type
        public int getType() {return mType;}

        public void setFlag(@Flag int flag) {
            mFlag = flag;
        }

        @Flag
        public int getFlag() {return mFlag;}

        public void test() {
            //直接数字会警告
            setFlag(22);
            setType(22);

            setType(TYPE_A);
            setType(TYPE_B);
            //未设置 falg = true
            setType(TYPE_A | TYPE_B);
            setType(FLAG_A);
            setType(FLAG_B);

            //可以看到如果值为 0 不会警告
            setFlag(TYPE_A);
            //非 0 会警告，即使值在定义内
            setFlag(TYPE_B);
            //正常使用
            setFlag(FLAG_A);
            setFlag(FLAG_B);
            //标记为 flag 可以设置多个
            setFlag(FLAG_A | FLAG_B);
        }
    }
