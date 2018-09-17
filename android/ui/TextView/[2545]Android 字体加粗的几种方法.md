# 0x00 总结
各方法最终都作用于字体或 Paint  
除对 Paint 直接操作外，textStyle，setTypeface，StyleSpan，b 标签这几种方法  
最后都会使用字体，判断字体如果没有加粗，再设置 Paint#setFakeBoldText

[如何实现 “中间这几个字要加粗，但是不要太粗，比较纤细的那种粗” ？](https://juejin.im/post/597d88f75188257fc2177c36)

[在TextView里面设置字体粗体](https://blog.csdn.net/huntersnail/article/details/48913331)
提到，如果复用 TextView，使用 paint 则会导致每个 Item 都加粗，应换其他方式。

# 0x01 textStyle 和 android.widget.TextView#setTypeface
TextView_textStyle 是 TextView 的属性，作用于字体  

    android.widget.TextView#setTypefaceFromAttrs
    android.widget.TextView#setTypeface(android.graphics.Typeface, int)
    
    public void setTypeface(Typeface tf, int style) {
        if (style > 0) {
            if (tf == null) {
                tf = Typeface.defaultFromStyle(style);
            } else {
                tf = Typeface.create(tf, style);
            }

            setTypeface(tf);
            // now compute what (if any) algorithmic styling is needed
            int typefaceStyle = tf != null ? tf.getStyle() : 0;
            int need = style & ~typefaceStyle;
            mTextPaint.setFakeBoldText((need & Typeface.BOLD) != 0);
            mTextPaint.setTextSkewX((need & Typeface.ITALIC) != 0 ? -0.25f : 0);
        } else {
            mTextPaint.setFakeBoldText(false);
            mTextPaint.setTextSkewX(0);
            setTypeface(tf);
        }
    }
# 0x02 android.graphics.Paint#setFakeBoldText
    
    public void setFakeBoldText(boolean fakeBoldText) {
        nSetFakeBoldText(mNativePaint, fakeBoldText);
    }

上述两个方法，虽然 setTypeface 也有 setFakeBoldText
但是由于已经获取了 bold 字体，没有再对 Paint 进行操任

    int need = style & ~typefaceStyle;
    位非，再位与\n
    如果已经 1，位非为0，位与 1 得 0\n
    如果还是 0，位非为1，位与 1 得 1\n

# 0x03 使用 b 标签
 `<b>` 
## 加载过程最终还是设置的 StyleSpan
    android.widget.TextView#TextView(android.content.Context, android.util.AttributeSet, int, int)
    android.content.res.TypedArray#getText
    android.content.res.TypedArray#loadStringValueAt
    android.content.res.StringBlock#get
    public CharSequence get(int idx) {
        synchronized (this) {
            ...
            String str = nativeGetString(mNative, idx);
            CharSequence res = str;
            int[] style = nativeGetStyle(mNative, idx);
                    ...
                    if (styleTag.equals("b")) {
                        mStyleIDs.boldId = styleId;
                    }
                    ...
                res = applyStyles(str, style, mStyleIDs);
            }
            if (mStrings != null) mStrings[idx] = res;
            else mSparseStrings.put(idx, res);
            return res;
        }
    }
    android.content.res.StringBlock#applyStyles
        if (type == ids.boldId) {
            buffer.setSpan(new StyleSpan(Typeface.BOLD),
                           style[i+1], style[i+2]+1,
                           Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        }
## android.text.style.StyleSpan#apply
    private static void apply(Paint paint, int style) {
        int oldStyle;

        Typeface old = paint.getTypeface();
        if (old == null) {
            oldStyle = 0;
        } else {
            oldStyle = old.getStyle();
        }

        int want = oldStyle | style;

        Typeface tf;
        if (old == null) {
            tf = Typeface.defaultFromStyle(want);
        } else {
            tf = Typeface.create(old, want);
        }

        int fake = want & ~tf.getStyle();

        if ((fake & Typeface.BOLD) != 0) {
            paint.setFakeBoldText(true);
        }

        if ((fake & Typeface.ITALIC) != 0) {
            paint.setTextSkewX(-0.25f);
        }

        paint.setTypeface(tf);
    }