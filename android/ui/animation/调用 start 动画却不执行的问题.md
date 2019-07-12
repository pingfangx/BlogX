# 调用 start 后不启动

调用了 android.graphics.drawable.Animatable#start() 之后，发现动画并没有执行，且一直是 running 状态  
只需要重写 View#verifyDrawable 就可以了
    

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
    发现需要 callback
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

# 重复调用 start 无效

start 后回调 run
    
    android.graphics.drawable.AnimationDrawable#run
    
    public void run() {
        nextFrame(false);
    }
    android.graphics.drawable.AnimationDrawable#nextFrame
    private void nextFrame(boolean unschedule) {
        int nextFrame = mCurFrame + 1;
        final int numFrames = mAnimationState.getChildCount();
        // isLastFrame 会被赋值
        final boolean isLastFrame = mAnimationState.mOneShot && nextFrame >= (numFrames - 1);

        // Loop if necessary. One-shot animations should never hit this case.
        if (!mAnimationState.mOneShot && nextFrame >= numFrames) {
            nextFrame = 0;
        }

        setFrame(nextFrame, unschedule, !isLastFrame);
    }
    private void setFrame(int frame, boolean unschedule, boolean animate) {
        if (frame >= mAnimationState.getChildCount()) {
            return;
        }
        mAnimating = animate;
        mCurFrame = frame;
        selectDrawable(frame);
        if (unschedule || animate) {
            unscheduleSelf(this);
        }
        //最后一帧不动画，停止
        if (animate) {
            // Unscheduling may have clobbered these values; restore them
            mCurFrame = frame;
            mRunning = true;
            scheduleSelf(this, SystemClock.uptimeMillis() + mAnimationState.mDurations[frame]);
        }
    }
    
可以看到会停止，但是没有主动调用 stop ，所以改为在 start 前手动调用 stop