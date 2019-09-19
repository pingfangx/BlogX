# 项目中实现的懒加载
    public void loadRealView() {
        if (isNeedLazyLoad() && mRealView == null) {
            if (mLazyView != null) {
                //加载真实的 view
                mRealView = onCreateRealView(mInflater, mContainer, mSavedInstanceState);
                if (mRealView != null) {
                    //添加真实的 view
                    ViewParent parent = mLazyView.getParent();
                    if (parent instanceof ViewGroup) {
                        ViewGroup viewGroup = (ViewGroup) parent;
                        //添加到相同的 index
                        int index = viewGroup.indexOfChild(mLazyView);
                        viewGroup.removeViewAt(index);
                        viewGroup.addView(mRealView, index);
                        //设置 mView 否则会出错
                        setView(mRealView);
                        //部分子类在在 onViewCreated 中初始化
                        onViewCreated(mRealView, mSavedInstanceState);
                    }
                }
            }
        }
    }
# 问题描述
点击 RadioButton 可以正常展示，懒加载堆栈为

    loadRealView:121, LazyFragment (com.cloudy.jun.common.basic)
    onShow:105, LazyFragment (com.cloudy.jun.common.basic)
    setUserVisibleHint:92, LazyFragment (com.cloudy.jun.common.basic)
    setPrimaryItem:160, FragmentStatePagerAdapter (android.support.v4.app)
    populate:1234, ViewPager (android.support.v4.view)
    setCurrentItemInternal:669, ViewPager (android.support.v4.view)
    setCurrentItemInternal:631, ViewPager (android.support.v4.view)
    setCurrentItem:612, ViewPager (android.support.v4.view)
    onClick:272, PagerSlidingTabStrip$3 (com.cloudy.common.widget)
但是如果是滑动，触发懒加载则可能无法展示，堆栈为

    loadRealView:121, LazyFragment (com.cloudy.jun.common.basic)
    onPageScrolled:56, BaseScrollTabViewPagerFragment$1 (com.cloudy.jun.common.basic)
    onPageScrolled:419, PagerSlidingTabStrip$PageListener (com.cloudy.common.widget)
    dispatchOnPageScrolled:1924, ViewPager (android.support.v4.view)
    onPageScrolled:1904, ViewPager (android.support.v4.view)
    pageScrolled:1842, ViewPager (android.support.v4.view)
    performDrag:2353, ViewPager (android.support.v4.view)

# 问题排查
    布局看到，正常展示的两个 item，left-right 分别为 0-1080，1080-2160  
    无法展示时，第二个 item 为 1080-1080
    
    在 onLayout 中断点，发现得到的宽度就不正确
    android.support.v4.view.ViewPager#onLayout
        child.layout(childLeft, paddingTop, childLeft + child.getMeasuredWidth(), paddingTop + child.getMeasuredHeight());
    发现 child.getMeasuredWidth() 为 0
    
    在 onMeasure 中断点发现 widthMeasureSpec 不正确
    android.support.v4.view.ViewPager#onMeasure
    
            widthSpec = MeasureSpec.makeMeasureSpec((int)((float)childWidthSize * lp.widthFactor), 1073741824);
            child.measure(widthSpec, this.mChildHeightMeasureSpec);
            
    发现是 lp.widthFactor 为 0 不正确
    
    查看 lp.widthFactor 的赋值过程
    populate:1257, ViewPager (android.support.v4.view)
    setCurrentItemInternal:669, ViewPager (android.support.v4.view)
    setCurrentItemInternal:631, ViewPager (android.support.v4.view)
    setCurrentItem:612, ViewPager (android.support.v4.view)
    onClick:272, PagerSlidingTabStrip$3 (com.cloudy.common.widget)
    performClick:6597, View (android.view)
    performClickInternal:6574, View (android.view)
    access$3100:778, View (android.view)
    run:25885, View$PerformClick (android.view)
    handleCallback:873, Handler (android.os)
    dispatchMessage:99, Handler (android.os)
    loop:193, Looper (android.os)
    main:6669, ActivityThread (android.app)
    invoke:-1, Method (java.lang.reflect)
    run:493, RuntimeInit$MethodAndArgsCaller (com.android.internal.os)
    main:858, ZygoteInit (com.android.internal.os)
    
