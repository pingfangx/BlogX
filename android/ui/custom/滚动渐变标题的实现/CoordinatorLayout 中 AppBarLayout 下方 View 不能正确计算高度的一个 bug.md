CoordinatorLayout 中 AppBarLayout 下方 View 不能正确计算高度的一个 bug  
但是始果弹起输入法，再关闭就正常了。

Layout Inspector 发现高度计算不正确。

[3CoordinatorLayout的measure和layout](https://blog.csdn.net/litefish/article/details/52327502)  
学习了高度测量之后，在 CoordinatorLayout 中，计算 child 的高度  

AppBarLayout 包围 CollapsingToolbarLayout  
AppBarLayout 下方使用 ScrollingViewBehavior 的高局的高度为  
屏幕高 - AppBarLayout 高 + CollapsingToolbarLayout 最小高度


    android.support.design.widget.HeaderScrollingViewBehavior#onMeasureChild
    
        int height = availableHeight - header.getMeasuredHeight() + this.getScrollRange(header);
        
    android.support.design.widget.AppBarLayout.ScrollingViewBehavior#getScrollRange
        int getScrollRange(View v) {
            return v instanceof AppBarLayout ? ((AppBarLayout)v).getTotalScrollRange() : super.getScrollRange(v);
        }
        
    android.support.design.widget.AppBarLayout#getTotalScrollRange
    
                range += childHeight + lp.topMargin + lp.bottomMargin;
                if ((flags & 2) != 0) {
                    range -= ViewCompat.getMinimumHeight(child);
                    break;
                }
            ...

            return this.totalScrollRange = Math.max(0, range - this.getTopInset());
            
    AppBarLayout child 为 CollapsingToolbarLayout，而 CollapsingToolbarLayout 的最小高度的设置于
    android.support.design.widget.CollapsingToolbarLayout#onLayout
    
            if (this.toolbarDirectChild != null && this.toolbarDirectChild != this) {
                this.setMinimumHeight(getHeightWithMargins(this.toolbarDirectChild));
            } else {
                this.setMinimumHeight(getHeightWithMargins(this.toolbar));
            }
    可以看到是在 onLayout 中设置的最小高度为 toolbar 的高度
    
    但是在 android.support.design.widget.HeaderScrollingViewBehavior#onMeasureChild
    测量之后，才执行的 onLayout，而 onLayout 之后没有再调用 onMeasureChild 所以高度不正确
    但是弹起输入法重新布局了，所以正常了。
    
# 解决方案
为什么没有重新调用 onMeasureChild？
为什么需要重新调用呢？  
原本使用的 layout_scrollFlags 就是 scroll|exitUntilCollapsed  
exitUntilCollapsed 就是必须设置 minHeight 的  
与其希望在 onLayout 中计算，不如布局中直接指定。    