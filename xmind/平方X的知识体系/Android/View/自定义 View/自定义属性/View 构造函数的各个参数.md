# api
    View (Context context, 
                    AttributeSet attrs, 
                    int defStyleAttr, 
                    int defStyleRes)
    从 XML 执行加载，并从主题属性或样式资源应用特定于类的基样式。View 的这个构造函数允许子类在加载时使用它们自己的基样式。

    在确定特定属性的最终值时，有四个输入会起作用：

    在给定的 AttributeSet 的任何属性值。
    AttributeSet 中指定的样式资源(名为“style”)。
    由 defStyleAttr 指定的默认样式。
    由 defStyleRes 指定的默认样式。
    此主题中的基值。
    每个输入都是按顺序考虑的，第一个列出的输入优先于下面的输入。换句话说，如果在 AttributeSet 中提供了 <Button * textColor="#ff000000">，则无论在任何样式中指定了什么，按钮的文本都将 始终 是黑色的。
    


# attrs 
正在加载 view 的 XML 标记的属性。

    android.content.res.Resources.Theme#obtainStyledAttributes(android.util.AttributeSet, int[], int, int)
    通过将 attrs 和一个 int[] 调用 obtainStyledAttributes 可以获取出属性
    
# defStyleAttr
    默认 style 在 theme 中对应属性
    比如 Button 构造函数中 
    public Button(Context context, AttributeSet attrs) {
        this(context, attrs, com.android.internal.R.attr.buttonStyle);
    }
    
    这就是说，在 attrs.xml 中定义了 buttonStyle 属性
    在 sdk\platforms\android-28\data\res\values\attrs.xml 中
        <!-- Normal Button style. -->
        <attr name="buttonStyle" format="reference" />
        
    在 theme 中用 buttonStyle 指向了默认样式
    theme 一路找到 
    <style name="Base.V21.Theme.AppCompat.Light" parent="Base.V7.Theme.AppCompat.Light">
        <!-- Copy the platform default styles for the AppCompat widgets -->
        <item name="buttonStyle">?android:attr/buttonStyle</item>
    
    <style name="Base.V7.Theme.AppCompat.Light" parent="Platform.AppCompat.Light">
        <!-- Button styles -->
        <item name="buttonStyle">@style/Widget.AppCompat.Button</item>
        
    样式即为 Widget.AppCompat.Button，最后到
    
    <!-- Bordered ink button -->
    <style name="Widget.Material.Button">
        <item name="background">@drawable/btn_default_material</item>
        <item name="textAppearance">?attr/textAppearanceButton</item>
        <item name="minHeight">48dip</item>
        <item name="minWidth">88dip</item>
        <item name="stateListAnimator">@anim/button_state_list_anim_material</item>
        <item name="focusable">true</item>
        <item name="clickable">true</item>
        <item name="gravity">center_vertical|center_horizontal</item>
    </style>
    
    可以看到默认的 Button 样式设置了 minHeight minWidth clickable 等属性
    
# defStyleRes
    默认 style 资源
    第三个参数是获取默认 style 资源的属性名，如果为 0 或没有找到，则使用该参数