# 相关疑问
## 为什么 setCurrentItem 可以触发
因为 setCurrentItem 触发 populate  

    android.support.v4.view.ViewPager#populate(int)
                    ...
                    this.calculatePageOffsets(curItem, curIndex, oldCurInfo);
                    this.mAdapter.setPrimaryItem(this, this.mCurItem, curItem.object);
                }

                this.mAdapter.finishUpdate(this);
                int childCount = this.getChildCount();

                for(itemIndex = 0; itemIndex < childCount; ++itemIndex) {
                    View child = this.getChildAt(itemIndex);
                    ViewPager.LayoutParams lp = (ViewPager.LayoutParams)child.getLayoutParams();
                    lp.childIndex = itemIndex;
                    if (!lp.isDecor && lp.widthFactor == 0.0F) {
                        ViewPager.ItemInfo ii = this.infoForChild(child);
                        if (ii != null) {
                            lp.widthFactor = ii.widthFactor;
                            lp.position = ii.position;
                        }
                    }
                }
                ...
    可以看到 populate 中先调用 setPrimaryItem，然后 setUserVisibleHint,loadRealView
    loadRealView 加载 View，然后回到 populate，检查 lp.widthFactor ，如果为 0 就重新赋值
    赋值为 1 所以可以正常展示
    
## 为什么滑动时触发不了？  
因为滑动的堆栈直接调用的 loadRealView，没有经过 populate，没有重新赋值  
实际是先 loadRealView，然后测量等相关方法，然后才调用的 populate  
populate 中对 lp.widthFactor 进行了赋值，但是不会再重新测量

## 为什么刷新后正常
刷新后重新布局，lp.widthFactor 已经赋值了，所以正常展示

# 滚动如何触发 populate
    completeScroll:2003, ViewPager (android.support.v4.view)
    computeScroll:1814, ViewPager (android.support.v4.view)
    
    
    private void completeScroll(boolean postEvents) {
        boolean needPopulate = this.mScrollState == 2;
        if (needPopulate) {
            this.setScrollingCacheEnabled(false);
            boolean wasScrolling = !this.mScroller.isFinished();
            if (wasScrolling) {
                this.mScroller.abortAnimation();
                int oldX = this.getScrollX();
                int oldY = this.getScrollY();
                int x = this.mScroller.getCurrX();
                int y = this.mScroller.getCurrY();
                if (oldX != x || oldY != y) {
                    this.scrollTo(x, y);
                    if (x != oldX) {
                        this.pageScrolled(x);
                    }
                }
            }
        }

        this.mPopulatePending = false;

        for(int i = 0; i < this.mItems.size(); ++i) {
            ViewPager.ItemInfo ii = (ViewPager.ItemInfo)this.mItems.get(i);
            if (ii.scrolling) {
                needPopulate = true;
                ii.scrolling = false;
            }
        }

        if (needPopulate) {
            if (postEvents) {
                ViewCompat.postOnAnimation(this, this.mEndScrollRunnable);
            } else {
                this.mEndScrollRunnable.run();
            }
        }

    }
    
    /**
     * Indicates that the pager is in the process of settling to a final position.
     */
    public static final int SCROLL_STATE_SETTLING = 2;
    
所以是滚动到最后一次才会触发  
回到一开始的问题，因为在滚动过程中就已经加载了，布局参数确定，测量宽度为 0  
滚动到最后触发 populate 但是没有重新布局

# 解决方案

    viewGroup.addView(mRealView, index);
    改为
    viewGroup.addView(mRealView, index, mLazyView.getLayoutParams());
    因为是替换，布局参数理应相同并复用
    可以参考 ViewStub#replaceSelfWithView