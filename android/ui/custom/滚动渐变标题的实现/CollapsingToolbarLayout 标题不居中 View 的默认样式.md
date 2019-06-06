发现有属性

    collapsedTitleGravity

但是设置后仍然不居中，有点偏右

尝试
    
    app:contentInsetLeft="0dp"
    
但是仍然失效，搜索

[Collapsing Toolbar title not centered](https://stackoverflow.com/questions/51910013)

Mohamed Mohaideen AH 的回答
> Try app:contentInsetLeft="0dp" & app:contentInsetStart="0dp" adding this property to toolbar & if not works as well add this porperty also app:contentInsetStartWithNavigation="0dp".. Hope it helps.

发现要设置 app:contentInsetStart="0dp" 才生效。


# 查看源码

    androidx.appcompat.widget.Toolbar#Toolbar(android.content.Context, android.util.AttributeSet, int)
        final int contentInsetStart =
                a.getDimensionPixelOffset(R.styleable.Toolbar_contentInsetStart,
                        RtlSpacingHelper.UNDEFINED);
        final int contentInsetEnd =
                a.getDimensionPixelOffset(R.styleable.Toolbar_contentInsetEnd,
                        RtlSpacingHelper.UNDEFINED);
        final int contentInsetLeft =
                a.getDimensionPixelSize(R.styleable.Toolbar_contentInsetLeft, 0);
        final int contentInsetRight =
                a.getDimensionPixelSize(R.styleable.Toolbar_contentInsetRight, 0);

        ensureContentInsets();
        mContentInsets.setAbsolute(contentInsetLeft, contentInsetRight);

        if (contentInsetStart != RtlSpacingHelper.UNDEFINED ||
                contentInsetEnd != RtlSpacingHelper.UNDEFINED) {
            mContentInsets.setRelative(contentInsetStart, contentInsetEnd);
        }
        
        虽然设置了 contentInsetLeft 为 0，但是 contentInsetStart 有值。
        其值由 R.attr.toolbarStyle 指定
        
        
    public Toolbar(Context context, @Nullable AttributeSet attrs) {
        this(context, attrs, R.attr.toolbarStyle);
    }
# contentInsetStart 值由何处指定
    R.attr.toolbarStyle
    由 theme 指定
    
    <style name="AppTheme" parent="Base.Theme.AppCompat.Light.DarkActionBar">
    
    <style name="Base.Theme.AppCompat.Light.DarkActionBar" parent="Base.Theme.AppCompat.Light">
    
    <style name="Base.Theme.AppCompat.Light" parent="Base.V7.Theme.AppCompat.Light">
    
    <style name="Base.V7.Theme.AppCompat.Light" parent="Platform.AppCompat.Light">
        <!-- Toolbar styles -->
        <item name="toolbarStyle">@style/Widget.AppCompat.Toolbar</item>
        
    继续
    
    <style name="Widget.AppCompat.Toolbar" parent="Base.Widget.AppCompat.Toolbar"/>
    <style name="Base.Widget.AppCompat.Toolbar" parent="Base.V7.Widget.AppCompat.Toolbar"/>
    <style name="Base.V7.Widget.AppCompat.Toolbar" parent="android:Widget">
    
        <item name="contentInsetStart">16dp</item>