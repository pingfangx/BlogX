
# 0x04 Decoration
实现 ItemDecoration 可重写 3 个方法（原来不带 state 的 3 个方法弃用）
* 3 个方法分别用来做什么的
* 3 个方法什么时候调用
* state 用来做什么的
## 3 个方法分别用来做什么的
### onDraw
> Draw any appropriate decorations into the Canvas supplied to the RecyclerView. Any content drawn by this method will be drawn before the item views are drawn, and will thus appear underneath the views.

### onDrawOver
> Draw any appropriate decorations into the Canvas supplied to the RecyclerView. Any content drawn by this method will be drawn after the item views are drawn and will thus appear over the views.

### getItemOffsets
> Retrieve any offsets for the given item. Each field of outRect specifies the number of pixels that the item view should be inset by, similar to padding or margin. The default implementation sets the bounds of outRect to 0 and returns.
If this ItemDecoration does not affect the positioning of item views, it should set all four fields of outRect (left, top, right, bottom) to zero before returning.
If you need to access Adapter for additional data, you can call getChildAdapterPosition(View) to get the adapter position of the View.

## 3 个方法什么时候调用
可以看到 onDraw 和 onDrawOver 分别在 item 之下和之上，而它的绘制逻辑为

    @Override
    public void onDraw(Canvas c) {
        super.onDraw(c);

        final int count = mItemDecorations.size();
        for (int i = 0; i < count; i++) {
            mItemDecorations.get(i).onDraw(c, this, mState);
        }
    }
    @Override
    public void draw(Canvas c) {
        super.draw(c);

        final int count = mItemDecorations.size();
        for (int i = 0; i < count; i++) {
            mItemDecorations.get(i).onDrawOver(c, this, mState);
        }
        ...
    }

    parent 先调 onDraw ，再调 drawChild ，所以先调用 Decoration 的 onDraw 再调 onDrawOver
            // Step 3, draw the content
            if (!dirtyOpaque) onDraw(canvas);

            // Step 4, draw the children
            dispatchDraw(canvas);

下面的分析可以看到 item 的绘制是预留了 decorations 的空间
### item 在 layoutChunk 中求上下左右的过程
        ...
        // 此处的测量中会调用 getItemDecorInsetsForChild，进而调用 getItemOffsets
        measureChildWithMargins(view, 0, 0);
        ...
            if (isLayoutRTL()) {
                right = getWidth() - getPaddingRight();
                left = right - mOrientationHelper.getDecoratedMeasurementInOther(view);
            } else {
                // 求 left
                left = getPaddingLeft();
                // 求 right = left 加上占用宽度
                right = left + mOrientationHelper.getDecoratedMeasurementInOther(view);
            }
            if (layoutState.mLayoutDirection == LayoutState.LAYOUT_START) {
                bottom = layoutState.mOffset;
                top = layoutState.mOffset - result.mConsumed;
            } else {
                // 求 top = offset
                top = layoutState.mOffset;
                // 求 bottom = top + 占用高度
                bottom = layoutState.mOffset + result.mConsumed;
            }
            ...
            
        // 我们用 View 的边框（包括装饰和边距）计算了所有，
        // 要计算正确的布局位置，我们减去边距。
        layoutDecoratedWithMargins(view, left, top, right, bottom);
其中求占用宽度

            // 以 perpendicular 方向返回此视图占用的空间，包括decorations and margins
            public int getDecoratedMeasurementInOther(View view) {
                final RecyclerView.LayoutParams params = (RecyclerView.LayoutParams)
                        view.getLayoutParams();
                return mLayoutManager.getDecoratedMeasuredWidth(view) + params.leftMargin
                        + params.rightMargin;
            }
            
        /**
         * 返回给定 child 的测量宽度，加上 ItemDecoration 应用的任何 insets 的额外尺寸。
         */
        public int getDecoratedMeasuredWidth(View child) {
            final Rect insets = ((LayoutParams) child.getLayoutParams()).mDecorInsets;
            return child.getMeasuredWidth() + insets.left + insets.right;
        }
        
### layout 
android.support.v7.widget.RecyclerView.LayoutManager#layoutDecoratedWithMargins

        public void layoutDecoratedWithMargins(View child, int left, int top, int right,
                int bottom) {
            final LayoutParams lp = (LayoutParams) child.getLayoutParams();
            final Rect insets = lp.mDecorInsets;
            child.layout(left + insets.left + lp.leftMargin, top + insets.top + lp.topMargin,
                    right - insets.right - lp.rightMargin,
                    bottom - insets.bottom - lp.bottomMargin);
        }
        

# 0x05 动画
DefaultItemAnimator 继承自 SimpleItemAnimator，又继承 ItemAnimator

# 0x06 监听
    RecyclerView.ChildDrawingOrderCallback
        onGetChildDrawingOrder(int childCount, int i)
    RecyclerView.OnChildAttachStateChangeListener
        onChildViewAttachedToWindow(View view)
        onChildViewDetachedFromWindow(View view)
    RecyclerView.OnItemTouchListener
        onInterceptTouchEvent(RecyclerView rv, MotionEvent e)
        onRequestDisallowInterceptTouchEvent(boolean disallowIntercept)
        onTouchEvent(RecyclerView rv, MotionEvent e)
    RecyclerView.RecyclerListener
        onViewRecycled(RecyclerView.ViewHolder holder)
    
Q

## inflate 是一个耗时操作，能不能直接复制相同的 item
因为同一屏幕内显示多个，所以才多次创建，如果滑出屏幕就会复用。  