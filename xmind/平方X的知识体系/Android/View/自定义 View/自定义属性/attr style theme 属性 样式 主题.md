R:
* [样式和主题  |  Android Developers](https://developer.android.com/guide/topics/ui/themes.html?hl=zh-cn#ApplyingStyles)
* [Attr、Style和Theme详解 - 简书](https://www.jianshu.com/p/dd79220b47dd)
# attr 属性
可以为 View 设置的单个属性。

比如自定义 view 时，可以用 declare-styleable 指定一组属性，里面的每个 attr 项就是可以为自定义 View 设置的属性


# style 样式
style 也是一个属性，style 指向一个 style 元素，包含一组属性集合。
> 样式是指为 View 或窗口指定外观和格式的属性集合。样式可以指定高度、填充、字体颜色、字号、背景色等许多属性。 样式是在与指定布局的 XML 不同的 XML 资源中进行定义。

> Android 中的样式与网页设计中层叠样式表的原理类似 — 您可以通过它将设计与内容分离。

# theme 主题
主题也是一个 style 元素，但包含的属性不同。可以通过 android:theme 指定给 Application 或 Activity
theme 中可能包含某些 View 的默认 style