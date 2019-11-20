Activity 会创建一个 Window，在 attach 方法中，会创建一个 Window 的安卓了类，即 PhoneWindow

Window 负责 View 的展示，Activity 、Dialog 都是 Window 来展示 View 的

当调用 setConentView 的时候，PhoneWindow 会自己一个创建一个 DecorView， DecorView 是 FrameLayout 的子类。

同时会加载某个布局，将布局添加到 DecorView 中，然后再从 DecorView 中 findViewById

找出 id 为 ID_ANDROID_CONTENT 即 content 的 ViewGroup 作为 mContentParent


S:
* setConentView 是将 View 或 id 加载出来的 View，添加到 PhoneWindow 中持有 mContentParent 中
* 而 mContentParent 是 PhoneWindow 创建 DecorView，将 DecorView 中添加布局，并通过 content id 查找出来的


# 加载的某个布局是哪个布局
    com.android.internal.policy.PhoneWindow#generateLayout 中加载
        mDecor.onResourcesLoaded(mLayoutInflater, layoutResource);
        
    执行的最后一个 else
    layoutResource = R.layout.screen_simple;
    
    在 <sdk>/platforms/android-28/data/res/layout 中找到布局
    
    <LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:fitsSystemWindows="true"
        android:orientation="vertical">
        <ViewStub android:id="@+id/action_mode_bar_stub"
                  android:inflatedId="@+id/action_mode_bar"
                  android:layout="@layout/action_mode_bar"
                  android:layout_width="match_parent"
                  android:layout_height="wrap_content"
                  android:theme="?attr/actionBarTheme" />
        <FrameLayout
             android:id="@android:id/content"
             android:layout_width="match_parent"
             android:layout_height="match_parent"
             android:foregroundInsidePadding="false"
             android:foregroundGravity="fill_horizontal|top"
             android:foreground="?android:attr/windowContentOverlay" />
    </LinearLayout>