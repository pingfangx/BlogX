Child 是如何添加到 RecyclerView 的
LinearLayoutManager 的 onLayoutChildren 过程。

首先断点查看了堆栈

    5 = {StackTraceElement@5679} "android.support.v7.widget.RecyclerView$Adapter.createViewHolder(RecyclerView.java:6685)"
    6 = {StackTraceElement@5680} "android.support.v7.widget.RecyclerView$Recycler.tryGetViewHolderForPositionByDeadline(RecyclerView.java:5869)"
    7 = {StackTraceElement@5681} "android.support.v7.widget.RecyclerView$Recycler.getViewForPosition(RecyclerView.java:5752)"
    8 = {StackTraceElement@5682} "android.support.v7.widget.RecyclerView$Recycler.getViewForPosition(RecyclerView.java:5748)"
    9 = {StackTraceElement@5683} "android.support.v7.widget.LinearLayoutManager$LayoutState.next(LinearLayoutManager.java:2232)"
    10 = {StackTraceElement@5684} "android.support.v7.widget.LinearLayoutManager.layoutChunk(LinearLayoutManager.java:1559)"
    11 = {StackTraceElement@5685} "android.support.v7.widget.LinearLayoutManager.fill(LinearLayoutManager.java:1519)"
    12 = {StackTraceElement@5686} "android.support.v7.widget.LinearLayoutManager.onLayoutChildren(LinearLayoutManager.java:614)"
    13 = {StackTraceElement@5687} "android.support.v7.widget.RecyclerView.dispatchLayoutStep2(RecyclerView.java:3812)"
    14 = {StackTraceElement@5688} "android.support.v7.widget.RecyclerView.dispatchLayout(RecyclerView.java:3529)"
    15 = {StackTraceElement@5689} "android.support.v7.widget.RecyclerView.onLayout(RecyclerView.java:4082)"
    

## android.support.v7.widget.LinearLayoutManager#onLayoutChildren
    @Override
    public void onLayoutChildren(android.support.v7.widget.RecyclerView.Recycler recycler, android.support.v7.widget.RecyclerView.State state) {
        // layout algorithm:
        // 1) by checking children and other variables, find an anchor coordinate and an anchor
        //  item position.
        // 2) fill towards start, stacking from bottom
        // 3) fill towards end, stacking from top
        // 4) scroll to fulfill requirements like stack from bottom.
        /*
        layout 算法：
        1，通过检查 children 及其他变量，找出一个锚点坐标和锚点 item 位置
        2，朝着 start 填充，从底部堆放
        3，朝着 end 填充，从顶部堆放
        4，滚动以满足从底层开始堆放的需求
         */
        // create layout state
        // 创建 layout state
        ...
        ensureLayoutState();
        mLayoutState.mRecycle = false;
        // resolve layout direction
        // 处理 layout 方向
        resolveShouldLayoutReverse();

        final View focused = getFocusedChild();
        if (!mAnchorInfo.mValid || mPendingScrollPosition != NO_POSITION
                || mPendingSavedState != null) {
            mAnchorInfo.reset();
            mAnchorInfo.mLayoutFromEnd = mShouldReverseLayout ^ mStackFromEnd;
            // calculate anchor position and coordinate
            // 计算锚点位置各坐标
            // 初始状态计算出 0 0
            updateAnchorInfoForLayout(recycler, state, mAnchorInfo);
            mAnchorInfo.mValid = true;
        }
        ...
        //
        detachAndScrapAttachedViews(recycler);
        mLayoutState.mInfinite = resolveIsInfinite();
        mLayoutState.mIsPreLayout = state.isPreLayout();
        if (mAnchorInfo.mLayoutFromEnd) {
            ...
        } else {
            // fill towards end
            // 朝着 end 填充，第一次填充时，offset 为 0 ，mAvailable 被置为最后
            updateLayoutStateToFillEnd(mAnchorInfo);
            mLayoutState.mExtra = extraForEnd;
            fill(recycler, mLayoutState, state, false);
            endOffset = mLayoutState.mOffset;
            final int lastElement = mLayoutState.mCurrentPosition;
            if (mLayoutState.mAvailable > 0) {
                extraForStart += mLayoutState.mAvailable;
            }
            // fill towards start
            updateLayoutStateToFillStart(mAnchorInfo);
            mLayoutState.mExtra = extraForStart;
            mLayoutState.mCurrentPosition += mLayoutState.mItemDirection;
            fill(recycler, mLayoutState, state, false);
            startOffset = mLayoutState.mOffset;

            if (mLayoutState.mAvailable > 0) {
                extraForEnd = mLayoutState.mAvailable;
                // start could not consume all it should. add more items towards end
                updateLayoutStateToFillEnd(lastElement, endOffset);
                mLayoutState.mExtra = extraForEnd;
                fill(recycler, mLayoutState, state, false);
                endOffset = mLayoutState.mOffset;
            }
        }
        ...
        layoutForPredictiveAnimations(recycler, state, startOffset, endOffset);
        if (!state.isPreLayout()) {
            mOrientationHelper.onLayoutComplete();
        } else {
            mAnchorInfo.reset();
        }
        mLastStackFromEnd = mStackFromEnd;
        if (DEBUG) {
            validateChildOrder();
        }
    }
    
