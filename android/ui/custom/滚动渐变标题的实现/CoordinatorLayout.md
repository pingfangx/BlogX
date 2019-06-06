Q
* 相关文档
* 实现原理
* 相关软件的标题变化是否使用了 CoordinatorLayout

R
* [CoordinatorLayout 完全解析](https://www.jianshu.com/p/4a77ae4cd82f)
* [源码看CoordinatorLayout.Behavior原理](https://blog.csdn.net/qibin0506/article/details/50377592)
* [Android Design Support Library源码分析](https://blog.csdn.net/litefish/column/info/12744)

# 相关文档
尝试翻译相关文档，发现如果不实际使用，翻译是很费劲的。

# 基本使用
发现少有一些官方 sample，只好查看一些相关博文。
* behavior
* anchor
* insetEdge

# AppBarLayout 与 CoordinatorLayout
根据 AppBarLayout 的文档，需要给滚动 view 设置 app:layout_behavior  
然后给 child 设置 app:layout_scrollFlags  
相关常量位于 AppBarLayout.LayoutParams

# 相关原理
[源码看CoordinatorLayout.Behavior原理](https://blog.csdn.net/qibin0506/article/details/50377592)

# anchor 实现原理
## 为什么 Snackbar 展示时 FAB 会向上移动
虽然 FAB 设置了默认的 behavior ，
@CoordinatorLayout.DefaultBehavior(FloatingActionButton.Behavior.class)  
但是向上移动好像还没有用到 behavior  
只是用到了 android.view.ViewTreeObserver.OnPreDrawListener


    offsetTopAndBottom:3178, ViewCompat (androidx.core.view)
    setInsetOffsetY:1483, CoordinatorLayout (androidx.coordinatorlayout.widget)
    offsetChildByInset:1440, CoordinatorLayout (androidx.coordinatorlayout.widget)
    onChildViewsChanged:1335, CoordinatorLayout (androidx.coordinatorlayout.widget)
    onPreDraw:1990, CoordinatorLayout$OnPreDrawListener (androidx.coordinatorlayout.widget)
    dispatchOnPreDraw:977, ViewTreeObserver (android.view)
    
    监听是在 androidx.coordinatorlayout.widget.CoordinatorLayout#onAttachedToWindow 中设置的
    
    
    @Override
    public void onAttachedToWindow() {
        super.onAttachedToWindow();
        resetTouchBehaviors(false);
        if (mNeedsPreDrawListener) {
            if (mOnPreDrawListener == null) {
                mOnPreDrawListener = new OnPreDrawListener();
            }
            final ViewTreeObserver vto = getViewTreeObserver();
            vto.addOnPreDrawListener(mOnPreDrawListener);
        }
        if (mLastInsets == null && ViewCompat.getFitsSystemWindows(this)) {
            // We're set to fitSystemWindows but we haven't had any insets yet...
            // We should request a new dispatch of window insets
            ViewCompat.requestApplyInsets(this);
        }
        mIsAttachedToWindow = true;
    }
    
# behavior 实现原理
CoordinatorLayout 实现了 NestedScrollingParent 相关接口，在相关方法中转交给 behavior  

    如 androidx.coordinatorlayout.widget.CoordinatorLayout#onNestedScroll(android.view.View, int, int, int, int, int, int[]) 
    
        for (int i = 0; i < childCount; i++) {
            final View view = getChildAt(i);
            if (view.getVisibility() == GONE) {
                // If the child is GONE, skip...
                continue;
            }

            final LayoutParams lp = (LayoutParams) view.getLayoutParams();
            if (!lp.isNestedScrollAccepted(type)) {
                continue;
            }

            final Behavior viewBehavior = lp.getBehavior();
            if (viewBehavior != null) {

                mBehaviorConsumed[0] = 0;
                mBehaviorConsumed[1] = 0;

                viewBehavior.onNestedScroll(this, view, target, dxConsumed, dyConsumed,
                        dxUnconsumed, dyUnconsumed, type, mBehaviorConsumed);

                xConsumed = dxUnconsumed > 0 ? Math.max(xConsumed, mBehaviorConsumed[0])
                        : Math.min(xConsumed, mBehaviorConsumed[0]);
                yConsumed = dyUnconsumed > 0 ? Math.max(yConsumed, mBehaviorConsumed[1])
                        : Math.min(yConsumed, mBehaviorConsumed[1]);

                accepted = true;
            }
        }

        consumed[0] += xConsumed;
        consumed[1] += yConsumed;

        if (accepted) {
            onChildViewsChanged(EVENT_NESTED_SCROLL);
        }
        
# AppBarLayout 原理
这个有一些复杂了。
还好有前人分析过 
[Android Design Support Library源码分析](https://blog.csdn.net/litefish/column/info/12744)

    com.google.android.material.appbar.AppBarLayout.ScrollingViewBehavior
    继承自 com.google.android.material.appbar.HeaderScrollingViewBehavior
    又继承 com.google.android.material.appbar.ViewOffsetBehavior
    
    而 com.google.android.material.appbar.AppBarLayout.Behavior
    继承 com.google.android.material.appbar.AppBarLayout.BaseBehavior
    继承 com.google.android.material.appbar.HeaderBehavior
    继承 com.google.android.material.appbar.ViewOffsetBehavior
    
# CollapsingToolbarLayout 原理
[8CollapsingToolbarLayout源码分析](https://blog.csdn.net/litefish/article/details/52589146)
我们这里只关注绘制标题

    添加 dummyView
    com.google.android.material.appbar.CollapsingToolbarLayout#ensureToolbar
    com.google.android.material.appbar.CollapsingToolbarLayout#updateDummyView

      private void updateDummyView() {
        if (!collapsingTitleEnabled && dummyView != null) {
          // If we have a dummy view and we have our title disabled, remove it from its parent
          final ViewParent parent = dummyView.getParent();
          if (parent instanceof ViewGroup) {
            ((ViewGroup) parent).removeView(dummyView);
          }
        }
        if (collapsingTitleEnabled && toolbar != null) {
          if (dummyView == null) {
            dummyView = new View(getContext());
          }
          if (dummyView.getParent() == null) {
            toolbar.addView(dummyView, LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);
          }
        }
      }
      
    onLayout
    
        collapsingTextHelper.setCollapsedBounds(
            tmpRect.left + (isRtl ? toolbar.getTitleMarginEnd() : toolbar.getTitleMarginStart()),
            tmpRect.top + maxOffset + toolbar.getTitleMarginTop(),
            tmpRect.right + (isRtl ? toolbar.getTitleMarginStart() : toolbar.getTitleMarginEnd()),
            tmpRect.bottom + maxOffset - toolbar.getTitleMarginBottom());

        // Update the expanded bounds
        collapsingTextHelper.setExpandedBounds(
            isRtl ? expandedMarginEnd : expandedMarginStart,
            tmpRect.top + expandedMarginTop,
            right - left - (isRtl ? expandedMarginStart : expandedMarginEnd),
            bottom - top - expandedMarginBottom);
        // Now recalculate using the new bounds
        collapsingTextHelper.recalculate();