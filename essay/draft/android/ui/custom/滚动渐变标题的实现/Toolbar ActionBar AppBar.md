Q
* ActionBar 与 Toolbar 有什么区别
* getActionBar 与 getSupportActionBar
* ActionBar 是如何默认添加上的


# 1 ActionBar 与 Toolbar 有什么区别
根据文档
> A Toolbar is a generalization of action bars for use within application layouts. 

Toolbar 比 ActionBar 支持更多的功能

# 2 相关方法
* android.app.Activity#getActionBar  
ActionBar getActionBar()
* androidx.appcompat.app.AppCompatActivity#getSupportActionBar  
ActionBar getSupportActionBar()
* android.app.Activity#setActionBar  
setActionBar(@Nullable Toolbar toolbar)
* androidx.appcompat.app.AppCompatActivity#setSupportActionBar  
setSupportActionBar(@Nullable Toolbar toolbar)

## 为什么 set 方法参数是 Toolbar ，get 方法返回的却是 ActionBar
    androidx.appcompat.app.AppCompatDelegateImpl#setSupportActionBar
    
        if (toolbar != null) {
            final ToolbarActionBar tbab = new ToolbarActionBar(toolbar, getTitle(),
                    mAppCompatWindowCallback);
            mActionBar = tbab;
            mWindow.setCallback(tbab.getWrappedWindowCallback());
        } else {
            mActionBar = null;
            // Re-set the original window callback since we may have already set a Toolbar wrapper
            mWindow.setCallback(mAppCompatWindowCallback);
        }
        
    可以看到 将 toolbar 包装为 ToolbarActionBar
    androidx.appcompat.app.ToolbarActionBar#ToolbarActionBar
    
    ToolbarActionBar(Toolbar toolbar, CharSequence title, Window.Callback windowCallback) {
        mDecorToolbar = new ToolbarWidgetWrapper(toolbar, false);
        mWindowCallback = new ToolbarCallbackWrapper(windowCallback);
        mDecorToolbar.setWindowCallback(mWindowCallback);
        toolbar.setOnMenuItemClickListener(mMenuClicker);
        mDecorToolbar.setWindowTitle(title);
    }
    在 ToolbarActionBar 内包装为 mDecorToolbar
    调用相关方法时，ToolbarActionBar 交给 mDecorToolbar，再交给 toolbar
## 如何从 getSupportActionBar 中取出 Toolbar
如上一个问题，只能通过反射取字段。  
但其实常用方法没必要取，直接调用 ActionBar 的相关方法即可。

## set 和 get 的成对使用
setSupportActionBar 和 getSupportActionBar，ActionBar 保存在 AppCompatDelegateImpl 中  
setActionBar 和 getActionBar，保存在 Activity 中。


# 3 ActionBar 是如何添加上的
默认添加的 ActionBar 在调用 getSupportActionBar 时返回 WindowDecorActionBar

    androidx.appcompat.app.AppCompatDelegateImpl#getSupportActionBar
        initWindowDecorActionBar();
    androidx.appcompat.app.AppCompatDelegateImpl#initWindowDecorActionBar
        ...
        if (mHost instanceof Activity) {
            mActionBar = new WindowDecorActionBar((Activity) mHost, mOverlayActionBar);
        } else if (mHost instanceof Dialog) {
            mActionBar = new WindowDecorActionBar((Dialog) mHost);
        }
    androidx.appcompat.app.WindowDecorActionBar#init
        ...
        mDecorToolbar = getDecorToolbar(decor.findViewById(R.id.action_bar));
实际已经存在了，此时只是查找赋值。
直接在 Toolbar 构造函数下断

    androidx.appcompat.app.AppCompatDelegateImpl#setContentView(int)
    @Override
    public void setContentView(int resId) {
        ensureSubDecor();
        //加载到 android.R.id.content 中
        ViewGroup contentParent = mSubDecor.findViewById(android.R.id.content);
        contentParent.removeAllViews();
        LayoutInflater.from(mContext).inflate(resId, contentParent);
        mAppCompatWindowCallback.getWrapped().onContentChanged();
    }
    
    androidx.appcompat.app.AppCompatDelegateImpl#ensureSubDecor
    androidx.appcompat.app.AppCompatDelegateImpl#createSubDecor
    
        if (!mWindowNoTitle) {
            if (mIsFloating) {
                ...
            } else if (mHasActionBar) {
                /**
                 * This needs some explanation. As we can not use the android:theme attribute
                 * pre-L, we emulate it by manually creating a LayoutInflater using a
                 * ContextThemeWrapper pointing to actionBarTheme.
                 */
                TypedValue outValue = new TypedValue();
                mContext.getTheme().resolveAttribute(R.attr.actionBarTheme, outValue, true);

                Context themedContext;
                if (outValue.resourceId != 0) {
                    themedContext = new ContextThemeWrapper(mContext, outValue.resourceId);
                } else {
                    themedContext = mContext;
                }

                // Now inflate the view using the themed context and set it as the content view
                subDecor = (ViewGroup) LayoutInflater.from(themedContext)
                        .inflate(R.layout.abc_screen_toolbar, null);

                mDecorContentParent = (DecorContentParent) subDecor
                        .findViewById(R.id.decor_content_parent);
                mDecorContentParent.setWindowCallback(getWindowCallback());
                ...
            }
            
        ...
        mWindow.setContentView(subDecor);
        ...
        return subDecor;
    
    
# R.layout.abc_screen_toolbar
abc 表示 ActionBarCompat  
[What is abc prefix on R.dimen fields?](https://stackoverflow.com/questions/31075246)

详见 setContentView 分析

# 4 动态代码添加 menuItem

[How can I add an Action Bar Item during run time](https://stackoverflow.com/a/10322945)

    @Override
    public boolean onCreateOptionsMenu(Menu menu)
    {
        menu.add(0, 0, 0, "History").setIcon(R.drawable.ic_menu_recent_history)
                .setShowAsAction(MenuItem.SHOW_AS_ACTION_IF_ROOM);
        menu.add(0, 1, 0, "Settings").setIcon(R.drawable.ic_menu_manage)
                .setShowAsAction(MenuItem.SHOW_AS_ACTION_IF_ROOM);

        return true;
    }