可以看到，在调用 updateLayoutStateToFillEnd 及 updateLayoutStateToFillStart 更新状态以后，调用 fill 完成了填充

## android.support.v7.widget.LinearLayoutManager#fill

    /**
     * The magic functions :). Fills the given layout, defined by the layoutState. This is fairly
     * independent from the rest of the {@link android.support.v7.widget.LinearLayoutManager}
     * and with little change, can be made publicly available as a helper class.
     * 魔术功能
     * 填充由 layoutState 定义的给定布局。
     * 这与 LinearLayoutManager 的其余部分相对独立，稍许变化，可以作为辅助类公开提供
     *
     * @param recycler        Current recycler that is attached to RecyclerView
     * 附加到 RecyclerView 的当前 recycler
     * @param layoutState     Configuration on how we should fill out the available space.
     * 如何填充可用空间的配置
     * @param state           Context passed by the RecyclerView to control scroll steps.
     * RecyclerView 传递的控制滚动步骤的上下文
     * @param stopOnFocusable If true, filling stops in the first focusable new child
     * 如果为 true，则填充停在第一个可调焦的新 child 中
     * @return Number of pixels that it added. Useful for scroll functions.
     * 添加的像素数，用于滚动功能
     */
    int fill(android.support.v7.widget.RecyclerView.Recycler recycler, LayoutState layoutState,
            android.support.v7.widget.RecyclerView.State state, boolean stopOnFocusable) {
        // max offset we should set is mFastScroll + available
        final int start = layoutState.mAvailable;
        if (layoutState.mScrollingOffset != LayoutState.SCROLLING_OFFSET_NaN) {
            // TODO ugly bug fix. should not happen
            if (layoutState.mAvailable < 0) {
                layoutState.mScrollingOffset += layoutState.mAvailable;
            }
            //这里是回收，后面会再讨论
            recycleByLayoutState(recycler, layoutState);
        }
        int remainingSpace = layoutState.mAvailable + layoutState.mExtra;
        LayoutChunkResult layoutChunkResult = mLayoutChunkResult;
        //有剩余空间，或是有更多
        while ((layoutState.mInfinite || remainingSpace > 0) && layoutState.hasMore(state)) {
            // 重置
            layoutChunkResult.resetInternal();
            if (VERBOSE_TRACING) {
                TraceCompat.beginSection("LLM LayoutChunk");
            }
            // 执行 layout
            layoutChunk(recycler, state, layoutState, layoutChunkResult);
            if (VERBOSE_TRACING) {
                TraceCompat.endSection();
            }
            if (layoutChunkResult.mFinished) {
                break;
            }
            layoutState.mOffset += layoutChunkResult.mConsumed * layoutState.mLayoutDirection;
            /**
             * Consume the available space if:
             * * layoutChunk did not request to be ignored
             * * OR we are laying out scrap children
             * * OR we are not doing pre-layout
             */

            /*
            消耗可用空间如果
            layoutChunk 没有要求被忽略
            或 我们在布局 scrap 的 children
            或 我们没有在 pre-layout
             */
            if (!layoutChunkResult.mIgnoreConsumed || mLayoutState.mScrapList != null
                    || !state.isPreLayout()) {
                layoutState.mAvailable -= layoutChunkResult.mConsumed;
                // we keep a separate remaining space because mAvailable is important for recycling
                // 我们保留一个单独的剩余空间，因为 mAvailable 对于回收很重要
                remainingSpace -= layoutChunkResult.mConsumed;
            }

            if (layoutState.mScrollingOffset != LayoutState.SCROLLING_OFFSET_NaN) {
                layoutState.mScrollingOffset += layoutChunkResult.mConsumed;
                if (layoutState.mAvailable < 0) {
                    layoutState.mScrollingOffset += layoutState.mAvailable;
                }
                recycleByLayoutState(recycler, layoutState);
            }
            if (stopOnFocusable && layoutChunkResult.mFocusable) {
                break;
            }
        }
        if (DEBUG) {
            validateChildOrder();
        }
        return start - layoutState.mAvailable;
    }
    
