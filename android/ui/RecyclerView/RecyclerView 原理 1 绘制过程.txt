最后转到了

        mLayout.onLayoutChildren(mRecycler, mState);

## android.support.v7.widget.RecyclerView#onMeasure

    protected void onMeasure(int widthSpec, int heightSpec) {
        if (mLayout == null) {
            defaultOnMeasure(widthSpec, heightSpec);
            return;
        }
        if (mLayout.isAutoMeasureEnabled()) {
            ...
            mLayout.onMeasure(mRecycler, mState, widthSpec, heightSpec);

            final boolean measureSpecModeIsExactly =
                    widthMode == MeasureSpec.EXACTLY && heightMode == MeasureSpec.EXACTLY;
            if (measureSpecModeIsExactly || mAdapter == null) {
                return;
            }

            if (mState.mLayoutStep == State.STEP_START) {
                dispatchLayoutStep1();
            }
            // set dimensions in 2nd step. Pre-layout should happen with old dimensions for
            // consistency
            mLayout.setMeasureSpecs(widthSpec, heightSpec);
            mState.mIsMeasuring = true;
            dispatchLayoutStep2();

            // now we can get the width and height from the children.
            mLayout.setMeasuredDimensionFromChildren(widthSpec, heightSpec);

            // if RecyclerView has non-exact width and height and if there is at least one child
            // which also has non-exact width & height, we have to re-measure.
            if (mLayout.shouldMeasureTwice()) {
                mLayout.setMeasureSpecs(
                        MeasureSpec.makeMeasureSpec(getMeasuredWidth(), MeasureSpec.EXACTLY),
                        MeasureSpec.makeMeasureSpec(getMeasuredHeight(), MeasureSpec.EXACTLY));
                mState.mIsMeasuring = true;
                dispatchLayoutStep2();
                // now we can get the width and height from the children.
                mLayout.setMeasuredDimensionFromChildren(widthSpec, heightSpec);
            }
        } else {
            ...
        }
    }
## android.support.v7.widget.RecyclerView#onLayout

    protected void onLayout(boolean changed, int l, int t, int r, int b) {
        TraceCompat.beginSection(TRACE_ON_LAYOUT_TAG);
        dispatchLayout();
        TraceCompat.endSection();
        mFirstLayoutComplete = true;
    }
    
    /**
     * Wrapper around layoutChildren() that handles animating changes caused by layout.
     * 包装 layoutChildren() 处理由 layout 引起的动画更改
     *
     * Animations work on the assumption that there are five different kinds of items
     * in play:
     * 动画假设有5 种不同的 item
     *
     * PERSISTENT: items are visible before and after layout
     * layout 前后可见
     *
     * REMOVED: items were visible before layout and were removed by the app
     * layout 前可见，然后补移除
     *
     * ADDED: items did not exist before layout and were added by the app
     * layout 前不存在，然后被添加
     *
     * DISAPPEARING: items exist in the data set before/after, but changed from
     * visible to non-visible in the process of layout (they were moved off
     * screen as a side-effect of other changes)
     * 在前后都存在于数据集中，但在 layout 过程中由可见变为不可见（由于其他改变被移出屏幕）
     *
     * APPEARING: items exist in the data set before/after, but changed from
     * non-visible to visible in the process of layout (they were moved on
     * screen as a side-effect of other changes)
     * 在前后都存在于数据集中，但在 layout 过程中由不可见变为可见（由于其他改变被移入屏幕）
     *
     * The overall approach figures out what items exist before/after layout and
     * infers one of the five above states for each of the items. Then the animations
     * are set up accordingly:
     * 整个过程会求出 item 在 layout 前后是否可见，然后推断出每个 item 是上述哪一种状态。
     *
     * PERSISTENT views are animated via
     * {@link ItemAnimator#animatePersistence(ViewHolder, ItemAnimator.ItemHolderInfo, ItemAnimator.ItemHolderInfo)}
     * DISAPPEARING views are animated via
     * {@link ItemAnimator#animateDisappearance(ViewHolder, ItemAnimator.ItemHolderInfo, ItemAnimator.ItemHolderInfo)}
     * APPEARING views are animated via
     * {@link ItemAnimator#animateAppearance(ViewHolder, ItemAnimator.ItemHolderInfo, ItemAnimator.ItemHolderInfo)}
     * and changed views are animated via
     * {@link ItemAnimator#animateChange(ViewHolder, ViewHolder, ItemAnimator.ItemHolderInfo, ItemAnimator.ItemHolderInfo)}.
     */
    void dispatchLayout() {
        if (mAdapter == null) {
            Log.e(TAG, "No adapter attached; skipping layout");
            // leave the state in START
            return;
        }
        if (mLayout == null) {
            Log.e(TAG, "No layout manager attached; skipping layout");
            // leave the state in START
            return;
        }
        mState.mIsMeasuring = false;
        if (mState.mLayoutStep == State.STEP_START) {
            dispatchLayoutStep1();
            mLayout.setExactMeasureSpecsFrom(this);
            dispatchLayoutStep2();
        } else if (mAdapterHelper.hasUpdates() || mLayout.getWidth() != getWidth()
                || mLayout.getHeight() != getHeight()) {
            // First 2 steps are done in onMeasure but looks like we have to run again due to
            // changed size.
            mLayout.setExactMeasureSpecsFrom(this);
            dispatchLayoutStep2();
        } else {
            // always make sure we sync them (to ensure mode is exact)
            mLayout.setExactMeasureSpecsFrom(this);
        }
        dispatchLayoutStep3();
    }
    
