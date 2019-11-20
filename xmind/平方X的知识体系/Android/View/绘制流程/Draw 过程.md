[Android应用程序窗口（Activity）的测量（Measure）、布局（Layout）和绘制（Draw）过程分析 - 老罗的Android之旅 - CSDN博客](https://blog.csdn.net/luoshengyang/article/details/8372924)

# 1 绘制背景

        if (!dirtyOpaque) {
            drawBackground(canvas);
        }
    private void drawBackground(Canvas canvas) {
        final Drawable background = mBackground;
        if (background == null) {
            return;
        }

        setBackgroundBounds();

        // Attempt to use a display list if requested.
        if (canvas.isHardwareAccelerated() && mAttachInfo != null
                && mAttachInfo.mThreadedRenderer != null) {
            mBackgroundRenderNode = getDrawableRenderNode(background, mBackgroundRenderNode);

            final RenderNode renderNode = mBackgroundRenderNode;
            if (renderNode != null && renderNode.isValid()) {
                setBackgroundRenderNodeProperties(renderNode);
                ((DisplayListCanvas) canvas).drawRenderNode(renderNode);
                return;
            }
        }

        final int scrollX = mScrollX;
        final int scrollY = mScrollY;
        if ((scrollX | scrollY) == 0) {
            background.draw(canvas);
        } else {
            canvas.translate(scrollX, scrollY);
            background.draw(canvas);
            canvas.translate(-scrollX, -scrollY);
        }
    }
    
    
# 2 保存画布层
保存当前画布的堆栈状态，并且在在当前画布上创建额外的图层，以便接下来可以用来绘制当前视图在滑动时的边框渐变效果。

# 3 绘制内容

        if (!dirtyOpaque) onDraw(canvas);
        
# 4 绘制子 View

        dispatchDraw(canvas);
# 5 绘制渐变效果并恢复画布层

# 6 绘制前景

        onDrawForeground(canvas);
    android.view.View#onDrawForeground
    public void onDrawForeground(Canvas canvas) {
        onDrawScrollIndicators(canvas);
        onDrawScrollBars(canvas);

        final Drawable foreground = mForegroundInfo != null ? mForegroundInfo.mDrawable : null;
        if (foreground != null) {
            if (mForegroundInfo.mBoundsChanged) {
                mForegroundInfo.mBoundsChanged = false;
                final Rect selfBounds = mForegroundInfo.mSelfBounds;
                final Rect overlayBounds = mForegroundInfo.mOverlayBounds;

                if (mForegroundInfo.mInsidePadding) {
                    selfBounds.set(0, 0, getWidth(), getHeight());
                } else {
                    selfBounds.set(getPaddingLeft(), getPaddingTop(),
                            getWidth() - getPaddingRight(), getHeight() - getPaddingBottom());
                }

                final int ld = getLayoutDirection();
                Gravity.apply(mForegroundInfo.mGravity, foreground.getIntrinsicWidth(),
                        foreground.getIntrinsicHeight(), selfBounds, overlayBounds, ld);
                foreground.setBounds(overlayBounds);
            }

            foreground.draw(canvas);
        }
    }