## android.support.v7.widget.LinearLayoutManager#layoutChunk

    void layoutChunk(RecyclerView.Recycler recycler, RecyclerView.State state,
            LayoutState layoutState, LayoutChunkResult result) {
        View view = layoutState.next(recycler);
        if (view == null) {
            if (DEBUG && layoutState.mScrapList == null) {
                throw new RuntimeException("received null view when unexpected");
            }
            // if we are laying out views in scrap, this may return null which means there is
            // no more items to layout.
            result.mFinished = true;
            return;
        }
        LayoutParams params = (LayoutParams) view.getLayoutParams();
        if (layoutState.mScrapList == null) {
            if (mShouldReverseLayout == (layoutState.mLayoutDirection
                    == LayoutState.LAYOUT_START)) {
                addView(view);
            } else {
                addView(view, 0);
            }
        } else {
            if (mShouldReverseLayout == (layoutState.mLayoutDirection
                    == LayoutState.LAYOUT_START)) {
                addDisappearingView(view);
            } else {
                addDisappearingView(view, 0);
            }
        }
        measureChildWithMargins(view, 0, 0);
        result.mConsumed = mOrientationHelper.getDecoratedMeasurement(view);
        // Decoration 的绘制
        int left, top, right, bottom;
        if (mOrientation == VERTICAL) {
            if (isLayoutRTL()) {
                right = getWidth() - getPaddingRight();
                left = right - mOrientationHelper.getDecoratedMeasurementInOther(view);
            } else {
                left = getPaddingLeft();
                right = left + mOrientationHelper.getDecoratedMeasurementInOther(view);
            }
            if (layoutState.mLayoutDirection == LayoutState.LAYOUT_START) {
                bottom = layoutState.mOffset;
                top = layoutState.mOffset - result.mConsumed;
            } else {
                top = layoutState.mOffset;
                bottom = layoutState.mOffset + result.mConsumed;
            }
        } else {
            top = getPaddingTop();
            bottom = top + mOrientationHelper.getDecoratedMeasurementInOther(view);

            if (layoutState.mLayoutDirection == LayoutState.LAYOUT_START) {
                right = layoutState.mOffset;
                left = layoutState.mOffset - result.mConsumed;
            } else {
                left = layoutState.mOffset;
                right = layoutState.mOffset + result.mConsumed;
            }
        }
        // We calculate everything with View's bounding box (which includes decor and margins)
        // To calculate correct layout position, we subtract margins.
        layoutDecoratedWithMargins(view, left, top, right, bottom);
        if (DEBUG) {
            Log.d(TAG, "laid out child at position " + getPosition(view) + ", with l:"
                    + (left + params.leftMargin) + ", t:" + (top + params.topMargin) + ", r:"
                    + (right - params.rightMargin) + ", b:" + (bottom - params.bottomMargin));
        }
        // Consume the available space if the view is not removed OR changed
        if (params.isItemRemoved() || params.isItemChanged()) {
            result.mIgnoreConsumed = true;
        }
        result.mFocusable = view.hasFocusable();
    }

## android.support.v7.widget.LinearLayoutManager.LayoutState#next

        View next(android.support.v7.widget.RecyclerView.Recycler recycler) {
            if (mScrapList != null) {
                return nextViewFromScrapList();
            }
            final View view = recycler.getViewForPosition(mCurrentPosition);
            //方向是 1 或 -1
            mCurrentPosition += mItemDirection;
            return view;
        }
