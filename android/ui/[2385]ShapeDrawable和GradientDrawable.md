[md]

>本文由平方X发表于平方X网，转载请注明出处。[http://blog.pingfangx.com/2385.html](http://blog.pingfangx.com/2385.html)

# 0x00 前言
之前在项目中封装了一个ShapeDrawable，其中可以设置fill 或 stroke，  
通过RoundRectShape，
```
RoundRectShape(float[] outerRadii, RectF inset,float[] innerRadii) 
```
通过 outerRadii 设置圆角，inset 传宽度完成 stroke，传 null 实现 fill 。  
有一天同事发现无法既设置描边的颜色，又设置填充的颜色。  
查了一下发现[Kilnn.《Android Drawable Resource学习（十二）、ShapeDrawable还是GradientDrawable？》](http://blog.csdn.net/lonelyroamer/article/details/8254592)  

本文想了解，
* 它们有什么不同
* drawable 文件是如何加载的
* ShapeDrawable 的目的是什么

# 0x01 ShapeDrawable 和 GradientDrawable的异同
## 1.1 ShapeDrawable
[ShapeDrawable](https://developer.android.google.cn/reference/android/graphics/drawable/ShapeDrawable.html)

[Canvas and Drawables #Shape drawables](https://developer.android.google.cn/guide/topics/graphics/2d-graphics.html#shape-drawable)

[Drawable Resources](https://developer.android.google.cn/guide/topics/resources/drawable-resource.html#Shape)

我们可以简单了解到，ShapeDrawable可用于画平面图形，它持有一个 [Shape](https://developer.android.google.cn/reference/android/graphics/drawable/shapes/Shape.html) 对象。
它的android.graphics.drawable.ShapeDrawable#draw方法是调用的  
android.graphics.drawable.shapes.Shape#draw  
我们通过给其设置不同的Shape可以绘制不同的形状，而通过设置Paint可以控制颜色等。
```
            if (state.mShape != null) {
                // need the save both for the translate, and for the (unknown)
                // Shape
                final int count = canvas.save();
                canvas.translate(r.left, r.top);
                onDraw(state.mShape, canvas, paint);
                canvas.restoreToCount(count);
            } else {
                //这里可以解释不指定Shape时默认是矩形
                canvas.drawRect(r, paint);
            }
```

## 1.2 GradientDrawable
[GradientDrawable](https://developer.android.google.cn/reference/android/graphics/drawable/GradientDrawable.html)
可以用于颜色渐变，各种形状等。  
Gradient有一Shape，但是它的Shape是以下之一。
`RECTANGLE, OVAL, LINE, RING`  
它虽然也可以不同的形状，但和ShapeDrawable不同，它是使用cavas的不同的方法绘制
```
android.graphics.Canvas#drawRoundRect(android.graphics.RectF, float, float, android.graphics.Paint)
android.graphics.Canvas#drawOval(android.graphics.RectF, android.graphics.Paint)
android.graphics.Canvas#drawLine
android.graphics.Canvas#drawPath
```

### 1.2.1 虚线是怎么实现的
```
android.graphics.drawable.GradientDrawable#inflate
android.graphics.drawable.GradientDrawable#inflateChildElements
android.graphics.drawable.GradientDrawable#updateGradientDrawableStroke
android.graphics.drawable.GradientDrawable#setStroke(int, android.content.res.ColorStateList, float, float)
android.graphics.drawable.GradientDrawable#setStrokeInternal

        DashPathEffect e = null;
        if (dashWidth > 0) {
            e = new DashPathEffect(new float[] { dashWidth, dashGap }, 0);
        }
        mStrokePaint.setPathEffect(e);
        
/**
 * PathEffect is the base class for objects in the Paint that affect
 * the geometry of a drawing primitive before it is transformed by the
 * canvas' matrix and drawn.
 */
public class PathEffect {

    protected void finalize() throws Throwable {
        nativeDestructor(native_instance);
        native_instance = 0;  // Other finalizers can still call us.
    }

    private static native void nativeDestructor(long native_patheffect);
    long native_instance;
}

```



# 0x02 drawable文件是如何加载的
```
android.view.LayoutInflater#inflate(int, android.view.ViewGroup)
android.view.LayoutInflater#inflate(int, android.view.ViewGroup, boolean)
android.view.LayoutInflater#inflate(org.xmlpull.v1.XmlPullParser, android.view.ViewGroup, boolean)
android.view.LayoutInflater#createViewFromTag(android.view.View, java.lang.String, android.content.Context, android.util.AttributeSet)
android.view.LayoutInflater#createViewFromTag(android.view.View, java.lang.String, android.content.Context, android.util.AttributeSet, boolean)
mFactory2.onCreateView
android.support.v7.app.AppCompatDelegateImplV9#onCreateView(android.view.View, java.lang.String, android.content.Context, android.util.AttributeSet)
android.support.v7.app.AppCompatDelegateImplV9#createView
android.support.v7.app.AppCompatViewInflater#createView(android.view.View, java.lang.String, android.content.Context, android.util.AttributeSet, boolean, boolean, boolean, boolean)
这里可以解释为什么TextView会被加载为AppCompatTextView
    ...
    switch (name) {
            case "TextView":
                view = new AppCompatTextView(context, attrs);
    ...
android.support.v7.widget.AppCompatTextView#AppCompatTextView(android.content.Context, android.util.AttributeSet)    
android.widget.TextView#TextView(android.content.Context, android.util.AttributeSet, int, int)
android.view.View#View(android.content.Context, android.util.AttributeSet, int, int)
在加载view的时候获取drawable
    ...
        final int N = a.getIndexCount();
        for (int i = 0; i < N; i++) {
            int attr = a.getIndex(i);
            switch (attr) {
                case com.android.internal.R.styleable.View_background:
                    background = a.getDrawable(attr);
    ...
android.content.res.TypedArray#getDrawable
android.content.res.Resources#loadDrawable
android.content.res.ResourcesImpl#loadDrawable
会加载一些缓存，没有的时候才执行加载
android.content.res.ResourcesImpl#loadDrawableForCookie
    ...
            if (file.endsWith(".xml")) {
                final XmlResourceParser rp = loadXmlResourceParser(
                        file, id, value.assetCookie, "drawable");
                dr = Drawable.createFromXml(wrapper, rp, theme);
                rp.close();
            } else {
                final InputStream is = mAssets.openNonAsset(
                        value.assetCookie, file, AssetManager.ACCESS_STREAMING);
                dr = Drawable.createFromResourceStream(wrapper, value, is, file, null);
                is.close();
            }
    ...
android.graphics.drawable.Drawable#createFromXml(android.content.res.Resources, org.xmlpull.v1.XmlPullParser, android.content.res.Resources.Theme)
android.graphics.drawable.Drawable#createFromXmlInner(android.content.res.Resources, org.xmlpull.v1.XmlPullParser, android.util.AttributeSet, android.content.res.Resources.Theme)
android.graphics.drawable.DrawableInflater#inflateFromXml
最终到了加载的地方
    ...
        Drawable drawable = inflateFromTag(name);
        if (drawable == null) {
            drawable = inflateFromClass(name);
        }
        drawable.inflate(mRes, parser, attrs, theme);
        return drawable;
android.graphics.drawable.DrawableInflater#inflateFromTag
可以看到 shape标签被加载为了GradientDrawable，而并不是ShapeDrawable，并且没有任何一个可以加载为ShapeDrawable。
        switch (name) {
            case "selector":
                return new StateListDrawable();
            case "animated-selector":
                return new AnimatedStateListDrawable();
            case "level-list":
                return new LevelListDrawable();
            case "layer-list":
                return new LayerDrawable();
            case "transition":
                return new TransitionDrawable();
            case "ripple":
                return new RippleDrawable();
            case "color":
                return new ColorDrawable();
            case "shape":
                return new GradientDrawable();
            case "vector":
                return new VectorDrawable();
            case "animated-vector":
                return new AnimatedVectorDrawable();
            case "scale":
                return new ScaleDrawable();
            case "clip":
                return new ClipDrawable();
            case "rotate":
                return new RotateDrawable();
            case "animated-rotate":
                return new AnimatedRotateDrawable();
            case "animation-list":
                return new AnimationDrawable();
            case "inset":
                return new InsetDrawable();
            case "bitmap":
                return new BitmapDrawable();
            case "nine-patch":
                return new NinePatchDrawable();
            default:
                return null;
        }
android.graphics.drawable.DrawableInflater#inflateFromClass
        try {
            Constructor<? extends Drawable> constructor;
            synchronized (CONSTRUCTOR_MAP) {
                constructor = CONSTRUCTOR_MAP.get(className);
                if (constructor == null) {
                    final Class<? extends Drawable> clazz =
                            mClassLoader.loadClass(className).asSubclass(Drawable.class);
                    constructor = clazz.getConstructor();
                    CONSTRUCTOR_MAP.put(className, constructor);
                }
            }
            return constructor.newInstance();
        } catch (NoSuchMethodException e) {
            final InflateException ie = new InflateException(
                    "Error inflating class " + className);
            ie.initCause(e);
            throw ie;
        } catch (ClassCastException e) {
            // If loaded class is not a Drawable subclass.
            final InflateException ie = new InflateException(
                    "Class is not a Drawable " + className);
            ie.initCause(e);
            throw ie;
        } catch (ClassNotFoundException e) {
            // If loadClass fails, we should propagate the exception.
            final InflateException ie = new InflateException(
                    "Class not found " + className);
            ie.initCause(e);
            throw ie;
        } catch (Exception e) {
            final InflateException ie = new InflateException(
                    "Error inflating class " + className);
            ie.initCause(e);
            throw ie;
        }
android.graphics.drawable.GradientDrawable#inflate
```

## 2.1 如何用布局加载一个ShapeDrawable
根据前面的加载流程追踪，官网所说的
>This object can be defined in an XML file with the \<shape\> element.

应该是不正确的，那我们有没有可能从资源文件加载一个ShapDrawable呢？  
上面还有一个 inflateFromClass ，我们试一下。  
因为最少要api 24，就移到了24的资源文件夹中。  
加载后调用的android.graphics.drawable.Drawable#inflate(android.content.res.Resources, org.xmlpull.v1.XmlPullParser, android.util.AttributeSet, android.content.res.Resources.Theme)  
ShapeDrawable中调用到android.graphics.drawable.ShapeDrawable#updateStateFromTypedArray  
看到虽然Shape不能设置，但至少颜色、padding是可以设置的  
测试了一下成功，布局文件如下：
```
<?xml version="1.0" encoding="utf-8"?>
<drawable
    xmlns:android="http://schemas.android.com/apk/res/android"
    class="android.graphics.drawable.ShapeDrawable"
    android:color="@color/colorPrimary">
    <padding
        android:bottom="20dp"
        android:left="10dp" />
</drawable>
```

# 0x03 为什么要有ShapeDrawable
即然ShapeDrawable不能通过shape标签创建（可以通过drawable），GradientDrawable也可以代替ShapeDrawable，为什么还要有ShapeDrawable呢？  
前面我们说过，Gradient的shape只支持RECTANGLE, OVAL, LINE, RING，那么Shape的子类呢？有  
```
Shape
    PathShape
    RectShape
        ArcShape
        OvalShape
        RoundRectShape
```
那就试一下ArcShape
```
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        val tv: TextView = findViewById<TextView>(R.id.tv)
        val background: Drawable? = tv.background
        background?.let {
            Log.d("xx", background.javaClass.name)
            if (background is ShapeDrawable) {
                val arcShape: ArcShape = ArcShape(0f, 270f)
                background.shape = arcShape
            }
        }
    }
```
效果图  
![](https://pingfangx.github.io/resource/blogx/2385.1.png)

而且别忘了还可以继承哦。  
在源码中搜索ShapeDrawable及PaintDrawable，还是找到一些使用的。
# Talk is cheap
[The code](https://github.com/pingfangx/AndroidX/tree/demo/demo/ShapeDrawableAndGradientDrawable)

[/md]