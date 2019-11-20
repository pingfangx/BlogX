
    public TextView(Context context, @Nullable AttributeSet attrs) {
        this(context, attrs, com.android.internal.R.attr.textViewStyle);
    }
    在 theme 中查找 textViewStyle
    
    
        <item name="android:textViewStyle">@style/Widget.AppCompat.TextView</item>
        
    查看 style/Widget.AppCompat.TextView
    
        <item name="textAppearance">?attr/textAppearanceSmall</item>

        <item name="textAppearance">@style/TextAppearance.Material</item>
        
    
    <style name="TextAppearance.Material">
        <item name="textColor">?attr/textColorPrimary</item>
        <item name="textColorHint">?attr/textColorHint</item>
        <item name="textColorHighlight">?attr/textColorHighlight</item>
        <item name="textColorLink">?attr/textColorLink</item>
        <item name="textSize">@dimen/text_size_body_1_material</item>
        <item name="fontFamily">@string/font_family_body_1_material</item>
        <item name="lineSpacingMultiplier">@dimen/text_line_spacing_multiplier_material</item>
    </style>

    <dimen name="text_size_body_1_material">14sp</dimen>
    
    
    验证 14 sp
    android.util.TypedValue#applyDimension
    
    public static float applyDimension(int unit, float value,
                                       DisplayMetrics metrics)
    {
        switch (unit) {
        case COMPLEX_UNIT_PX:
            return value;
        case COMPLEX_UNIT_DIP:
            return value * metrics.density;
        case COMPLEX_UNIT_SP:
            return value * metrics.scaledDensity;
        case COMPLEX_UNIT_PT:
            return value * metrics.xdpi * (1.0f/72);
        case COMPLEX_UNIT_IN:
            return value * metrics.xdpi;
        case COMPLEX_UNIT_MM:
            return value * metrics.xdpi * (1.0f/25.4f);
        }
        return 0;
    }