## android.support.v7.widget.RecyclerView.Recycler#getViewForPosition(int)


        /**
         * Obtain a view initialized for the given position.
         * 获取为给定位置初始化的 view
         *
         * This method should be used by {@link LayoutManager} implementations to obtain
         * views to represent data from an {@link Adapter}.
         * 该法应该由 LayoutManager 的实现用来获取一个 view，该 view 用来表示 Adapter 中的数据
         * <p>
         * The Recycler may reuse a scrap or detached view from a shared pool if one is
         * available for the correct view type. If the adapter has not indicated that the
         * data at the given position has changed, the Recycler will attempt to hand back
         * a scrap view that was previously initialized for that data without rebinding.
         *
         * Recycler 可以复用来自共享池的 scrap 或分离的视图（如果有可用于正确的 view type 的）。
         * 如果适配器未指示给定位置的数据已更改，则 Recycler 将尝试回传之前为该数据初始化的 scrap 视图，而不重新绑定。
         *
         */
        public View getViewForPosition(int position) {
            return getViewForPosition(position, false);
        }

        View getViewForPosition(int position, boolean dryRun) {
            return tryGetViewHolderForPositionByDeadline(position, dryRun, FOREVER_NS).itemView;
        }

        /**
         * Attempts to get the ViewHolder for the given position, either from the Recycler scrap,
         * cache, the RecycledViewPool, or creating it directly.
         * 尝试获取给定位置的 ViewHolder ，可能从 Recycler scrap,cache, the RecycledViewPool 获取，或直接创建
         * <p>
         * If a deadlineNs other than {@link #FOREVER_NS} is passed, this method early return
         * rather than constructing or binding a ViewHolder if it doesn't think it has time.
         * If a ViewHolder must be constructed and not enough time remains, null is returned. If a
         * ViewHolder is aquired and must be bound but not enough time remains, an unbound holder is
         * returned. Use {@link ViewHolder#isBound()} on the returned object to check for this.
         *
         * 如果传递了一个大于 FOREVER_NS 的 deadlineNs ，则如果它认为没有足够的时间，该方法会提前返回，而不会构造或绑定一个 ViewHolder
         * 如果必须构造 ViewHolder 并且没有足够的时间，则返回 null。
         * 如果 ViewHolder 已获取并且必须绑定，但剩余时间不足，则返回未绑定的 holder。
         * 在返回的对象上使用 ViewHolder#isBound 来检查这个
         */
        @Nullable
        ViewHolder tryGetViewHolderForPositionByDeadline(int position,
                boolean dryRun, long deadlineNs) {
            if (position < 0 || position >= mState.getItemCount()) {
                throw new IndexOutOfBoundsException("Invalid item position " + position
                        + "(" + position + "). Item count:" + mState.getItemCount()
                        + exceptionLabel());
            }
            boolean fromScrapOrHiddenOrCache = false;
            ViewHolder holder = null;
            // 0) If there is a changed scrap, try to find from there
            if (mState.isPreLayout()) {
                holder = getChangedScrapViewForPosition(position);
                fromScrapOrHiddenOrCache = holder != null;
            }
            // 1) Find by position from scrap/hidden list/cache
            // 通过 position 查找
            if (holder == null) {
                holder = getScrapOrHiddenOrCachedHolderForPosition(position, dryRun);
                if (holder != null) {
                    if (!validateViewHolderForOffsetPosition(holder)) {
                        // recycle holder (and unscrap if relevant) since it can't be used
                        if (!dryRun) {
                            // we would like to recycle this but need to make sure it is not used by
                            // animation logic etc.
                            holder.addFlags(ViewHolder.FLAG_INVALID);
                            if (holder.isScrap()) {
                                removeDetachedView(holder.itemView, false);
                                holder.unScrap();
                            } else if (holder.wasReturnedFromScrap()) {
                                holder.clearReturnedFromScrapFlag();
                            }
                            recycleViewHolderInternal(holder);
                        }
                        holder = null;
                    } else {
                        fromScrapOrHiddenOrCache = true;
                    }
                }
            }
            if (holder == null) {
                final int offsetPosition = mAdapterHelper.findPositionOffset(position);
                if (offsetPosition < 0 || offsetPosition >= mAdapter.getItemCount()) {
                    throw new IndexOutOfBoundsException("Inconsistency detected. Invalid item "
                            + "position " + position + "(offset:" + offsetPosition + ")."
                            + "state:" + mState.getItemCount() + exceptionLabel());
                }

                final int type = mAdapter.getItemViewType(offsetPosition);
                // 2) Find from scrap/cache via stable ids, if exists
                // 通过 id 查找
                if (mAdapter.hasStableIds()) {
                    holder = getScrapOrCachedViewForId(mAdapter.getItemId(offsetPosition),
                            type, dryRun);
                    if (holder != null) {
                        // update position
                        holder.mPosition = offsetPosition;
                        fromScrapOrHiddenOrCache = true;
                    }
                }
                if (holder == null && mViewCacheExtension != null) {
                    // We are NOT sending the offsetPosition because LayoutManager does not
                    // know it.
                    final View view = mViewCacheExtension
                            .getViewForPositionAndType(this, position, type);
                    if (view != null) {
                        holder = getChildViewHolder(view);
                        if (holder == null) {
                            throw new IllegalArgumentException("getViewForPositionAndType returned"
                                    + " a view which does not have a ViewHolder"
                                    + exceptionLabel());
                        } else if (holder.shouldIgnore()) {
                            throw new IllegalArgumentException("getViewForPositionAndType returned"
                                    + " a view that is ignored. You must call stopIgnoring before"
                                    + " returning this view." + exceptionLabel());
                        }
                    }
                }
                if (holder == null) { // fallback to pool
                    if (DEBUG) {
                        Log.d(TAG, "tryGetViewHolderForPositionByDeadline("
                                + position + ") fetching from shared pool");
                    }
                    holder = getRecycledViewPool().getRecycledView(type);
                    if (holder != null) {
                        holder.resetInternal();
                        if (FORCE_INVALIDATE_DISPLAY_LIST) {
                            invalidateDisplayListInt(holder);
                        }
                    }
                }
                if (holder == null) {
                    long start = getNanoTime();
                    if (deadlineNs != FOREVER_NS
                            && !mRecyclerPool.willCreateInTime(type, start, deadlineNs)) {
                        // abort - we have a deadline we can't meet
                        return null;
                    }
                    // 由 adapter 创建
                    holder = mAdapter.createViewHolder(RecyclerView.this, type);
                    if (ALLOW_THREAD_GAP_WORK) {
                        // only bother finding nested RV if prefetching
                        RecyclerView innerView = findNestedRecyclerView(holder.itemView);
                        if (innerView != null) {
                            holder.mNestedRecyclerView = new WeakReference<>(innerView);
                        }
                    }

                    long end = getNanoTime();
                    mRecyclerPool.factorInCreateTime(type, end - start);
                    if (DEBUG) {
                        Log.d(TAG, "tryGetViewHolderForPositionByDeadline created new ViewHolder");
                    }
                }
            }

            // This is very ugly but the only place we can grab this information
            // before the View is rebound and returned to the LayoutManager for post layout ops.
            // We don't need this in pre-layout since the VH is not updated by the LM.
            if (fromScrapOrHiddenOrCache && !mState.isPreLayout() && holder
                    .hasAnyOfTheFlags(ViewHolder.FLAG_BOUNCED_FROM_HIDDEN_LIST)) {
                holder.setFlags(0, ViewHolder.FLAG_BOUNCED_FROM_HIDDEN_LIST);
                if (mState.mRunSimpleAnimations) {
                    int changeFlags = ItemAnimator
                            .buildAdapterChangeFlagsForAnimations(holder);
                    changeFlags |= ItemAnimator.FLAG_APPEARED_IN_PRE_LAYOUT;
                    final ItemAnimator.ItemHolderInfo info = mItemAnimator.recordPreLayoutInformation(mState,
                            holder, changeFlags, holder.getUnmodifiedPayloads());
                    recordAnimationInfoIfBouncedHiddenView(holder, info);
                }
            }

            boolean bound = false;
            if (mState.isPreLayout() && holder.isBound()) {
                // do not update unless we absolutely have to.
                holder.mPreLayoutPosition = position;
            } else if (!holder.isBound() || holder.needsUpdate() || holder.isInvalid()) {
                if (DEBUG && holder.isRemoved()) {
                    throw new IllegalStateException("Removed holder should be bound and it should"
                            + " come here only in pre-layout. Holder: " + holder
                            + exceptionLabel());
                }
                final int offsetPosition = mAdapterHelper.findPositionOffset(position);
                // bind
                bound = tryBindViewHolderByDeadline(holder, offsetPosition, position, deadlineNs);
            }

            // 参数
            final ViewGroup.LayoutParams lp = holder.itemView.getLayoutParams();
            final LayoutParams rvLayoutParams;
            if (lp == null) {
                rvLayoutParams = (LayoutParams) generateDefaultLayoutParams();
                holder.itemView.setLayoutParams(rvLayoutParams);
            } else if (!checkLayoutParams(lp)) {
                rvLayoutParams = (LayoutParams) generateLayoutParams(lp);
                holder.itemView.setLayoutParams(rvLayoutParams);
            } else {
                rvLayoutParams = (LayoutParams) lp;
            }
            rvLayoutParams.mViewHolder = holder;
            rvLayoutParams.mPendingInvalidate = fromScrapOrHiddenOrCache && bound;
            return holder;
        }
