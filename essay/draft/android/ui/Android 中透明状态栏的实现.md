* Q:
window flag 和 ui visibility flag 有什么不同

*R:
[沉浸式状态栏实现及遇到的坑](http://liuling123.com/2017/02/transparent-status-bar.html)



# 1 全屏
## 隐藏 android.support.v7.app.ActionBar
    android.support.v7.app.AppCompatActivity#getSupportActionBar
    android.support.v7.app.ActionBar#hide
    注意是 support 的才行
    
## 全屏 android.view.View#setSystemUiVisibility
android.view.View#SYSTEM_UI_FLAG_FULLSCREEN  
设置后进入全屏，隐藏状态栏

## SYSTEM_UI_FLAG_LAYOUT_STABLE | SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
如下所述

# 2 状态栏
## 透明状态栏
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_STABLE | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN);
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
            window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
            window.setStatusBarColor(Color.RED);
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            window.addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
        }
    
    SYSTEM_UI_FLAG_LAYOUT_STABLE 和 SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
    需要同时使用，注意两者都是针对 LAYOUT ，注意要与 SYSTEM_UI_FLAG_FULLSCREEN 区分
    设置之后，布局已经处于状态栏之下，但由于状态栏有颜色，所以覆盖了布局
    加上设置状态栏透明即可
    window.setStatusBarColor(Color.TRANSPARENT);
    
## 设置状态栏背景颜色 setStatusBarColor
    android.view.Window#setStatusBarColor
    按照文档，设置颜色需要设置 
    android.view.WindowManager.LayoutParams#FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS
    且不能设置
    android.view.WindowManager.LayoutParams#FLAG_TRANSLUCENT_STATUS
    
    对于 FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS
    默认是可以绘制的，手动 clearFlag 就不可以绘制了。
    
    对于 FLAG_TRANSLUCENT_STATUS
    设置后就直接关态栏就直接透明了（实际字面意是半透明，是否不同机型有区别）
    
## 设置状态栏字体颜色 SYSTEM_UI_FLAG_LIGHT_STATUS_BAR
符合亮色状态栏，即字体为黑色

## FLAG_TRANSLUCENT_STATUS
在文档中有这样的说明

> When this flag is enabled for a window, it automatically sets the system UI visibility flags View.SYSTEM_UI_FLAG_LAYOUT_STABLE and View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN.

没有找到源码，但是可见透明状态栏中两种方法的实现一致，只是前者手动设置了 setStatusBarColor

## WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS
文档表示
> If set, the system bars are drawn with a transparent background and the corresponding areas in this window are filled with the colors specified in getStatusBarColor() and getNavigationBarColor().

但是实测还是只有 setStatusBarColor 有效。



# 3 坑
## 输入法无法顶起底部内容
