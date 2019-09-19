[md]

无法下拉刷新，想起以前添加 decoration 以后，就可以正常刷新了。  
试了一下果然，这一次寻找一下原因，最后发现还是因为隐藏某个 item 后造成的，就不应该隐藏。

调试后发现
```
在
com.aspsine.swipetoloadlayout.SwipeToLoadLayout#onInterceptTouchEvent
中调用的 onCheckCanRefresh 始终返回 false，也就是不可以刷新。
com.aspsine.swipetoloadlayout.SwipeToLoadLayout#onCheckCanRefresh
com.aspsine.swipetoloadlayout.SwipeToLoadLayout#canChildScrollUp 始终返回 true
com.aspsine.swipetoloadlayout.SwipeToLoadLayout2#canChildScrollUp 重写的
com.aspsine.swipetoloadlayout.SwipeToLoadLayout2#canViewScrollUp
发现在计算 recyclerView 时
//⑥
android.support.v4.view.ViewCompat#canScrollVertically(view,-1) 返回 true
android.view.View#canScrollVertically
    /**
     * Check if this view can be scrolled vertically in a certain direction.
     *
     * @param direction Negative to check scrolling up, positive to check scrolling down.
     * @return true if this view can be scrolled in the specified direction, false otherwise.
     */
    public boolean canScrollVertically(int direction) {
        //④
        final int offset = computeVerticalScrollOffset();
        final int range = computeVerticalScrollRange() - computeVerticalScrollExtent();
        if (range == 0) return false;
        if (direction < 0) {
            //⑤
            return offset > 0;
        } else {
            return offset < range - 1;
        }
    }
看 recyclerView 是如何计算 computeVerticalScrollOffset() 的
android.support.v7.widget.RecyclerView#computeVerticalScrollOffset
转给 LayoutManager
android.support.v7.widget.LinearLayoutManager#computeVerticalScrollOffset
android.support.v7.widget.LinearLayoutManager#computeScrollOffset
    private int computeScrollOffset(RecyclerView.State state) {
        if (getChildCount() == 0) {
            return 0;
        }
        ensureLayoutState();
        return ScrollbarHelper.computeScrollOffset(state, mOrientationHelper,
                findFirstVisibleChildClosestToStart(!mSmoothScrollbarEnabled, true),
                findFirstVisibleChildClosestToEnd(!mSmoothScrollbarEnabled, true),
                this, mSmoothScrollbarEnabled, mShouldReverseLayout);
    }
计算第一个可见 child
android.support.v7.widget.LinearLayoutManager#findFirstVisibleChildClosestToStart
android.support.v7.widget.LinearLayoutManager#findOneVisibleChild

    View findOneVisibleChild(int fromIndex, int toIndex, boolean completelyVisible,
            boolean acceptPartiallyVisible) {
        ensureLayoutState();
        final int start = mOrientationHelper.getStartAfterPadding();
        final int end = mOrientationHelper.getEndAfterPadding();
        final int next = toIndex > fromIndex ? 1 : -1;
        View partiallyVisible = null;
        for (int i = fromIndex; i != toIndex; i+=next) {
            final View child = getChildAt(i);
            final int childStart = mOrientationHelper.getDecoratedStart(child);
            // ①
            final int childEnd = mOrientationHelper.getDecoratedEnd(child);
            if (childStart < end && childEnd > start) {
                if (completelyVisible) {
                    if (childStart >= start && childEnd <= end) {
                        return child;
                    } else if (acceptPartiallyVisible && partiallyVisible == null) {
                        partiallyVisible = child;
                    }
                } else {
                    return child;
                }
            }
        }
        return partiallyVisible;
    }
android.support.v7.widget.OrientationHelper#getDecoratedEnd

android.support.v7.widget.ScrollbarHelper#computeScrollOffset

    static int computeScrollOffset(RecyclerView.State state, OrientationHelper orientation,
            View startChild, View endChild, RecyclerView.LayoutManager lm,
            boolean smoothScrollbarEnabled, boolean reverseLayout) {
        if (lm.getChildCount() == 0 || state.getItemCount() == 0 || startChild == null ||
                endChild == null) {
            return 0;
        }
        //②
        final int minPosition = Math.min(lm.getPosition(startChild),
                lm.getPosition(endChild));
        final int maxPosition = Math.max(lm.getPosition(startChild),
                lm.getPosition(endChild));
        //③
        final int itemsBefore = reverseLayout
                ? Math.max(0, state.getItemCount() - maxPosition - 1)
                : Math.max(0, minPosition);
        if (!smoothScrollbarEnabled) {
            return itemsBefore;
        }
        final int laidOutArea = Math.abs(orientation.getDecoratedEnd(endChild) -
                orientation.getDecoratedStart(startChild));
        final int itemRange = Math.abs(lm.getPosition(startChild) -
                lm.getPosition(endChild)) + 1;
        final float avgSizePerRow = (float) laidOutArea / itemRange;

        return Math.round(itemsBefore * avgSizePerRow + (orientation.getStartAfterPadding()
                - orientation.getDecoratedStart(startChild)));
    }


设置了 decoration ，使得①中第0个隐藏的 headerView 可见，②③得出的 itemsBefore 为0，返回到④为0，⑤返回 false，到⑥返回 false 可以刷新。
未设置 decoration , 使得①中第0个隐藏的 headerView 不可见，②③得出的 itemsBefore 为1，返回到④有值，⑤返回 true，到⑥返回 false 不可以刷新。
```

到此处，就和之前研初过的 item 设置为 GONE 时仍占用高度的问题连起来了。
要想让 item 设为 GONE，应该在外面包裹一层 ViewGroup，然后手动设置为 GONE
但设置为 GONE，又会导致计算 itemsBefore 时，认为前面还有一个item。



[/md]