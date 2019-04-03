选型

[添仿微信支付宝加支付密码输入view](https://github.com/lygttpod/AndroidCustomView/blob/master/pay_psd_input_view.md)

最后就是手动绘制


    
        //取消默认样式
        setBackgroundColor(Color.TRANSPARENT);
        //光标不可见
        setCursorVisible(false);
        
        
    @Override
    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        super.onSizeChanged(w, h, oldw, oldh);
        // maxCount 个线，maxCount - 1 个间距
        mContentLength = (int) ((w - getPaddingLeft() - getPaddingRight()) / (mMaxLength + mPaddingRadio * (mMaxLength - 1)));
        mHorizontalPadding = (int) (mContentLength * mPaddingRadio);
    }

    @Override
    protected void onTextChanged(CharSequence text, int start, int lengthBefore, int lengthAfter) {
        super.onTextChanged(text, start, lengthBefore, lengthAfter);
        mTextLength = text.toString().length();
        checkMaxCount();
        invalidate();
    }

    @Override
    protected void onSelectionChanged(int selStart, int selEnd) {
        super.onSelectionChanged(selStart, selEnd);
        //始终在最后
        setSelection(getText().length());
    }