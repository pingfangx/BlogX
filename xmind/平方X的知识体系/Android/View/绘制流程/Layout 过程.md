[Android应用程序窗口（Activity）的测量（Measure）、布局（Layout）和绘制（Draw）过程分析 - 老罗的Android之旅 - CSDN博客](https://blog.csdn.net/luoshengyang/article/details/8372924)

    android.view.View#layout
    android.view.View#setFrame
    android.view.View#invalidate(boolean)
                p.invalidateChild(this, damage);
    android.view.ViewParent#invalidateChild
    android.view.ViewRootImpl#invalidateChild
    android.view.ViewRootImpl#invalidateChildInParent
    
    @Override
    public ViewParent invalidateChildInParent(int[] location, Rect dirty) {
        checkThread();
        if (DEBUG_DRAW) Log.v(mTag, "Invalidate child: " + dirty);

        if (dirty == null) {
            invalidate();
            return null;
        } else if (dirty.isEmpty() && !mIsAnimating) {
            return null;
        }

        if (mCurScrollY != 0 || mTranslator != null) {
            mTempRect.set(dirty);
            dirty = mTempRect;
            if (mCurScrollY != 0) {
                dirty.offset(0, -mCurScrollY);
            }
            if (mTranslator != null) {
                mTranslator.translateRectInAppWindowToScreen(dirty);
            }
            if (mAttachInfo.mScalingRequired) {
                dirty.inset(-1, -1);
            }
        }

        invalidateRectOnScreen(dirty);

        return null;
    }
    //检查线程
    android.view.ViewRootImpl#checkThread
    
    void checkThread() {
        if (mThread != Thread.currentThread()) {
            throw new CalledFromWrongThreadException(
                    "Only the original thread that created a view hierarchy can touch its views.");
        }
    }
    android.view.ViewRootImpl#invalidate
    android.view.ViewRootImpl#scheduleTraversals