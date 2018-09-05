# 嵌套 RecyclerView 自动滚动的问题
最后发现是因为 focusableInTouchMode，然后发现网上也有相关讨论，遗憾花费了一些时间，不过算是彻底找到了原因。


切换到界面时进行了滚动，在 android.support.v7.widget.RecyclerView.OnScrollListener 下断，确实滚动了

在 android.support.v7.widget.RecyclerView.ViewFlinger#postOnAnimation 下断，找到调用栈

    2 = {StackTraceElement@9542} "android.support.v7.widget.RecyclerView$ViewFlinger.postOnAnimation(RecyclerView.java:5067)"
    3 = {StackTraceElement@9543} "android.support.v7.widget.RecyclerView$ViewFlinger.smoothScrollBy(RecyclerView.java:5142)"
    4 = {StackTraceElement@9544} "android.support.v7.widget.RecyclerView$ViewFlinger.smoothScrollBy(RecyclerView.java:5124)"
    5 = {StackTraceElement@9545} "android.support.v7.widget.RecyclerView.smoothScrollBy(RecyclerView.java:2147)"
    6 = {StackTraceElement@9546} "android.support.v7.widget.RecyclerView.smoothScrollBy(RecyclerView.java:2120)"
    7 = {StackTraceElement@9547} "android.support.v7.widget.RecyclerView$LayoutManager.requestChildRectangleOnScreen(RecyclerView.java:9527)"
    8 = {StackTraceElement@9548} "android.support.v7.widget.RecyclerView.requestChildOnScreen(RecyclerView.java:2650)"
    9 = {StackTraceElement@9549} "android.support.v7.widget.RecyclerView.requestChildFocus(RecyclerView.java:2612)"
    10 = {StackTraceElement@9550} "android.view.View.handleFocusGainInternal(View.java:6623)"
    11 = {StackTraceElement@9551} "android.view.ViewGroup.handleFocusGainInternal(ViewGroup.java:733)"
    12 = {StackTraceElement@9552} "android.view.View.requestFocusNoSearch(View.java:10868)"
    13 = {StackTraceElement@9553} "android.view.View.requestFocus(View.java:10847)"
    14 = {StackTraceElement@9554} "android.view.ViewGroup.requestFocus(ViewGroup.java:3171)"
    15 = {StackTraceElement@9555} "android.view.ViewGroup.onRequestFocusInDescendants(ViewGroup.java:3211)"
    16 = {StackTraceElement@9556} "android.support.v7.widget.RecyclerView.onRequestFocusInDescendants(RecyclerView.java:2673)"
    17 = {StackTraceElement@9557} "android.view.ViewGroup.requestFocus(ViewGroup.java:3170)"
    18 = {StackTraceElement@9558} "android.view.ViewGroup.onRequestFocusInDescendants(ViewGroup.java:3211)"
    19 = {StackTraceElement@9559} "android.view.ViewGroup.requestFocus(ViewGroup.java:3167)"
    20 = {StackTraceElement@9560} "android.view.ViewGroup.onRequestFocusInDescendants(ViewGroup.java:3211)"
    21 = {StackTraceElement@9561} "android.view.ViewGroup.requestFocus(ViewGroup.java:3167)"
    22 = {StackTraceElement@9562} "android.view.ViewGroup.onRequestFocusInDescendants(ViewGroup.java:3211)"
    23 = {StackTraceElement@9563} "android.view.ViewGroup.requestFocus(ViewGroup.java:3167)"
    24 = {StackTraceElement@9564} "android.view.View.requestFocus(View.java:10814)"
    25 = {StackTraceElement@9565} "android.view.View.requestFocus(View.java:10756)"
    26 = {StackTraceElement@9566} "android.view.ViewRootImpl.focusableViewAvailable(ViewRootImpl.java:3453)"
    27 = {StackTraceElement@9567} "android.view.ViewGroup.focusableViewAvailable(ViewGroup.java:855)"
    28 = {StackTraceElement@9568} "android.view.ViewGroup.focusableViewAvailable(ViewGroup.java:855)"
    29 = {StackTraceElement@9569} "android.view.ViewGroup.focusableViewAvailable(ViewGroup.java:855)"
    30 = {StackTraceElement@9570} "android.view.ViewGroup.focusableViewAvailable(ViewGroup.java:855)"
    31 = {StackTraceElement@9571} "android.view.ViewGroup.focusableViewAvailable(ViewGroup.java:855)"
    32 = {StackTraceElement@9572} "android.view.ViewGroup.focusableViewAvailable(ViewGroup.java:855)"
    33 = {StackTraceElement@9573} "android.view.ViewGroup.focusableViewAvailable(ViewGroup.java:855)"
    34 = {StackTraceElement@9574} "android.view.ViewGroup.focusableViewAvailable(ViewGroup.java:855)"
    35 = {StackTraceElement@9575} "android.view.View.setFlags(View.java:13335)"
    36 = {StackTraceElement@9576} "android.view.View.setVisibility(View.java:9420)"
    37 = {StackTraceElement@9577} "android.support.v4.app.FragmentManagerImpl.completeShowHideFragment(FragmentManager.java:1728)"
    
    
    37 开始，由 Fragment 的展示开始。
    36 setVisibility 之后，调至 34 focusableViewAvailable
    25 requestFocus
    23 ViewGroup 的 requestChildFocus 会调用 22 
    22 onRequestFocusInDescendants
        遍历判断 child
        for (int i = index; i != end; i += increment) {
            View child = children[i];
            if ((child.mViewFlags & VISIBILITY_MASK) == VISIBLE) {
                if (child.requestFocus(direction, previouslyFocusedRect)) {
                    return true;
                }
            }
        }
        return false;
    16 转到 RecyclerView.onRequestFocusInDescendants
    调用父类的 15 后，开始判断内部嵌套的 RecyclerView
    14 android.view.ViewGroup#requestFocus
    public boolean requestFocus(int direction, Rect previouslyFocusedRect) {
        if (DBG) {
            System.out.println(this + " ViewGroup.requestFocus direction="
                    + direction);
        }
        int descendantFocusability = getDescendantFocusability();

        switch (descendantFocusability) {
            case FOCUS_BLOCK_DESCENDANTS:
                return super.requestFocus(direction, previouslyFocusedRect);
            case FOCUS_BEFORE_DESCENDANTS: {
                final boolean took = super.requestFocus(direction, previouslyFocusedRect);
                return took ? took : onRequestFocusInDescendants(direction, previouslyFocusedRect);
            }
            case FOCUS_AFTER_DESCENDANTS: {
                final boolean took = onRequestFocusInDescendants(direction, previouslyFocusedRect);
                return took ? took : super.requestFocus(direction, previouslyFocusedRect);
            }
            default:
                throw new IllegalStateException("descendant focusability must be "
                        + "one of FOCUS_BEFORE_DESCENDANTS, FOCUS_AFTER_DESCENDANTS, FOCUS_BLOCK_DESCENDANTS "
                        + "but is " + descendantFocusability);
        }
    }
    调用 super 转到 View
    13 android.view.View#requestFocus(int, android.graphics.Rect)
    12 android.view.View#requestFocusNoSearch
    11 android.view.ViewGroup#handleFocusGainInternal
    10 android.view.View#handleFocusGainInternal
    9 android.support.v7.widget.RecyclerView#requestChildFocus
    public void requestChildFocus(View child, View focused) {
        if (!mLayout.onRequestChildFocus(this, mState, child, focused) && focused != null) {
            requestChildOnScreen(child, focused);
        }
        super.requestChildFocus(child, focused);
    }
    8 android.support.v7.widget.RecyclerView#requestChildOnScreen
    7 android.support.v7.widget.RecyclerView.LayoutManager#requestChildRectangleOnScreen(android.support.v7.widget.RecyclerView, android.view.View, android.graphics.Rect, boolean, boolean)
    根据获取的 scrollAmount 进行的滚动
        public boolean requestChildRectangleOnScreen(RecyclerView parent, View child, Rect rect,
                boolean immediate,
                boolean focusedChildVisible) {
            int[] scrollAmount = getChildRectangleOnScreenScrollAmount(parent, child, rect,
                    immediate);
            int dx = scrollAmount[0];
            int dy = scrollAmount[1];
            if (!focusedChildVisible || isFocusedChildVisibleAfterScrolling(parent, dx, dy)) {
                if (dx != 0 || dy != 0) {
                    if (immediate) {
                        parent.scrollBy(dx, dy);
                    } else {
                        parent.smoothScrollBy(dx, dy);
                    }
                    return true;
                }
            }
            return false;
        }
    后续就是滚动的逻辑了
    6 android.support.v7.widget.RecyclerView#smoothScrollBy(int, int)
    5 android.support.v7.widget.RecyclerView#smoothScrollBy(int, int, android.view.animation.Interpolator)
    4 android.support.v7.widget.RecyclerView.ViewFlinger#smoothScrollBy(int, int, android.view.animation.Interpolator)
    3 android.support.v7.widget.RecyclerView.ViewFlinger#smoothScrollBy(int, int, int, android.view.animation.Interpolator)
    2 android.support.v7.widget.RecyclerView.ViewFlinger#postOnAnimation
    
    那么为什么走滚动呢，多次调试，发现问题在 12
    android.view.View#requestFocusNoSearch
    
    private boolean requestFocusNoSearch(int direction, Rect previouslyFocusedRect) {
        // need to be focusable
        if ((mViewFlags & FOCUSABLE) != FOCUSABLE
                || (mViewFlags & VISIBILITY_MASK) != VISIBLE) {
            return false;
        }

        // need to be focusable in touch mode if in touch mode
        if (isInTouchMode() &&
            (FOCUSABLE_IN_TOUCH_MODE != (mViewFlags & FOCUSABLE_IN_TOUCH_MODE))) {
               return false;
        }

        // need to not have any parents blocking us
        if (hasAncestorThatBlocksDescendantFocus()) {
            return false;
        }

        handleFocusGainInternal(direction, previouslyFocusedRect);
        return true;
    }
    正常的 item，在些方法中返回了 false，不请求焦点，但是嵌套的 RecyclerView 却返回的 true
    区别在于 RecyclerView 到达此处时，focusableInTouchMode 为 true
    在布局文件中设为 false ，仍为 true，因为
    android.support.v7.widget.RecyclerView#RecyclerView(android.content.Context, android.util.AttributeSet, int)
        ...
        setScrollContainer(true);
        setFocusableInTouchMode(true);
        ...
# 总结
问题在于 RecyclerView 默认会设置 focusableInTouchMode 为 true（为什么？）  
于是继承，设为 false ，问题解决。