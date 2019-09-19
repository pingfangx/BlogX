# 拖动的情况

    onInterceptTouchEvent
    onTouchEvent
        记录并记算 mLastTouchY，dy
        使用 dy 进行滚动
    RecyclerView#scrollByInternal
        传给 layoutmanager，RecyclerView.LayoutManager#scrollVerticallyBy
        调用 dispatchOnScrolled 分发
        
    LinearLayoutManager#scrollBy
        更新状态 LinearLayoutManager#updateLayoutState
        填充 LinearLayoutManager#fill
        偏移 OrientationHelper#offsetChildren
        
        OrientationHelper#offsetChildren
        LayoutManager#offsetChildrenVertical
        RecyclerView#offsetChildrenVertical
        android.view.View#offsetTopAndBottom
        
# fling 的情况

    onTouchEvent
        case MotionEvent.ACTION_UP
    RecyclerView#fling
    ViewFlinger#fling
        mScroller.fling(0, 0, velocityX, velocityY,
                Integer.MIN_VALUE, Integer.MAX_VALUE, Integer.MIN_VALUE, Integer.MAX_VALUE);
        postOnAnimation();
        
        接下来就是 mScroller 负责滚动，
        RecyclerView.ViewFlinger#run 方法负责获取 getCurrY，根据 mLastFlingY 计算 dy
        有了 dy 又调用 LayoutManager#scrollVerticallyBy
        
# Scroller 原理

    android.widget.OverScroller.SplineOverScroller#startScroll
    android.widget.OverScroller.SplineOverScroller#fling
    这两个方法都会对 mStartTime 进行赋值
            mStartTime = AnimationUtils.currentAnimationTimeMillis();
    
    public static long currentAnimationTimeMillis() {
        AnimationState state = sAnimationState.get();
        if (state.animationClockLocked) {
            // It's important that time never rewinds
            return Math.max(state.currentVsyncTimeMillis,
                    state.lastReportedTimeMillis);
        }
        state.lastReportedTimeMillis = SystemClock.uptimeMillis();
        return state.lastReportedTimeMillis;
    }
    
    最后获取时，都会调用 android.widget.OverScroller#computeScrollOffset
    滚动会调用 android.widget.OverScroller.SplineOverScroller#updateScroll
    
    fling 会调用 android.widget.OverScroller.SplineOverScroller#update

# 如何自定义 fling
[control fling speed for recycler view](https://stackoverflow.com/questions/32120452)

所以有两种方法，
一是重写 RecyclerView#fling 可以缩放一定倍数
二是提供 RecyclerView.OnFlingListener
或者看 SmoothScroller 能否实现