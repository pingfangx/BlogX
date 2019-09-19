一般在 attrs.xml 中声明  
aapt 处理后，在 R 文件中可以看到

    declare-styleable 中声明的各属性生成一个数组  
    同时生成各属性的 index
    
有一个 bug 是由

        classpath 'com.android.tools.build:gradle:2.3.3'
        
升级为

        classpath 'com.android.tools.build:gradle:3.1.2'
        
然后无法解析自定义的属性了，进行排查

# obtainStyledAttributes
    android.content.Context#obtainStyledAttributes(android.util.AttributeSet, int[])
    android.content.res.Resources.Theme#obtainStyledAttributes(android.util.AttributeSet, int[], int, int)
    
    Return a TypedArray holding the attribute values in set that are listed in attrs.
    第二个参数
    attrs int: The desired attributes to be retrieved.
    
经测试发现
# 参数 int[] attrs 中元素顺序影响获取结果

    private void init(Context context, AttributeSet set) {
        //一般的获取方法
        int[] attrs1 = R.styleable.CustomView;
        TypedArray array1 = context.obtainStyledAttributes(set, attrs1);
        Log.d(TAG, Arrays.toString(attrs1));
        for (int i = 0; i < array1.length(); i++) {
            Log.d(TAG, i + "," + array1.getResourceId(i, 0));
        }
        array1.recycle();

        //自定义要获取的属性
        /*
        styleable 本身是一个数组，因此我们也可以手动指定，可以指定只获取其中几个属性
        但是要注意的是，我们必须按顺序指定，如果顺序正确，即使缺少某个属性也能正确获取
        比如完整的顺序为

                R.attr.customColor,
                R.attr.customColor2,
                R.attr.customText,
         那么
                R.attr.customColor,
                R.attr.customColor2,

                R.attr.customColor,
                R.attr.customText,

                R.attr.customColor2,
                R.attr.customText,
         等都可以正常获取
         但是

                R.attr.customColor,
                R.attr.customText,
                R.attr.customColor2,
                只能获取到 customColor

                R.attr.customColor2,
                R.attr.customColor,
                R.attr.customText,
                只能获取到 customColor2

                R.attr.customText,
                R.attr.customColor,
                R.attr.customColor2,
                一个都不能获取到

        具体的获取原因，可能与 native 层的实现有关，没有在继续查看
         */
        int[] attrs2 = new int[]{
                R.attr.customColor2,
                R.attr.customColor,
                R.attr.customText,
        };
        TypedArray array2 = context.obtainStyledAttributes(set, attrs2);
        Log.d(TAG, Arrays.toString(attrs2));
        for (int i = 0; i < array2.length(); i++) {
            Log.d(TAG, i + "," + array2.getResourceId(i, 0));
        }
        array2.recycle();
    }
    
# 不同版本的 com.android.tools.build:gradle 影响生成顺序

    同样是
    
    <declare-styleable name="CustomView">
        <attr name="customText" format="string" />
        <attr name="customColor" format="reference" />
        <attr name="customColor2" format="reference" />
    </declare-styleable>
    
    com.android.tools.build:gradle:2.3.3
    是按在 xml 中的顺序分配 index 的
    
    虽然在 R 文件中是按字母顺序排列各字段，但其实是 xml 中的顺序
    
        public static final int customColor=0x7f0100f6;
        public static final int customColor2=0x7f0100f7;
        public static final int customText=0x7f0100f5;
        public static final int[] CustomView = {
            0x7f0100f5, 0x7f0100f6, 0x7f0100f7
        };
        public static final int CustomView_customColor = 1;
        public static final int CustomView_customColor2 = 2;
        public static final int CustomView_customText = 0;
        
    com.android.tools.build:gradle:3.2.1
    则是完全按字母顺序排列的
    //两层缩进也从 8 个空格变为了 4 个
    public static final int customColor=0x7f020065;
    public static final int customColor2=0x7f020066;
    //系统多出来的
    public static final int customNavigationLayout=0x7f020067;
    public static final int customText=0x7f020068;
    
    public static final int[] CustomView={
      0x7f020065, 0x7f020066, 0x7f020068
    };
    public static final int CustomView_customColor=0;
    public static final int CustomView_customColor2=1;
    public static final int CustomView_customText=2;
    
因此，此 bug 是因为原来的代码中，手动指定了 attrs   
但是更新 gradle 插件后，不是按 xml 中的顺序排列的 index  
错误的 index 顺序影响了获取结果，导致获取自定义属性失败