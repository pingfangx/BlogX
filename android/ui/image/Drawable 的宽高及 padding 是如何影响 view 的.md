# 宽高如何影响 view
    android.view.View#onMeasure
    android.view.View#getSuggestedMinimumWidth
        protected int getSuggestedMinimumWidth() {
            return (mBackground == null) ? mMinWidth : max(mMinWidth, mBackground.getMinimumWidth());
        }
    android.graphics.drawable.Drawable#getMinimumWidth        
        public int getMinimumWidth() {
            final int intrinsicWidth = getIntrinsicWidth();
            return intrinsicWidth > 0 ? intrinsicWidth : 0;
        }
        
# android.graphics.drawable.Drawable#getPadding
发现 ShapeDrawable#setPadding

    android.graphics.drawable.ShapeDrawable#setPadding(int, int, int, int)
那它与
    
    android.view.View#setPadding
    
有什么区别呢：
    
    android.view.View#setBackgroundDrawable
        
            if (background.getPadding(padding)) {
                resetResolvedPaddingInternal();
                switch (background.getLayoutDirection()) {
                    case LAYOUT_DIRECTION_RTL:
                        mUserPaddingLeftInitial = padding.right;
                        mUserPaddingRightInitial = padding.left;
                        internalSetPadding(padding.right, padding.top, padding.left, padding.bottom);
                        break;
                    case LAYOUT_DIRECTION_LTR:
                    default:
                        mUserPaddingLeftInitial = padding.left;
                        mUserPaddingRightInitial = padding.right;
                        internalSetPadding(padding.left, padding.top, padding.right, padding.bottom);
                }
                mLeftPaddingDefined = false;
                mRightPaddingDefined = false;
            }

    可以看到调用了 internalSetPadding
    
    而 android.view.View#setPadding 也是调用的 internalSetPadding
    
    也就是说，如果 background 的 getPadding 返 true，则会重新设置 padding
    android.graphics.drawable.Drawable#getPadding
        public boolean getPadding(@NonNull Rect padding) {
            padding.set(0, 0, 0, 0);
            return false;
        }
        
        
## NinePatchDrawable
有了上面的知识点，正好可以解释，为什么 NinePatchDrawable 可以通过画线来设置内容显示区域。  
实际就是通过 padding 来实现的。

    android.graphics.drawable.NinePatchDrawable#getPadding    
        public boolean getPadding(@NonNull Rect padding) {
            if (mPadding != null) {
                padding.set(mPadding);
                return (padding.left | padding.top | padding.right | padding.bottom) != 0;
            } else {
                return super.getPadding(padding);
            }
        }
        
    android.graphics.drawable.NinePatchDrawable#computeBitmapSize
        
        final Rect sourcePadding = mNinePatchState.mPadding;
        if (sourcePadding != null) {
            if (mPadding == null) {
                mPadding = new Rect();
            }
            mPadding.left = Drawable.scaleFromDensity(
                    sourcePadding.left, sourceDensity, targetDensity, true);
            mPadding.top = Drawable.scaleFromDensity(
                    sourcePadding.top, sourceDensity, targetDensity, true);
            mPadding.right = Drawable.scaleFromDensity(
                    sourcePadding.right, sourceDensity, targetDensity, true);
            mPadding.bottom = Drawable.scaleFromDensity(
                    sourcePadding.bottom, sourceDensity, targetDensity, true);
        } else {
            mPadding = null;
        }