## 3.1 移除
    android.support.v7.widget.RecyclerView#onTouchEvent
    
    public boolean onTouchEvent(MotionEvent e) {
        ...
        switch (action) {
            ...
            case MotionEvent.ACTION_MOVE: {
                ...
                if (mScrollState == SCROLL_STATE_DRAGGING) {
                    mLastTouchX = x - mScrollOffset[0];
                    mLastTouchY = y - mScrollOffset[1];
                    // 滚动
                    if (scrollByInternal(
                            canScrollHorizontally ? dx : 0,
                            canScrollVertically ? dy : 0,
                            vtev)) {
                        getParent().requestDisallowInterceptTouchEvent(true);
                    }
                    if (mGapWorker != null && (dx != 0 || dy != 0)) {
                        // 预加载，原理不太了解，后面会简单提到
                        mGapWorker.postFromTraversal(this, dx, dy);
                    }
                }
            } break;
            ...
        }

        if (!eventAddedToVelocityTracker) {
            mVelocityTracker.addMovement(vtev);
        }
        vtev.recycle();

        return true;
    }
    
    android.support.v7.widget.RecyclerView#scrollByInternal
            if (y != 0) {
                //计算 consumedY
                consumedY = mLayout.scrollVerticallyBy(y, mRecycler, mState);
                unconsumedY = y - consumedY;
            }
            
    android.support.v7.widget.LinearLayoutManager#scrollVerticallyBy
## android.support.v7.widget.LinearLayoutManager#scrollBy{
        if (getChildCount() == 0 || dy == 0) {
            return 0;
        }
        mLayoutState.mRecycle = true;
        ensureLayoutState();
        final int layoutDirection = dy > 0 ? LayoutState.LAYOUT_END : LayoutState.LAYOUT_START;
        final int absDy = Math.abs(dy);
        //更新 layoutState ，dy 由滑动传过来
        updateLayoutState(layoutDirection, absDy, true, state);
        //计算 consumed ，调用的 fill
        final int consumed = mLayoutState.mScrollingOffset
                + fill(recycler, mLayoutState, state, false);
        if (consumed < 0) {
            if (DEBUG) {
                Log.d(TAG, "Don't have any more elements to scroll");
            }
            return 0;
        }
        final int scrolled = absDy > consumed ? layoutDirection * consumed : dy;
        mOrientationHelper.offsetChildren(-scrolled);
        if (DEBUG) {
            Log.d(TAG, "scroll req: " + dy + " scrolled: " + scrolled);
        }
        mLayoutState.mLastScrollDelta = scrolled;
        return scrolled;
    }
    
    updateLayoutState 更新了要滑动的状态
    
    private void updateLayoutState(int layoutDirection, int requiredSpace,
            boolean canUseExistingSpace, RecyclerView.State state) {
        // If parent provides a hint, don't measure unlimited.
        mLayoutState.mInfinite = resolveIsInfinite();
        mLayoutState.mExtra = getExtraLayoutSpace(state);
        mLayoutState.mLayoutDirection = layoutDirection;
        int scrollingOffset;
        if (layoutDirection == LayoutState.LAYOUT_END) {
            mLayoutState.mExtra += mOrientationHelper.getEndPadding();
            // get the first child in the direction we are going
            // 获取朝向的第一个
            final View child = getChildClosestToEnd();
            // the direction in which we are traversing children
            mLayoutState.mItemDirection = mShouldReverseLayout ? LayoutState.ITEM_DIRECTION_HEAD
                    : LayoutState.ITEM_DIRECTION_TAIL;
            //位置加上方向，得到当前位置
            mLayoutState.mCurrentPosition = getPosition(child) + mLayoutState.mItemDirection;
            //偏移
            mLayoutState.mOffset = mOrientationHelper.getDecoratedEnd(child);
            // calculate how much we can scroll without adding new children (independent of layout)
            scrollingOffset = mOrientationHelper.getDecoratedEnd(child)
                    - mOrientationHelper.getEndAfterPadding();

        } else {
            ...
        }
        mLayoutState.mAvailable = requiredSpace;
        if (canUseExistingSpace) {
            mLayoutState.mAvailable -= scrollingOffset;
        }
        mLayoutState.mScrollingOffset = scrollingOffset;
    }
    
    fill 中调用回收