分为了 3 步，依次查看

    /**
     * The first step of a layout where we;
     * layout 的第一步
     *
     * - process adapter updates
     * 处理适配器更新
     *
     * - decide which animation should run
     * 决定要运行的动画
     *
     * - save information about current views
     * 保存当前 views 的信息
     * 
     * - If necessary, run predictive layout and save its information
     * 如果必要,运行 predictive layout 并保存信息
     */
    private void dispatchLayoutStep1() {}
    
    
    /**
     * The second layout step where we do the actual layout of the views for the final state.
     * 第二个布局步骤，我们为最终状态进行视图的实际布局。
     * 
     * This step might be run multiple times if necessary (e.g. measure).
     * 如果需要，此步骤可能会多次运行 (如 measure)
     */
    private void dispatchLayoutStep2() {
        eatRequestLayout();
        onEnterLayoutOrScroll();
        mState.assertLayoutStep(State.STEP_LAYOUT | State.STEP_ANIMATIONS);
        mAdapterHelper.consumeUpdatesInOnePass();
        mState.mItemCount = mAdapter.getItemCount();
        mState.mDeletedInvisibleItemCountSincePreviousLayout = 0;

        // Step 2: Run layout
        mState.mInPreLayout = false;
        mLayout.onLayoutChildren(mRecycler, mState);

        mState.mStructureChanged = false;
        mPendingSavedState = null;

        // onLayoutChildren may have caused client code to disable item animations; re-check
        mState.mRunSimpleAnimations = mState.mRunSimpleAnimations && mItemAnimator != null;
        mState.mLayoutStep = State.STEP_ANIMATIONS;
        onExitLayoutOrScroll();
        resumeRequestLayout(false);
    }
    
    
    /**
     * The final step of the layout where we save the information about views for animations,
     * trigger animations and do any necessary cleanup.
     * 布局的最后一步，我们保存有关动画 views 的信息，触发动画并做任何必要的清理。
     */
    private void dispatchLayoutStep3() {}
    
## RecyclerView#onDraw

    @Override
    public void onDraw(Canvas c) {
        super.onDraw(c);

        final int count = mItemDecorations.size();
        for (int i = 0; i < count; i++) {
            mItemDecorations.get(i).onDraw(c, this, mState);
        }
    }

         *      1. Draw the background
         *      2. If necessary, save the canvas' layers to prepare for fading
         *      3. Draw view's content
         *      4. Draw children
         *      5. If necessary, draw the fading edges and restore layers
         *      6. Draw decorations (scrollbars for instance)
    由 android.view.ViewGroup#dispatchDraw 转到 android.support.v7.widget.RecyclerView#drawChild
    
# 从 setAdapter 看起

    public void setAdapter(Adapter adapter) {
        // bail out if layout is frozen
        setLayoutFrozen(false);
        setAdapterInternal(adapter, false, true);
        processDataSetCompletelyChanged(false);
        requestLayout();
    }
    private void setAdapterInternal(Adapter adapter, boolean compatibleWithPrevious,
            boolean removeAndRecycleViews) {
        if (mAdapter != null) {
            mAdapter.unregisterAdapterDataObserver(mObserver);
            mAdapter.onDetachedFromRecyclerView(this);
        }
        if (!compatibleWithPrevious || removeAndRecycleViews) {
            removeAndRecycleViews();
        }
        mAdapterHelper.reset();
        final Adapter oldAdapter = mAdapter;
        mAdapter = adapter;
        if (adapter != null) {
            adapter.registerAdapterDataObserver(mObserver);
            adapter.onAttachedToRecyclerView(this);
        }
        if (mLayout != null) {
            mLayout.onAdapterChanged(oldAdapter, mAdapter);
        }
        mRecycler.onAdapterChanged(oldAdapter, mAdapter, compatibleWithPrevious);
        mState.mStructureChanged = true;
    }
    
    
    private final RecyclerViewDataObserver mObserver = new RecyclerViewDataObserver();
    android.support.v7.widget.RecyclerView.RecyclerViewDataObserver#onChanged
        public void onChanged() {
            assertNotInLayoutOrScroll(null);
            mState.mStructureChanged = true;

            processDataSetCompletelyChanged(true);
            if (!mAdapterHelper.hasPendingUpdates()) {
                requestLayout();
            }
        }
    
    
    android.support.v7.widget.RecyclerView.Adapter#notifyDataSetChanged
        public final void notifyDataSetChanged() {
            mObservable.notifyChanged();
        }