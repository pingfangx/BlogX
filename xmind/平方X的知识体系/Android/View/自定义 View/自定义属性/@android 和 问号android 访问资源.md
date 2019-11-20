[访问资源  |  Android Developers](https://developer.android.com/guide/topics/resources/accessing-resources.html#ResourcesFromXml)


# 在 XML 中访问资源
    @[<package_name>:]<resource_type>/<resource_name>
    <package_name> 是资源所在包的名称（如果引用的资源来自相同的包，则不需要）
    所以为什么有 
    
# 引用样式属性
> 要引用样式属性，名称语法几乎与普通资源格式完全相同，只不过将 at 符号 (@) 改为问号 (?)，资源类型部分为可选项。 例如：

    ?[<package_name>:][<resource_type>/]<resource_name>
    
> 在以上代码中，android:textColor 属性指定当前风格主题中某个样式属性的名称。Android 现在会使用应用于 android:textColorSecondary 样式属性的值作为 android:textColor 在这个小部件中的值。由于系统资源工具知道此环境中肯定存在某个属性资源，因此您无需显式声明类型（类型应为 ?android:attr/textColorSecondary）— 您可以将 attr 类型排除在外。