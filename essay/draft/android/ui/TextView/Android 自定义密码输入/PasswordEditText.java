package com.cloudy.jun.common.widget.textview;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.text.InputFilter;
import android.util.AttributeSet;
import android.widget.EditText;

import com.cloudy.jun.R;

/**
 * 密码输入
 *
 * @author 刘汝寿
 * @date 2019/3/23
 */
public class PasswordEditText extends EditText {
    /** 文本长度 */
    protected int mTextLength;
    /** 最大长度 */
    private int mMaxLength = 6;

    //绘制相关
    /** 内容大小，圆点直径或文字大小 */
    protected float mContentSize = 20F;
    /** 内容画笔，圆点颜色或文字颜色 */
    protected Paint mContentPaint;
    /** 边框宽度 */
    private int mBorderWidth = 2;
    /** 边框画笔 */
    private Paint mBorderPaint;
    /** 边框选中画笔 */
    private Paint mBorderSelectedPaint;
    /** 间距与单个内容长度的比例 */
    private float mPaddingRadio = 20F / 95;
    /** 水平间距 */
    protected int mHorizontalPadding;
    /** 单个内容长度 */
    protected int mContentLength;
    private OnCodeFinishListener mOnCodeFinishListener;

    public PasswordEditText(Context context) {
        super(context);
        init(context, null);
    }

    public PasswordEditText(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context, attrs);
    }

    public PasswordEditText(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init(context, attrs);
    }

    private void init(Context context, AttributeSet attrs) {
        initAttr(context, attrs);
        initSetting();
        if (isInEditMode()) {
            StringBuilder stringBuilder = new StringBuilder(mMaxLength);
            for (int i = 0; i < mMaxLength; i++) {
                stringBuilder.append(i);
            }
            setText(stringBuilder.toString());
        }
    }

    /**
     * 初始化属性
     */
    protected void initAttr(Context context, AttributeSet attrs) {
        TypedArray a = context.obtainStyledAttributes(attrs, R.styleable.PasswordEditText);

        mMaxLength = a.getInt(R.styleable.PasswordEditText_android_maxLength, mMaxLength);
        mPaddingRadio = a.getFloat(R.styleable.PasswordEditText_paddingRadio, mPaddingRadio);

        int contentColor = a.getColor(R.styleable.PasswordEditText_android_textColor, Color.BLACK);
        mContentPaint = createPaint(0, Paint.Style.FILL, contentColor);

        mContentSize = a.getDimension(R.styleable.PasswordEditText_android_textSize, mContentSize);
        mContentPaint.setTextSize(mContentSize);

        //边框
        mBorderWidth = a.getDimensionPixelOffset(R.styleable.PasswordEditText_borderWidth, mBorderWidth);

        int borderColor = a.getColor(R.styleable.PasswordEditText_borderColor, Color.BLACK);
        mBorderPaint = createPaint(mBorderWidth, Paint.Style.STROKE, borderColor);

        int borderSelectedColor = a.getColor(R.styleable.PasswordEditText_borderSelectedColor, borderColor);
        mBorderSelectedPaint = createPaint(mBorderWidth, Paint.Style.STROKE, borderSelectedColor);

        a.recycle();
    }

    /**
     * 初始化设置
     */
    private void initSetting() {
        //取消默认样式
        setBackgroundColor(Color.TRANSPARENT);
        //光标不可见
        setCursorVisible(false);
        //最大输入长度，注意要在赋值后
        setFilters(new InputFilter[]{new InputFilter.LengthFilter(mMaxLength)});
    }

    /**
     * 创建画笔
     */
    private Paint createPaint(int strokeWidth, Paint.Style style, int color) {
        Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
        paint.setStrokeWidth(strokeWidth);
        paint.setStyle(style);
        paint.setColor(color);
        paint.setAntiAlias(true);
        return paint;
    }

    @Override
    protected void onDraw(Canvas canvas) {
        //super.onDraw(canvas);
        drawBottomLine(canvas);
        drawContent(canvas);
    }

    /**
     * 绘制内容
     */
    protected void drawContent(Canvas canvas) {
        for (int i = 0; i < mTextLength; i++) {
            float start = getPaddingLeft() + mContentLength * i + mHorizontalPadding * i;
            canvas.drawCircle(start + mContentLength / 2F, getHeight() / 2F, mContentSize / 2F, mContentPaint);
        }
    }

    /**
     * 绘制底部线
     */
    private void drawBottomLine(Canvas canvas) {
        for (int i = 0; i < mMaxLength; i++) {
            float start = getPaddingLeft() + mContentLength * i + mHorizontalPadding * i;
            boolean selected = isFocused() && i == mTextLength;
            canvas.drawLine(start, getHeight(), start + mContentLength, getHeight(), selected ? mBorderSelectedPaint : mBorderPaint);
        }
    }

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

    private void checkMaxCount() {
        if (mOnCodeFinishListener != null) {
            if (mTextLength == mMaxLength) {
                mOnCodeFinishListener.onComplete(getText().toString());
            } else {
                mOnCodeFinishListener.invalidContent();
            }
        }
    }

    public void setContentSize(float contentSize) {
        mContentSize = contentSize;
        mContentPaint.setTextSize(mContentSize);
    }

    public void setOnCodeFinishListener(OnCodeFinishListener onCodeFinishListener) {
        mOnCodeFinishListener = onCodeFinishListener;
    }

    public interface OnCodeFinishListener {
        /**
         * 输入完成
         */
        void onComplete(String content);

        /**
         * 输入未完成（完成之后删除，可用来判断提交按钮可否点击）
         */
        void invalidContent();
    }
}
