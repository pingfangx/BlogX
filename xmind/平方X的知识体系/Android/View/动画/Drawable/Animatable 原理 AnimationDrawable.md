S:
* 调用 start 会调用回调的 scheduleDrawable，而回调是 View，在 verifyDrawable 中校验 Drawable 后会调用 invalidate
* Callback 的注册在 setBackgroundDrawable 中
* 如果自定义 Drawable，如果不调用 setBackgroundDrawable 则需要手动调用 setCallback 和重定 verifyDrawable
# start 流程

    android.graphics.drawable.AnimationDrawable#start
    
    @Override
    public void start() {
        mAnimating = true;
    
        //判断是否在运行
        if (!isRunning()) {
            // Start from 0th frame.
            setFrame(0, false, mAnimationState.getChildCount() > 1
                    || !mAnimationState.mOneShot);
        }
    }
    android.graphics.drawable.AnimationDrawable#setFrame
    android.graphics.drawable.Drawable#scheduleSelf
    
    public void scheduleSelf(@NonNull Runnable what, long when) {
        final Callback callback = getCallback();
        if (callback != null) {
            callback.scheduleDrawable(this, what, when);
        }
    }
    callback 是 view
# android.graphics.drawable.Drawable.Callback
    
    正常的 callback 设置于
    android.view.View#setBackgroundDrawable
    
            background.setCallback(this);
    可以看到 View 实现了 android.graphics.drawable.Drawable.Callback
    android.graphics.drawable.Drawable.Callback#invalidateDrawable
    android.graphics.drawable.Drawable.Callback#scheduleDrawable
    android.graphics.drawable.Drawable.Callback#unscheduleDrawable
    
    android.view.View#invalidateDrawable
    public void invalidateDrawable(@NonNull Drawable drawable) {
        if (verifyDrawable(drawable)) {
            final Rect dirty = drawable.getDirtyBounds();
            final int scrollX = mScrollX;
            final int scrollY = mScrollY;
    
            invalidate(dirty.left + scrollX, dirty.top + scrollY,
                    dirty.right + scrollX, dirty.bottom + scrollY);
            rebuildOutline();
        }
    }
    android.view.View#verifyDrawable
    protected boolean verifyDrawable(@NonNull Drawable who) {
        // Avoid verifying the scroll bar drawable so that we don't end up in
        // an invalidation loop. This effectively prevents the scroll bar
        // drawable from triggering invalidations and scheduling runnables.
        return who == mBackground || (mForegroundInfo != null && mForegroundInfo.mDrawable == who)
                || (mDefaultFocusHighlight == who);
    }
