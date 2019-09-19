CollapsingToolbarLayout 往上折叠后，RecyclerView 下拉未能展开，而是直接调用刷新

    上划的时候
    android.support.v7.widget.RecyclerView#onTouchEvent
    down 的时候分发
        android.support.v7.widget.RecyclerView#startNestedScroll(int, int)
    move 的时候分发
        android.support.v7.widget.RecyclerView#dispatchNestedPreScroll(int, int, int[], int[], int)
        
    startNestedScroll 分发到 android.support.design.widget.CoordinatorLayout#onStartNestedScroll(android.view.View, android.view.View, int, int)
    behavior 标记
    
    dispatchNestedPreScroll 分发到 android.support.design.widget.CoordinatorLayout#onNestedPreScroll(android.view.View, int, int, int[], int)
    
    下拉的时候没有分发到 move 事件
    这是因为下拉的时候，onInterceptTouchEvent 直接拦截了，转给了下拉刷新的 View 的 onTouchEvent，执行了刷新。
    
    其判断为 
    
    public boolean onInterceptTouchEvent(MotionEvent event) {
        ...
                boolean triggerCondition =
                        // refresh trigger condition
                        (yInitDiff > 0 && moved && onCheckCanRefresh()) ||
                                //load more trigger condition
                                (yInitDiff < 0 && moved && onCheckCanLoadMore());
                                
    
    private boolean onCheckCanRefresh() {

        return mRefreshEnabled && !canChildScrollUp() && mHasHeaderView && mRefreshTriggerOffset > 0;
    }
    
    protected boolean canChildScrollUp() {
        boolean r = super.canChildScrollUp();
        if (!r) {
            if (mTargetView instanceof ViewGroup) {
                ViewGroup targetViewGroup = (ViewGroup) mTargetView;
                int childCount = targetViewGroup.getChildCount();
                for (int i = 0; i < childCount; i++) {
                    View iView = ((ViewGroup) mTargetView).getChildAt(i);
                    r = r || canViewScrollUp(iView);
                }
            }
        }
        return r;
    }
    所以还是回到了判断 child 能不能滚动的问题。

# 解决方案
## 是否应该由 behavior 来处理？    
## 是否要设置回调来判断
## 直接改写 canChildScrollUp 判断方法
    ((CoordinatorLayout)getParent()).getDependencies(this).get(0).getLayoutParams().getBehavior().getTopAndBottomOffset()<0