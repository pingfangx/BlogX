启动了未正常停止。

# 下断
猜想可能是被提前取消了。  
在 Animation 中有 android.view.animation.Animation#cancel 和 android.view.animation.Animation#detach  
两个方法，但是断点却未命中

在 draw 下断
android.view.View#draw(android.graphics.Canvas, android.view.ViewGroup, long)


        final Animation a = getAnimation();
        if (a != null) {
            more = applyLegacyAnimation(parent, drawingTime, a, scalingRequired);
            ...
            
看到 getAnimation() 返回 null 被清空了。

于是下字段断点，在 

    clearAnimation:23493, View (android.view)
    removeViewAt:872, RecyclerView$5 (android.support.v7.widget)
    removeViewAt:168, ChildHelper (android.support.v7.widget)
    removeViewAt:8374, RecyclerView$LayoutManager (android.support.v7.widget)
    scrapOrRecycleView:8944, RecyclerView$LayoutManager (android.support.v7.widget)
    detachAndScrapAttachedViews:8930, RecyclerView$LayoutManager (android.support.v7.widget)
    onLayoutChildren:580, LinearLayoutManager (android.support.v7.widget)
    onLayoutChildren:171, GridLayoutManager (android.support.v7.widget)
    dispatchLayoutStep2:3924, RecyclerView (android.support.v7.widget)
    dispatchLayout:3641, RecyclerView (android.support.v7.widget)
    onLayout:4194, RecyclerView (android.support.v7.widget)
    
    有清空操作，但是并没有当前场景的原因，当前原因是
    onDetachedFromWindowInternal:18207, View (android.view)
    dispatchDetachedFromWindow:18401, View (android.view)
    dispatchDetachedFromWindow:3777, ViewGroup (android.view)
    dispatchDetachedFromWindow:3769, ViewGroup (android.view)
    removeViewInternal:5359, ViewGroup (android.view)
    removeViewAt:5306, ViewGroup (android.view)
    removeViewAt:877, RecyclerView$5 (android.support.v7.widget)
    removeViewAt:168, ChildHelper (android.support.v7.widget)
    removeViewAt:8374, RecyclerView$LayoutManager (android.support.v7.widget)
    scrapOrRecycleView:8944, RecyclerView$LayoutManager (android.support.v7.widget)
    detachAndScrapAttachedViews:8930, RecyclerView$LayoutManager (android.support.v7.widget)
    onLayoutChildren:580, LinearLayoutManager (android.support.v7.widget)
    onLayoutChildren:171, GridLayoutManager (android.support.v7.widget)
    dispatchLayoutStep2:3924, RecyclerView (android.support.v7.widget)
    dispatchLayout:3641, RecyclerView (android.support.v7.widget)
    onLayout:4194, RecyclerView (android.support.v7.widget)
    
# 会什么要移除 View
    android.support.v7.widget.RecyclerView.LayoutManager#scrapOrRecycleView
    

        private void scrapOrRecycleView(Recycler recycler, int index, View view) {
            final ViewHolder viewHolder = getChildViewHolderInt(view);
            if (viewHolder.shouldIgnore()) {
                if (DEBUG) {
                    Log.d(TAG, "ignoring view " + viewHolder);
                }
                return;
            }
            if (viewHolder.isInvalid() && !viewHolder.isRemoved()
                    && !mRecyclerView.mAdapter.hasStableIds()) {
                removeViewAt(index);
                recycler.recycleViewHolderInternal(viewHolder);
            } else {
                detachViewAt(index);
                recycler.scrapView(view);
                mRecyclerView.mViewInfoStore.onViewDetached(viewHolder);
            }
        }
    按理说，只需要 detachViewAt 就可以了，为什么这里会 removeViewAt 
    
    发现 isInvalid 返回 true ，已经无效。
    
# 对 mFlags 下字段断点
    android.support.v7.widget.RecyclerView.ViewHolder#mFlags
    
    
    addFlags:11037, RecyclerView$ViewHolder (android.support.v7.widget)
    markKnownViewsInvalid:4496, RecyclerView (android.support.v7.widget)
    processDataSetCompletelyChanged:4484, RecyclerView (android.support.v7.widget)
    onChanged:5284, RecyclerView$RecyclerViewDataObserver (android.support.v7.widget)
    notifyChanged:11997, RecyclerView$AdapterDataObservable (android.support.v7.widget)
    notifyDataSetChanged:7070, RecyclerView$Adapter (android.support.v7.widget)
    
    发现因为调用 notifyDataSetChanged 会标记所有 Views 无效。
    
        void markKnownViewsInvalid() {
            final int cachedCount = mCachedViews.size();
            for (int i = 0; i < cachedCount; i++) {
                final ViewHolder holder = mCachedViews.get(i);
                if (holder != null) {
                    holder.addFlags(ViewHolder.FLAG_UPDATE | ViewHolder.FLAG_INVALID);
                    holder.addChangePayload(null);
                }
            }

            if (mAdapter == null || !mAdapter.hasStableIds()) {
                // we cannot re-use cached views in this case. Recycle them all
                recycleAndClearCachedViews();
            }
        }