## android.support.v7.widget.LinearLayoutManager#recycleByLayoutState
    android.support.v7.widget.LinearLayoutManager#recycleViewsFromStart
    
    private void recycleViewsFromStart(RecyclerView.Recycler recycler, int dt) {
        if (dt < 0) {
            if (DEBUG) {
                Log.d(TAG, "Called recycle from start with a negative value. This might happen"
                        + " during layout changes but may be sign of a bug");
            }
            return;
        }
        // ignore padding, ViewGroup may not clip children.
        final int limit = dt;
        final int childCount = getChildCount();
        if (mShouldReverseLayout) {
        } else {
            for (int i = 0; i < childCount; i++) {
                View child = getChildAt(i);
                if (mOrientationHelper.getDecoratedEnd(child) > limit
                        || mOrientationHelper.getTransformedEndWithDecoration(child) > limit) {
                    // stop here
                    //回收到 limit ，当 getDecoratedEnd > limit 时，表示之前的可以回收，回收到 i
                    recycleChildren(recycler, 0, i);
                    return;
                }
            }
        }
        
    android.support.v7.widget.LinearLayoutManager#recycleChildren
    android.support.v7.widget.RecyclerView.LayoutManager#removeAndRecycleViewAt
        public void removeAndRecycleViewAt(int index, Recycler recycler) {
            final View view = getChildAt(index);
            removeViewAt(index);
            recycler.recycleView(view);
        }
接下来转到 Recycler
## android.support.v7.widget.RecyclerView.Recycler#recycleView
    android.support.v7.widget.RecyclerView.Recycler#recycleViewHolderInternal
    
        void recycleViewHolderInternal(ViewHolder holder) {
            if (holder.isScrap() || holder.itemView.getParent() != null) {
                throw new IllegalArgumentException(
                        "Scrapped or attached views may not be recycled. isScrap:"
                                + holder.isScrap() + " isAttached:"
                                + (holder.itemView.getParent() != null) + exceptionLabel());
            }

            if (holder.isTmpDetached()) {
                throw new IllegalArgumentException("Tmp detached view should be removed "
                        + "from RecyclerView before it can be recycled: " + holder
                        + exceptionLabel());
            }

            if (holder.shouldIgnore()) {
                throw new IllegalArgumentException("Trying to recycle an ignored view holder. You"
                        + " should first call stopIgnoringView(view) before calling recycle."
                        + exceptionLabel());
            }
            //noinspection unchecked
            final boolean transientStatePreventsRecycling = holder
                    .doesTransientStatePreventRecycling();
            final boolean forceRecycle = mAdapter != null
                    && transientStatePreventsRecycling
                    && mAdapter.onFailedToRecycleView(holder);
            boolean cached = false;
            boolean recycled = false;
            if (DEBUG && mCachedViews.contains(holder)) {
                throw new IllegalArgumentException("cached view received recycle internal? "
                        + holder + exceptionLabel());
            }
            if (forceRecycle || holder.isRecyclable()) {
                if (mViewCacheMax > 0
                        && !holder.hasAnyOfTheFlags(ViewHolder.FLAG_INVALID
                        | ViewHolder.FLAG_REMOVED
                        | ViewHolder.FLAG_UPDATE
                        | ViewHolder.FLAG_ADAPTER_POSITION_UNKNOWN)) {
                    // Retire oldest cached view
                    // 淘汰最早的缓存视图
                    int cachedViewSize = mCachedViews.size();
                    if (cachedViewSize >= mViewCacheMax && cachedViewSize > 0) {
                        // 该方法不仅会从缓存移除，还会加入 pool 
                        recycleCachedViewAt(0);
                        cachedViewSize--;
                    }

                    int targetCacheIndex = cachedViewSize;
                    if (ALLOW_THREAD_GAP_WORK
                            && cachedViewSize > 0
                            && !mPrefetchRegistry.lastPrefetchIncludedPosition(holder.mPosition)) {
                        // when adding the view, skip past most recently prefetched views
                        // 添加视图时，跳过最近预取的视图，即前面提到的预加载
                        int cacheIndex = cachedViewSize - 1;
                        while (cacheIndex >= 0) {
                            int cachedPos = mCachedViews.get(cacheIndex).mPosition;
                            // 获取缓存的 view 的 position 如果预取的包含该位置,则跳过，执行 index--
                            if (!mPrefetchRegistry.lastPrefetchIncludedPosition(cachedPos)) {
                                break;
                            }
                            cacheIndex--;
                        }
                        targetCacheIndex = cacheIndex + 1;
                    }
                    // 最终都会执行 add ，前面求 index 只是为了往前移，
                    mCachedViews.add(targetCacheIndex, holder);
                    cached = true;
                }
                if (!cached) {
                    // 未缓存添加到 pool
                    // 已缓存的，有可能会把旧的缓存移除，移除后加入 pool
                    addViewHolderToRecycledViewPool(holder, true);
                    recycled = true;
                }
            } else {
                // NOTE: A view can fail to be recycled when it is scrolled off while an animation
                // runs. In this case, the item is eventually recycled by
                // ItemAnimatorRestoreListener#onAnimationFinished.

                // TODO: consider cancelling an animation when an item is removed scrollBy,
                // to return it to the pool faster
                if (DEBUG) {
                    Log.d(TAG, "trying to recycle a non-recycleable holder. Hopefully, it will "
                            + "re-visit here. We are still removing it from animation lists"
                            + exceptionLabel());
                }
            }
            // even if the holder is not removed, we still call this method so that it is removed
            // from view holder lists.
            mViewInfoStore.removeViewHolder(holder);
            if (!cached && !recycled && transientStatePreventsRecycling) {
                holder.mOwnerRecyclerView = null;
            }
        }

从 mCachedViews 中移除的 holder 添加到了 pool 中


        void recycleCachedViewAt(int cachedViewIndex) {
            if (DEBUG) {
                Log.d(TAG, "Recycling cached view at index " + cachedViewIndex);
            }
            ViewHolder viewHolder = mCachedViews.get(cachedViewIndex);
            if (DEBUG) {
                Log.d(TAG, "CachedViewHolder to be recycled: " + viewHolder);
            }
            addViewHolderToRecycledViewPool(viewHolder, true);
            mCachedViews.remove(cachedViewIndex);
        }
        void addViewHolderToRecycledViewPool(ViewHolder holder, boolean dispatchRecycled) {
            clearNestedRecyclerViewIfNotNested(holder);
            if (holder.hasAnyOfTheFlags(ViewHolder.FLAG_SET_A11Y_ITEM_DELEGATE)) {
                holder.setFlags(0, ViewHolder.FLAG_SET_A11Y_ITEM_DELEGATE);
                ViewCompat.setAccessibilityDelegate(holder.itemView, null);
            }
            if (dispatchRecycled) {
                dispatchViewRecycled(holder);
            }
            holder.mOwnerRecyclerView = null;
            getRecycledViewPool().putRecycledView(holder);
        }
        public void putRecycledView(ViewHolder scrap) {
            final int viewType = scrap.getItemViewType();
            final ArrayList<ViewHolder> scrapHeap = getScrapDataForType(viewType).mScrapHeap;
            if (mScrap.get(viewType).mMaxScrap <= scrapHeap.size()) {
                return;
            }
            if (DEBUG && scrapHeap.contains(scrap)) {
                throw new IllegalArgumentException("this scrap item already exists");
            }
            scrap.resetInternal();
            scrapHeap.add(scrap);
        }
可以看到，移除的 holder 最后添加到了 mCachedViews 或是 pool 中
## 3.2 复用
在原理 2 中已经分析过，  
### 首先调用 getScrapOrHiddenOrCachedHolderForPosition
又分为 3 步，mCachedViews 好理解， scrap 和 hidden view 不知道具体使用情景，见后文 3.4 再分析

        ViewHolder getScrapOrHiddenOrCachedHolderForPosition(int position, boolean dryRun) {
            final int scrapCount = mAttachedScrap.size();

            // Try first for an exact, non-invalid match from scrap.
            // 1 从 scrap 中获取
            for (int i = 0; i < scrapCount; i++) {
                final ViewHolder holder = mAttachedScrap.get(i);
                if (!holder.wasReturnedFromScrap() && holder.getLayoutPosition() == position
                        && !holder.isInvalid() && (mState.mInPreLayout || !holder.isRemoved())) {
                    holder.addFlags(ViewHolder.FLAG_RETURNED_FROM_SCRAP);
                    return holder;
                }
            }

            if (!dryRun) {
                // 2 查找 hidden view
                View view = mChildHelper.findHiddenNonRemovedView(position);
                if (view != null) {
                    // This View is good to be used. We just need to unhide, detach and move to the
                    // scrap list.
                    final ViewHolder vh = getChildViewHolderInt(view);
                    mChildHelper.unhide(view);
                    int layoutIndex = mChildHelper.indexOfChild(view);
                    if (layoutIndex == RecyclerView.NO_POSITION) {
                        throw new IllegalStateException("layout index should not be -1 after "
                                + "unhiding a view:" + vh + exceptionLabel());
                    }
                    mChildHelper.detachViewFromParent(layoutIndex);
                    scrapView(view);
                    vh.addFlags(ViewHolder.FLAG_RETURNED_FROM_SCRAP
                            | ViewHolder.FLAG_BOUNCED_FROM_HIDDEN_LIST);
                    return vh;
                }
            }

            // Search in our first-level recycled view cache.
            // 3 从 cachedViews 中获取
            final int cacheSize = mCachedViews.size();
            for (int i = 0; i < cacheSize; i++) {
                final ViewHolder holder = mCachedViews.get(i);
                // invalid view holders may be in cache if adapter has stable ids as they can be
                // retrieved via getScrapOrCachedViewForId
                if (!holder.isInvalid() && holder.getLayoutPosition() == position) {
                    if (!dryRun) {
                        mCachedViews.remove(i);
                    }
                    if (DEBUG) {
                        Log.d(TAG, "getScrapOrHiddenOrCachedHolderForPosition(" + position
                                + ") found match in cache: " + holder);
                    }
                    return holder;
                }
            }
            return null;
        }
### 第 2 通过 id 查找
    getScrapOrCachedViewForId
需要 android.support.v7.widget.RecyclerView.Adapter#hasStableIds 返回 true  
且重写 android.support.v7.widget.RecyclerView.Adapter#getItemId

### 第 3 从 mViewCacheExtension
    final View view = mViewCacheExtension
                            .getViewForPositionAndType(this, position, type);
    可以通过 android.support.v7.widget.RecyclerView#setViewCacheExtension 设置

### 第 4 从 pool
                    holder = getRecycledViewPool().getRecycledView(type);

### 第 5，最后再创建
                    holder = mAdapter.createViewHolder(RecyclerView.this, type);
## 3.3 预加载
    android.support.v7.widget.GapWorker#run
    android.support.v7.widget.GapWorker#flushTasksWithDeadline
    android.support.v7.widget.GapWorker#flushTaskWithDeadline
    android.support.v7.widget.GapWorker#prefetchPositionWithDeadline

## 3.4 scrap 和 hidden view
## 查看 scrap 的赋值  
    android.support.v7.widget.RecyclerView.Recycler#scrapView
有两处调用

    其一为
    android.support.v7.widget.RecyclerView.Recycler#getScrapOrHiddenOrCachedHolderForPosition
    在这里面，先从 scrap 找，没找到再调用 android.support.v7.widget.ChildHelper#findHiddenNonRemovedView
    然后如果找到了，就会调用 scrapView 添加
    
    其二为
    android.support.v7.widget.RecyclerView.LayoutManager#scrapOrRecycleView
    有3处调用
    android.support.v7.widget.RecyclerView.LayoutManager#detachAndScrapView
    android.support.v7.widget.RecyclerView.LayoutManager#detachAndScrapViewAt
    android.support.v7.widget.RecyclerView.LayoutManager#detachAndScrapAttachedViews
    最后看到调用就在 android.support.v7.widget.LinearLayoutManager#onLayoutChildren 中
    
    于是调用 notifyDataSetChanged 发现在 android.support.v7.widget.RecyclerView.LayoutManager#scrapOrRecycleView 中
    都走了 recycleViewHolderInternal ，没有执行 scrapView
            if (viewHolder.isInvalid() && !viewHolder.isRemoved()
                    && !mRecyclerView.mAdapter.hasStableIds()) {
                removeViewAt(index);
                recycler.recycleViewHolderInternal(viewHolder);
            } else {
                detachViewAt(index);
                recycler.scrapView(view);
                mRecyclerView.mViewInfoStore.onViewDetached(viewHolder);
            }
    于是改为 notifyItemRemoved
    调用栈为
    2 = {StackTraceElement@5855} "android.support.v7.widget.RecyclerView$Recycler.scrapView(RecyclerView.java:6179)"
    3 = {StackTraceElement@5856} "android.support.v7.widget.RecyclerView$LayoutManager.scrapOrRecycleView(RecyclerView.java:8823)"
    4 = {StackTraceElement@5857} "android.support.v7.widget.RecyclerView$LayoutManager.detachAndScrapAttachedViews(RecyclerView.java:8805)"
    5 = {StackTraceElement@5858} "android.support.v7.widget.LinearLayoutManager.onLayoutChildren(LinearLayoutManager.java:582)"
    6 = {StackTraceElement@5859} "android.support.v7.widget.RecyclerView.dispatchLayoutStep1(RecyclerView.java:3763)"
    7 = {StackTraceElement@5860} "android.support.v7.widget.RecyclerView.dispatchLayout(RecyclerView.java:3527)"
    8 = {StackTraceElement@5861} "android.support.v7.widget.RecyclerView.onLayout(RecyclerView.java:4082)"
    
    同时也断点到 hidden view 的添加
    
    整理调用原因，在调用 onItemRangeRemoved 是，添加了一个 UpdateOp.REMOVE 的操作
    2 = {StackTraceElement@7606} "android.support.v7.widget.AdapterHelper.onItemRangeRemoved(AdapterHelper.java:530)"
    3 = {StackTraceElement@7607} "android.support.v7.widget.RecyclerView$RecyclerViewDataObserver.onItemRangeRemoved(RecyclerView.java:5205)"
    4 = {StackTraceElement@7608} "android.support.v7.widget.RecyclerView$AdapterDataObservable.notifyItemRangeRemoved(RecyclerView.java:11820)"
    5 = {StackTraceElement@7609} "android.support.v7.widget.RecyclerView$Adapter.notifyItemRemoved(RecyclerView.java:7122)"

    然后在处理时，更新了 ViewHolder 的 flag
    2 = {StackTraceElement@7368} "android.support.v7.widget.RecyclerView$ViewHolder.addFlags(RecyclerView.java:10892)"
    3 = {StackTraceElement@7369} "android.support.v7.widget.RecyclerView$ViewHolder.flagRemovedAndOffsetPosition(RecyclerView.java:10694)"
    4 = {StackTraceElement@7370} "android.support.v7.widget.RecyclerView.offsetPositionRecordsForRemove(RecyclerView.java:4313)"
    5 = {StackTraceElement@7371} "android.support.v7.widget.RecyclerView$6.offsetPositionsForRemovingLaidOutOrNewView(RecyclerView.java:918)"
    6 = {StackTraceElement@7372} "android.support.v7.widget.AdapterHelper.postponeAndUpdateViewHolders(AdapterHelper.java:447)"
    7 = {StackTraceElement@7373} "android.support.v7.widget.AdapterHelper.applyRemove(AdapterHelper.java:182)"
    8 = {StackTraceElement@7374} "android.support.v7.widget.AdapterHelper.preProcess(AdapterHelper.java:101)"
    9 = {StackTraceElement@7375} "android.support.v7.widget.RecyclerView.processAdapterUpdatesAndSetAnimationFlags(RecyclerView.java:3471)"
    10 = {StackTraceElement@7376} "android.support.v7.widget.RecyclerView.dispatchLayoutStep1(RecyclerView.java:3717)"
    11 = {StackTraceElement@7377} "android.support.v7.widget.RecyclerView.dispatchLayout(RecyclerView.java:3527)"
    12 = {StackTraceElement@7378} "android.support.v7.widget.RecyclerView.onLayout(RecyclerView.java:4082)"
    
    接下来，在下面 step1 中全部回收
    2 = {StackTraceElement@8390} "android.support.v7.widget.RecyclerView$LayoutManager.scrapOrRecycleView(RecyclerView.java:8810)"
    3 = {StackTraceElement@8391} "android.support.v7.widget.RecyclerView$LayoutManager.detachAndScrapAttachedViews(RecyclerView.java:8805)"
    4 = {StackTraceElement@8392} "android.support.v7.widget.LinearLayoutManager.onLayoutChildren(LinearLayoutManager.java:582)"
    5 = {StackTraceElement@8393} "android.support.v7.widget.RecyclerView.dispatchLayoutStep1(RecyclerView.java:3763)"
    6 = {StackTraceElement@8394} "android.support.v7.widget.RecyclerView.dispatchLayout(RecyclerView.java:3527)"
    7 = {StackTraceElement@8395} "android.support.v7.widget.RecyclerView.onLayout(RecyclerView.java:4082)"
    
    
    再看一下 notifyDataSetChanged 的
    2 = {StackTraceElement@5840} "android.support.v7.widget.RecyclerView.markKnownViewsInvalid(RecyclerView.java:4384)"
    3 = {StackTraceElement@5841} "android.support.v7.widget.RecyclerView.processDataSetCompletelyChanged(RecyclerView.java:4372)"
    4 = {StackTraceElement@5842} "android.support.v7.widget.RecyclerView$RecyclerViewDataObserver.onChanged(RecyclerView.java:5180)"
    5 = {StackTraceElement@5843} "android.support.v7.widget.RecyclerView$AdapterDataObservable.notifyChanged(RecyclerView.java:11785)"
    6 = {StackTraceElement@5844} "android.support.v7.widget.RecyclerView$Adapter.notifyDataSetChanged(RecyclerView.java:6961)"
    
    
经过上面的分析，我们知道了，调用 notifyDataSetChanged 会使所有的 ViewHolder 失效（通过设置 flag），
然后在布局时的 detachAndScrapAttachedViews 中会被回收。
而调用 notifyItemRemoved ，会使要移除的 viewHolder 标记为 remove ，但不标记为失效，执行 scrap
scrap 的 view 要通过判断 position 相等才返回

## hidden view
添加

    2 = {StackTraceElement@6619} "android.support.v7.widget.ChildHelper.hideViewInternal(ChildHelper.java:60)"
    3 = {StackTraceElement@6620} "android.support.v7.widget.ChildHelper.attachViewToParent(ChildHelper.java:237)"
    4 = {StackTraceElement@6621} "android.support.v7.widget.RecyclerView.addAnimatingView(RecyclerView.java:1355)"
    5 = {StackTraceElement@6622} "android.support.v7.widget.RecyclerView.animateDisappearance(RecyclerView.java:4049)"
    6 = {StackTraceElement@6623} "android.support.v7.widget.RecyclerView$4.processDisappeared(RecyclerView.java:555)"
    7 = {StackTraceElement@6624} "android.support.v7.widget.ViewInfoStore.process(ViewInfoStore.java:242)"
    8 = {StackTraceElement@6625} "android.support.v7.widget.RecyclerView.dispatchLayoutStep3(RecyclerView.java:3882)"
    9 = {StackTraceElement@6626} "android.support.v7.widget.RecyclerView.dispatchLayout(RecyclerView.java:3540)"
    10 = {StackTraceElement@6627} "android.support.v7.widget.RecyclerView.onLayout(RecyclerView.java:4082)"
    
    
移除

    2 = {StackTraceElement@9255} "android.support.v7.widget.ChildHelper.unhideViewInternal(ChildHelper.java:70)"
    3 = {StackTraceElement@9256} "android.support.v7.widget.ChildHelper.removeViewIfHidden(ChildHelper.java:382)"
    4 = {StackTraceElement@9257} "android.support.v7.widget.RecyclerView.removeAnimatingView(RecyclerView.java:1371)"
    5 = {StackTraceElement@9258} "android.support.v7.widget.RecyclerView$ItemAnimatorRestoreListener.onAnimationFinished(RecyclerView.java:12242)"
    6 = {StackTraceElement@9259} "android.support.v7.widget.RecyclerView$ItemAnimator.dispatchAnimationFinished(RecyclerView.java:12742)"
    7 = {StackTraceElement@9260} "android.support.v7.widget.SimpleItemAnimator.dispatchRemoveFinished(SimpleItemAnimator.java:279)"
    8 = {StackTraceElement@9261} "android.support.v7.widget.DefaultItemAnimator$4.onAnimationEnd(DefaultItemAnimator.java:213)"
    
但是复用的代码一直断不下来，不知道具体触发的情景。

另外发现一个问题 getItemViewType 如果返回 1 个类型，则 notifyItemRemoved 会只移除那一个。
但是如果返回 2 个类型，则整个列表都重新刷新了（能明显看到加载前的空白），具体原因暂不知道。