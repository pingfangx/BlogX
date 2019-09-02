# 长按事件与 ClickableSpan 的点击都会触发
## ClickableSpan 点击的触发过程
    onTouchEvent:231, LinkMovementMethod (android.text.method)
    onTouchEvent:10089, TextView (android.widget)
    dispatchTouchEvent:12513, View (android.view)
    dispatchTransformedTouchEvent:3030, ViewGroup (android.view)
    dispatchTouchEvent:2719, ViewGroup (android.view)

    
## 长按的触发过程
    private CheckForLongPress mPendingCheckForLongPress;
    private CheckForTap mPendingCheckForTap = null;
    android.view.View#onTouchEvent
        
        if (isInScrollingContainer) {
            mPrivateFlags |= PFLAG_PREPRESSED;
            if (mPendingCheckForTap == null) {
                mPendingCheckForTap = new CheckForTap();
            }
            mPendingCheckForTap.x = event.getX();
            mPendingCheckForTap.y = event.getY();
            postDelayed(mPendingCheckForTap, ViewConfiguration.getTapTimeout());
        } else {
            // Not inside a scrolling container, so show the feedback right away
            setPressed(true, x, y);
            checkForLongClick(0, x, y);
        }
    转到 CheckForTap
    android.view.View.CheckForTap#run
        @Override
        public void run() {
            mPrivateFlags &= ~PFLAG_PREPRESSED;
            setPressed(true, x, y);
            checkForLongClick(ViewConfiguration.getTapTimeout(), x, y);
        }
    android.view.View#checkForLongClick
        postDelayed(mPendingCheckForLongPress,
                ViewConfiguration.getLongPressTimeout() - delayOffset);
                
    android.view.View.CheckForLongPress#run
    
        public void run() {
            if ((mOriginalPressedState == isPressed()) && (mParent != null)
                    && mOriginalWindowAttachCount == mWindowAttachCount) {
                if (performLongClick(mX, mY)) {
                    mHasPerformedLongPress = true;
                }
            }
        }
    android.view.View#performLongClick(float, float)
    android.widget.TextView#performLongClick
## 点击事件的触发
    android.view.View#onTouchEvent
    
        if (mPerformClick == null) {
            mPerformClick = new PerformClick();
        }
        if (!post(mPerformClick)) {
            performClickInternal();
        }
    
    private PerformClick mPerformClick;
    
    private final class PerformClick implements Runnable {
        @Override
        public void run() {
            performClickInternal();
        }
    }
    private boolean performClickInternal() {
        // Must notify autofill manager before performing the click actions to avoid scenarios where
        // the app has a click listener that changes the state of views the autofill service might
        // be interested on.
        notifyAutofillManagerOnClick();

        return performClick();
    }
    
# 如果同时设置 OnClickListener 和 ClickableSpan 两者都会触发    
    点击事件的分发
    onTouchEvent:13787, View (android.view)
    onTouchEvent:10064, TextView (android.widget)
    dispatchTouchEvent:12513, View (android.view)
    dispatchTransformedTouchEvent:3030, ViewGroup (android.view)
    
    ClickableSpan 点击事件的分发
    onTouchEvent:231, LinkMovementMethod (android.text.method)
    onTouchEvent:10089, TextView (android.widget)
    dispatchTouchEvent:12513, View (android.view)
    dispatchTransformedTouchEvent:3030, ViewGroup (android.view)
    
    在 android.widget.TextView#onTouchEvent 中
        ...
        
        final boolean superResult = super.onTouchEvent(event);
        ...
        if ((mMovement != null || onCheckIsTextEditor()) && isEnabled()
                && mText instanceof Spannable && mLayout != null) {
            boolean handled = false;

            if (mMovement != null) {
                handled |= mMovement.onTouchEvent(this, mSpannable, event);
            }
    于是两者都触发了
# 同时设置 OnClickListener 和 ClickableSpan，如果跳转了，则只触发 ClickableSpan
    搜索 mPerformClick 下断
    removePerformClickCallback:13909, View (android.view)
    onCancelPendingInputEvents:18484, View (android.view)
    dispatchCancelPendingInputEvents:18465, View (android.view)
    dispatchCancelPendingInputEvents:4494, ViewGroup (android.view)
    cancelPendingInputEvents:18456, View (android.view)
    cancelInputsAndStartExitTransition:4626, Activity (android.app)
    startActivityForResult:4605, Activity (android.app)
    
    可见是跳转的时候移除了点击事件的执行
    
# 长按之后不会再触发点击事件
    android.view.View.CheckForLongPress#run    
    
        public void run() {
            if ((mOriginalPressedState == isPressed()) && (mParent != null)
                    && mOriginalWindowAttachCount == mWindowAttachCount) {
                if (performLongClick(mX, mY)) {
                    mHasPerformedLongPress = true;
                }
            }
        }
        
    android.view.View#onTouchEvent
        //此时 mHasPerformedLongPress 已经补赋什 true
            if (!mHasPerformedLongPress && !mIgnoreNextUpEvent) {
                // This is a tap, so remove the longpress check
                removeLongPressCallback();

                // Only perform take click actions if we were in the pressed state
                if (!focusTaken) {
                    // Use a Runnable and post this rather than calling
                    // performClick directly. This lets other visual state
                    // of the view update before click actions start.
                    if (mPerformClick == null) {
                        mPerformClick = new PerformClick();
                    }
                    if (!post(mPerformClick)) {
                        performClickInternal();
                    }
                }
            }
            
在具体的场景中，因为可点击的 ClickableSpan 位于末尾，导致后半部分为空白也可以点击了。  
这里不需要仅部分内容可点击，而是整体可点击的，因此使用 OnClickListener 替换 ClickableSpan 来解决。  
如果需要眯击部分内容，可能需要在末尾添加别的 Span 来使得空白部分的点击不一样，具体的 span 确认位于 
    android.text.SpannableStringInternal#getSpans
    最后一个 span 的设置应该位于
    android.text.SpannableStringInternal#setSpan(java.lang.Object, int, int, int, boolean)
    
        mSpans[mSpanCount] = what;
        mSpanData[mSpanCount * COLUMNS + START] = start;
        mSpanData[mSpanCount * COLUMNS + END] = end;
        mSpanData[mSpanCount * COLUMNS + FLAGS] = flags;
        mSpanCount++;
        
        所以最后一个 span 被设为了 end，因此总能找到最后一个 span 来点击。