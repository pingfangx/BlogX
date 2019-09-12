# View
    public class View implements Drawable.Callback, KeyEvent.Callback,AccessibilityEventSource {}

View 的父类是 Object，实现了 3 个接口

# 1 Drawable.Callback
> Implement this interface if you want to create an animated drawable that extends Drawable. Upon retrieving a drawable, use setCallback(android.graphics.drawable.Drawable.Callback) to supply your implementation of the interface to the drawable; it uses this interface to schedule and execute animation changes.


        void invalidateDrawable(@NonNull Drawable who);
        void scheduleDrawable(@NonNull Drawable who, @NonNull Runnable what, long when);
        void unscheduleDrawable(@NonNull Drawable who, @NonNull Runnable what);
是用来处理动画的，之前在《调用 start 动画却不执行的问题》中有介绍过。

## 设置回调
    android.view.View#setBackgroundDrawable
    
        if (mBackground != null) {
            ...
            mBackground.setCallback(null);
            ...
        }
        
        if (background != null) {
            ...
            // Set callback last, since the view may still be initializing.
            background.setCallback(this);
            ...
        }
        
## 调用回调
    例
    android.graphics.drawable.AnimationDrawable#run
    android.graphics.drawable.AnimationDrawable#nextFrame
    android.graphics.drawable.AnimationDrawable#setFrame
    android.graphics.drawable.Drawable#scheduleSelf
    
## 回调实现
    例
    android.view.View#scheduleDrawable
    
        if (verifyDrawable(who) && what != null) {
            ...
        }
        
    android.view.View#verifyDrawable
    
    protected boolean verifyDrawable(@NonNull Drawable who) {
        // Avoid verifying the scroll bar drawable so that we don't end up in
        // an invalidation loop. This effectively prevents the scroll bar
        // drawable from triggering invalidations and scheduling runnables.
        return who == mBackground || (mForegroundInfo != null && mForegroundInfo.mDrawable == who)
                || (mDefaultFocusHighlight == who);
    }
    所以以前的遇到的问题，调用 start 动画却不执行，也只需要重写 verifyDrawable 即可
    
    @Override
    protected boolean verifyDrawable(@NonNull Drawable dr) {
        return dr == mBottomDrawable || super.verifyDrawable(dr);
    }
    
# 2 KeyEvent.Callback
用于硬件按键

    android.view.KeyEvent.Callback
        boolean onKeyDown(int keyCode, KeyEvent event);
        boolean onKeyLongPress(int keyCode, KeyEvent event);
        boolean onKeyUp(int keyCode, KeyEvent event);
        boolean onKeyMultiple(int keyCode, int count, KeyEvent event);
        
> Default implementation of KeyEvent.Callback.onKeyDown(): perform press of the view when KEYCODE_DPAD_CENTER or KEYCODE_ENTER is released, if the view is enabled and clickable.
> Key presses in software keyboards will generally NOT trigger this listener, although some may elect to do so in some situations. Do not rely on this to catch software key presses.        
    
    android.view.View#onKeyDown
    
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (KeyEvent.isConfirmKey(keyCode)) {
            ...
        }
    }
    
    public static final boolean isConfirmKey(int keyCode) {
        switch (keyCode) {
            case KeyEvent.KEYCODE_DPAD_CENTER:
            case KeyEvent.KEYCODE_ENTER:
            case KeyEvent.KEYCODE_SPACE:
            case KeyEvent.KEYCODE_NUMPAD_ENTER:
                return true;
            default:
                return false;
        }
    }
# 3 android.view.accessibility.AccessibilityEventSource
用于无障碍功能

    public void sendAccessibilityEvent(int eventType);
    public void sendAccessibilityEventUnchecked(AccessibilityEvent event);
