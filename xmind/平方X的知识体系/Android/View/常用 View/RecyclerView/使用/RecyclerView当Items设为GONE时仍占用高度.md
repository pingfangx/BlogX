# RecyclerView当Items设为GONE时仍占用高度
为RecyclerView添加了Header，然后设为了GONE，但是仍占用高度。

查询了  
(https://stackoverflow.com/questions/12302172/setvisibilitygone-view-becomes-invisible-but-still-occupies-space)  
(https://stackoverflow.com/questions/27574805/hiding-views-in-recyclerview)  

也就是说我们应该将其removew，而不是设为GONE，那为什么设为GONE仍然生效呢？

根据之前读的RecyclerView绘制
```
    //android.support.v7.widget.LinearLayoutManager#layoutChunk
    //android.support.v7.widget.RecyclerView.LayoutManager#measureChildWithMargins
        public void measureChildWithMargins(View child, int widthUsed, int heightUsed) {
            ...
            child.measure(widthSpec, heightSpec);
        }
    //android.view.View#measure
    //android.view.View#onMeasure
    //我们看一下LinearLayout的
    //android.widget.LinearLayout#onMeasure
    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        if (mOrientation == VERTICAL) {
            measureVertical(widthMeasureSpec, heightMeasureSpec);
        } else {
            measureHorizontal(widthMeasureSpec, heightMeasureSpec);
        }
    }
    
    //android.widget.LinearLayout#measureVertical
    void measureVertical(int widthMeasureSpec, int heightMeasureSpec) {
        ...

        if (useLargestChild &&
                (heightMode == MeasureSpec.AT_MOST || heightMode == MeasureSpec.UNSPECIFIED)) {
            mTotalLength = 0;

            for (int i = 0; i < count; ++i) {
                final View child = getVirtualChildAt(i);

                if (child == null) {
                    mTotalLength += measureNullChild(i);
                    continue;
                }

                if (child.getVisibility() == GONE) {
                    i += getChildrenSkipCount(child, i);
                    continue;
                }

                final LinearLayout.LayoutParams lp = (LinearLayout.LayoutParams)
                        child.getLayoutParams();
                // Account for negative margins
                final int totalLength = mTotalLength;
                mTotalLength = Math.max(totalLength, totalLength + largestChildHeight +
                        lp.topMargin + lp.bottomMargin + getNextLocationOffset(child));
            }
        }

        // Add in our padding
        mTotalLength += mPaddingTop + mPaddingBottom;

        int heightSize = mTotalLength;

        // Check against our minimum height
        heightSize = Math.max(heightSize, getSuggestedMinimumHeight());
        
        // Reconcile our calculated size with the heightMeasureSpec
        int heightSizeAndState = resolveSizeAndState(heightSize, heightMeasureSpec, 0);
        heightSize = heightSizeAndState & MEASURED_SIZE_MASK;
        ...
     }
     
```
估计：
我们看到在LinearLayout中，计算高度会判断child是否是GONE，而LayoutManager中则是直接去掉measure了，所以估计会仍然有高度。

最后改为设置高度的LayoutParams
