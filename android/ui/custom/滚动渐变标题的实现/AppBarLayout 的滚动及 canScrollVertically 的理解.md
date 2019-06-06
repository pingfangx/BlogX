可以直接在 AppBarLayout 上拉下拉滚动。

# AppBarLayout 上的事件接截
[4AppBarLayout滑动原理](https://blog.csdn.net/litefish/article/details/52588235)

    android.support.design.widget.CoordinatorLayout#onInterceptTouchEvent
    android.support.design.widget.CoordinatorLayout#onTouchEvent
    AppBarLayout 使用的 behavior 返回 true
    android.support.design.widget.HeaderBehavior#onTouchEvent
    
      case MotionEvent.ACTION_DOWN:
        {
          final int x = (int) ev.getX();
          final int y = (int) ev.getY();

          if (parent.isPointInChildBounds(child, x, y) && canDragView(child)) {
            lastMotionY = y;
            activePointerId = ev.getPointerId(0);
            ensureVelocityTracker();
          } else {
            return false;
          }
          break;
        }
        
    canDragView 返回 true
    com.google.android.material.appbar.AppBarLayout.BaseBehavior#canDragView
    
    @Override
    boolean canDragView(T view) {
      if (onDragCallback != null) {
        // If there is a drag callback set, it's in control
        return onDragCallback.canDrag(view);
      }

      // Else we'll use the default behaviour of seeing if it can scroll down
      if (lastNestedScrollingChildRef != null) {
        // If we have a reference to a scrolling view, check it
        final View scrollingView = lastNestedScrollingChildRef.get();
        return scrollingView != null
            && scrollingView.isShown()
            && !scrollingView.canScrollVertically(-1);
      } else {
        // Otherwise we assume that the scrolling view hasn't been scrolled and can drag.
        return true;
      }
    }

    scrollingView.canScrollVertically(-1) 返回 false
    android.view.View#canScrollVertically
    
    /**
     * Check if this view can be scrolled vertically in a certain direction.
     *
     * @param direction Negative to check scrolling up, positive to check scrolling down.
     * @return true if this view can be scrolled in the specified direction, false otherwise.
     */
    public boolean canScrollVertically(int direction) {
        final int offset = computeVerticalScrollOffset();
        final int range = computeVerticalScrollRange() - computeVerticalScrollExtent();
        if (range == 0) return false;
        if (direction < 0) {
            return offset > 0;
        } else {
            return offset < range - 1;
        }
    }
## canScrollVertically 的理解
[RecyclerView的canScrollVertically方法踩坑](https://blog.csdn.net/xingchenxuanfeng/article/details/84790299)
> 然而实际上，我把传入的direction设为负值，才是判断手指能否向下滑动，正值是判断手指能否向上滑动。不知道是不是作者对这个“滚动”的对象或者坐标系跟我理解的不同，总之，在我看来，这个注释和代码效果是完全相反的。

确实不太好理解，但是我们看判断方式。


        if (direction < 0) {
            return offset > 0;
        }
        
考虑到相关方法都是与 scrollBar 相关的，我们可以假设作者的意思是。
负值表示（滚动条）是否可以向上滚动，所以判断的也是判断 offset > 0

因此总结起来，如果 scrollingView 的滚动条可以向上滚动，也就是 scrollingView 可以向下滚动的时候，AppBarLayout 是不可以拦截 onTouchEvent 的。