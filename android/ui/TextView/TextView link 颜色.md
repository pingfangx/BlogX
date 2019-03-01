通过 android:textColorLink 设置，那么原理是什么呢。

    android.widget.TextView#setText(java.lang.CharSequence, android.widget.TextView.BufferType, boolean, int)
        
            if (Linkify.addLinks(s2, mAutoLinkMask)) {
            ...
    android.text.util.Linkify#addLinks(android.text.Spannable, int)
    完成了添加，相关 link 会被处理为 URLSpan
    
    设置颜色赋值给 mTextPaint.linkColor
    追源码追半天，追完了才想起来直接断点 android.text.style.ClickableSpan#updateDrawState 就可以了
    3 = {StackTraceElement@8199} "android.text.TextLine.handleRun(TextLine.java:965)"
    4 = {StackTraceElement@8200} "android.text.TextLine.drawRun(TextLine.java:389)"
    5 = {StackTraceElement@8201} "android.text.TextLine.draw(TextLine.java:217)"
    6 = {StackTraceElement@8202} "android.text.Layout.drawText(Layout.java:539)"
    7 = {StackTraceElement@8203} "android.text.Layout.draw(Layout.java:286)"
    8 = {StackTraceElement@8204} "android.widget.TextView.onDraw(TextView.java:6889)"
    
    由 TextView 转到 Layout
    android.text.Layout#draw(android.graphics.Canvas, android.graphics.Path, android.graphics.Paint, int)
    android.text.Layout#drawText
        
            Directions directions = getLineDirections(lineNum);
            if (directions == DIRS_ALL_LEFT_TO_RIGHT && !mSpannedText && !hasTab && !justify) {
                // XXX: assumes there's nothing additional to be done
                canvas.drawText(buf, start, end, x, lbaseline, paint);
            } else {
                tl.set(paint, buf, start, end, dir, directions, hasTab, tabStops);
                if (justify) {
                    tl.justify(right - left - indentWidth);
                }
                tl.draw(canvas, x, ltop, lbaseline, lbottom);
            }
    转到 TextLine
    android.text.TextLine#draw
    android.text.TextLine#drawRun
    android.text.TextLine#handleRun
    