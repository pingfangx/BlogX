Q:
* 注入的实现原理
* 不同 context 的注入 √
* 字段和点击事件的注入区别 √
* 为什么不能 private √
* 为什么使用 R2 √
* DebouncingOnClickListener 的使用 √

当前学习版本为 8.8.1，为了测试在 module 中的使用，又退回了 8.4.0  
注入的使用将再另一篇文章中介绍
# 0x00 官网介绍
[JakeWharton/butterknife](https://github.com/JakeWharton/butterknife)
> Field and method binding for Android views which uses annotation processing to generate boilerplate code for you.

> Remember: A butter knife is like a dagger only infinitely less sharp.  
这可能是它的命名原因？

> Instead of slow reflection, code is generated to perform the view look-ups. Calling bind delegates to this generated code that you can see and debug.  
后续解析 private

# 0x01 基本使用
## 1.1 结合 kotlin 的使用
新项目其实可以不使用 butterknife 的，为了学习使用一下。  
```
apply plugin: 'kotlin-kapt'

dependencies {
    ...
    compile "com.jakewharton:butterknife:$butterknife-version"
    kapt "com.jakewharton:butterknife-compiler:$butterknife-version"
}
@BindView(R2.id.title)
lateinit var title: TextView

@OnClick(R2.id.hello)
internal fun sayHello() {
    Toast.makeText(this, "Hello, views!", LENGTH_SHORT).show()
}
```

## $app_debug
一开始点击事件无效，看了生成的代码，点击事件名后面多了 $app_debug  
虽然后来发现只是因为忘了写 ButterKnife.bind 方法（教程中没写，一下子忘了），但还是不知道这个名字后面为什么加了 $app_debug 也能调用。

## 1.2 官网提供了哪些用法
[Butter Knife](http://jakewharton.github.io/butterknife/)

1. RESOURCE BINDING  
绑定资源
0. NON-ACTIVITY BINDING  
绑定任意的 view root
0. VIEW LISTS  
组合多个 view ，可以使用 apply 方法
0. LISTENER BINDING  
监听
0. BINDING RESET  
Fragment 中返回 Unbinder 可用于 unbind
0. OPTIONAL BINDINGS  
使用 @Nullable 或 @Optional 注解，尤其注意在可能有继承的类中
0. MULTI-METHOD LISTENERS  
含多个方法的监听

# 0x02 bind 源码查看
    
      @NonNull @UiThread
      public static Unbinder bind(@NonNull Activity target) {
        View sourceView = target.getWindow().getDecorView();
        return createBinding(target, sourceView);
      }
      butterknife.ButterKnife#createBinding 方法接受一个 target 和一个 source 参数，相关的 bind 方法重载即为获取这两个参数。
      其中 activity 和 dialog 均为 target.getWindow().getDecorView();
      
      
      private static Unbinder createBinding(@NonNull Object target, @NonNull View source) {
        Class<?> targetClass = target.getClass();
        Constructor<? extends Unbinder> constructor = findBindingConstructorForClass(targetClass);
        try {
          return constructor.newInstance(target, source);
        } 
      }
      可以看到，是查找构造函数，然后创建实例。
      
      @Nullable @CheckResult @UiThread
      private static Constructor<? extends Unbinder> findBindingConstructorForClass(Class<?> cls) {
        //获取缓存
        Constructor<? extends Unbinder> bindingCtor = BINDINGS.get(cls);
        if (bindingCtor != null) {
          return bindingCtor;
        }
        String clsName = cls.getName();
        //终止搜索
        if (clsName.startsWith("android.") || clsName.startsWith("java.")) {
          if (debug) Log.d(TAG, "MISS: Reached framework class. Abandoning search.");
          return null;
        }
        try {
            //类名加上 _ViewBinding
          Class<?> bindingClass = cls.getClassLoader().loadClass(clsName + "_ViewBinding");
          //noinspection unchecked
          //获取构造函数
          bindingCtor = (Constructor<? extends Unbinder>) bindingClass.getConstructor(cls, View.class);
          if (debug) Log.d(TAG, "HIT: Loaded binding class and constructor.");
        } catch (ClassNotFoundException e) {
            //查找父类
          if (debug) Log.d(TAG, "Not found. Trying superclass " + cls.getSuperclass().getName());
          bindingCtor = findBindingConstructorForClass(cls.getSuperclass());
        } catch (NoSuchMethodException e) {
          throw new RuntimeException("Unable to find binding constructor for " + clsName, e);
        }
        //加入缓存
        BINDINGS.put(cls, bindingCtor);
        return bindingCtor;
      }
      
从 bind 的源码，我们知道了  
Q:为什么可以在基类中封装 ButterKnife.bind  
因为 bind 方法在执行时 getClass 获取当前类（子类）名，而生成的文件是根据子类生成不同的 _ViewBinding 类。

Q:不同 context 的注入  
只是取 sourceView 的不同

# 0x03 生成代码的查看
## 3.1 构造方法
    public final class MainActivity_ViewBinding implements Unbinder {
      private MainActivity target;

      private View view2131165320;

      @UiThread
      public MainActivity_ViewBinding(MainActivity target) {
        this(target, target.getWindow().getDecorView());
      }

      @UiThread
      public MainActivity_ViewBinding(final MainActivity target, View source) {
        this.target = target;

        View view;
        //查找
        view = Utils.findRequiredView(source, R.id.tv, "field 'tv' and method 'sayHello$app_debug'");
        //转换
        target.tv = Utils.castView(view, R.id.tv, "field 'tv'", TextView.class);
        //赋值
        view2131165320 = view;
        //点击事件
        view.setOnClickListener(new DebouncingOnClickListener() {
          @Override
          public void doClick(View p0) {
            target.sayHello$app_debug();
          }
        });
      }

      @Override
      public void unbind() {
        MainActivity target = this.target;
        if (target == null) throw new IllegalStateException("Bindings already cleared.");
        this.target = null;

        target.tv = null;

        view2131165320.setOnClickListener(null);
        view2131165320 = null;
      }
    }
## 3.2 查找
包含 findRequiredView 和 findOptionalViewAsType 方法  
查找时即简单地 findViewById ，who 用来报错

      public static View findRequiredView(View source, @IdRes int id, String who) {
        View view = source.findViewById(id);
        if (view != null) {
          return view;
        }
        String name = getResourceEntryName(source, id);
        throw new IllegalStateException("Required view '"
            + name
            + "' with ID "
            + id
            + " for "
            + who
            + " was not found. If this view is optional add '@Nullable' (fields) or '@Optional'"
            + " (methods) annotation.");
      }
      
## 3.3 转换
调用 java.lang.Class#cast 方法

      public static <T> T castView(View view, @IdRes int id, String who, Class<T> cls) {
        try {
          return cls.cast(view);
        } catch (ClassCastException e) {
          String name = getResourceEntryName(view, id);
          throw new IllegalStateException("View '"
              + name
              + "' with ID "
              + id
              + " for "
              + who
              + " was of the wrong type. See cause for more info.", e);
        }
      }
      
## 3.4 赋值
直接等号赋值的，这也是原文中说的
>  Instead of slow reflection, code is generated to perform the view look-ups.

没有用反射，通过代码生成的。  
也是为什么不能用 private 的原因，方法同理

## 3.5 点击事件 DebouncingOnClickListener
防止重复点击，查了一下相关方法
* 使用 throttleFirst
* 记录点击时间

以及这里的 DebouncingOnClickListener
TODO 完成一个防止重复点击的 view 和一个可以多次点击的 view


    /**
     * A {@linkplain View.OnClickListener click listener} that debounces multiple clicks posted in the
     * same frame. A click on one button disables all buttons for that frame.
     */
    public abstract class DebouncingOnClickListener implements View.OnClickListener {
      static boolean enabled = true;

      private static final Runnable ENABLE_AGAIN = new Runnable() {
        @Override public void run() {
          enabled = true;
        }
      };

      @Override public final void onClick(View v) {
        if (enabled) {
          enabled = false;
          v.post(ENABLE_AGAIN);
          doClick(v);
        }
      }

      public abstract void doClick(View v);
    }

# 0x04 在模块中使用

    项目中
    classpath 'com.jakewharton:butterknife-gradle-plugin:8.8.1'
    
    模块中
    apply plugin: 'com.jakewharton.butterknife'
    
    使用 R2 替换

使用时遇到了 
[963](https://github.com/JakeWharton/butterknife/issues/963)  

> Error:Unable to find method 'com.android.build.gradle.api.BaseVariant.getOutputs()Ljava/util/List;'.

退回了 8.4.0 测试成功