## android.support.v7.widget.RecyclerView.Recycler#getScrapOrHiddenOrCachedHolderForPosition

        /**
         * Returns a view for the position either from attach scrap, hidden children, or cache.
         *
         * @param position Item position
         * @param dryRun  Does a dry run, finds the ViewHolder but does not remove
         * @return a ViewHolder that can be re-used for this position.
         */
        ViewHolder getScrapOrHiddenOrCachedHolderForPosition(int position, boolean dryRun) {
            final int scrapCount = mAttachedScrap.size();

            // Try first for an exact, non-invalid match from scrap.
            for (int i = 0; i < scrapCount; i++) {
                final ViewHolder holder = mAttachedScrap.get(i);
                if (!holder.wasReturnedFromScrap() && holder.getLayoutPosition() == position
                        && !holder.isInvalid() && (mState.mInPreLayout || !holder.isRemoved())) {
                    holder.addFlags(ViewHolder.FLAG_RETURNED_FROM_SCRAP);
                    return holder;
                }
            }

            if (!dryRun) {
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
android.support.v7.widget.ChildHelper#findHiddenNonRemovedView

    /**
     * This can be used to find a disappearing view by position.
     *
     * @param position The adapter position of the item.
     * @return         A hidden view with a valid ViewHolder that matches the position.
     */
    View findHiddenNonRemovedView(int position) {
        final int count = mHiddenViews.size();
        for (int i = 0; i < count; i++) {
            final View view = mHiddenViews.get(i);
            RecyclerView.ViewHolder holder = mCallback.getChildViewHolder(view);
            if (holder.getLayoutPosition() == position
                    && !holder.isInvalid()
                    && !holder.isRemoved()) {
                return view;
            }
        }
        return null;
    }
## android.support.v7.widget.RecyclerView.Recycler#tryBindViewHolderByDeadline

        /**
         * Attempts to bind view, and account for relevant timing information. If
         * deadlineNs != FOREVER_NS, this method may fail to bind, and return false.
         *
         * @param holder Holder to be bound.
         * @param offsetPosition Position of item to be bound.
         * @param position Pre-layout position of item to be bound.
         * @param deadlineNs Time, relative to getNanoTime(), by which bind/create work should
         *                   complete. If FOREVER_NS is passed, this method will not fail to
         *                   bind the holder.
         * @return
         */
        private boolean tryBindViewHolderByDeadline(ViewHolder holder, int offsetPosition,
                int position, long deadlineNs) {
            holder.mOwnerRecyclerView = RecyclerView.this;
            final int viewType = holder.getItemViewType();
            long startBindNs = getNanoTime();
            if (deadlineNs != FOREVER_NS
                    && !mRecyclerPool.willBindInTime(viewType, startBindNs, deadlineNs)) {
                // abort - we have a deadline we can't meet
                return false;
            }
            mAdapter.bindViewHolder(holder, offsetPosition);
            long endBindNs = getNanoTime();
            mRecyclerPool.factorInBindTime(holder.getItemViewType(), endBindNs - startBindNs);
            attachAccessibilityDelegateOnBind(holder);
            if (mState.isPreLayout()) {
                holder.mPreLayoutPosition = position;
            }
            return true;
        }
        
        /**
         * This method internally calls {@link #onBindViewHolder(ViewHolder, int)} to update the
         * {@link ViewHolder} contents with the item at the given position and also sets up some
         * private fields to be used by RecyclerView.
         *
         * @see #onBindViewHolder(ViewHolder, int)
         */
        public final void bindViewHolder(@NonNull VH holder, int position) {
            holder.mPosition = position;
            if (hasStableIds()) {
                holder.mItemId = getItemId(position);
            }
            holder.setFlags(ViewHolder.FLAG_BOUND,
                    ViewHolder.FLAG_BOUND | ViewHolder.FLAG_UPDATE | ViewHolder.FLAG_INVALID
                            | ViewHolder.FLAG_ADAPTER_POSITION_UNKNOWN);
            TraceCompat.beginSection(TRACE_BIND_VIEW_TAG);
            onBindViewHolder(holder, position, holder.getUnmodifiedPayloads());
            holder.clearPayload();
            final ViewGroup.LayoutParams layoutParams = holder.itemView.getLayoutParams();
            if (layoutParams instanceof RecyclerView.LayoutParams) {
                ((LayoutParams) layoutParams).mInsetsDirty = true;
            }
            TraceCompat.endSection();
        }
        
