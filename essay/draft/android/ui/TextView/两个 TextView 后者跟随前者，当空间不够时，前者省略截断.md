原项目中有 item_recommend_column_post 的实现

# 使用 drawableRight
* 省略中间
* 修改 TextView 省略时保留末尾的 span

相关方法

    /**
     * 省略
     */
    private void setContentViewEllipsis(CharSequence content) {
        if (TextUtils.isEmpty(content)) {
            return;
        }
        if (mTvContent.getLineCount() > MAX_LINE) {
            int endOfLastLine = mTvContent.getLayout().getLineEnd(MAX_LINE - 1);
            CharSequence charSequence = content.subSequence(0, endOfLastLine - 1);
            SpannableStringBuilder spannableStringBuilder = new SpannableStringBuilder(charSequence);
            spannableStringBuilder.append("…");
            mTvContent.setText(spannableStringBuilder);
            //使用 TextUtils.ellipsize 无法计算空行的宽度
        }
    }
    
# LinearLayout 加 layout_weight
使用两层的 LinearLayout，内层 android:layout_width="wrap_content"  
然后第一个 TextView 设置 android:layout_weight="1"
布局如下

    <?xml version="1.0" encoding="utf-8"?>
    <LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
        xmlns:tools="http://schemas.android.com/tools"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:orientation="horizontal">

        <LinearLayout
            android:layout_width="wrap_content"
            android:layout_height="wrap_content">

            <!--套一层，使得可以跟随及省略-->
            <!--使用 wrap_content 而不是 0dp，防止复用时不正确省略-->
            <TextView
                android:id="@+id/tv_1"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:layout_weight="1"
                android:ellipsize="end"
                android:maxLines="1"
                tools:background="@sample/colors.json/green"
                tools:text="@sample/strings.json/long" />

            <TextView
                android:id="@+id/tv_2"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:layout_marginLeft="10dp"
                tools:background="@sample/colors.json/red"
                tools:text="右" />
        </LinearLayout>

    </LinearLayout>

# ConstraintLayout
有了强大的 ConstraintLayout，这个问题终于比较好解决了

[android - ConstraintLayout Chains and Text Ellipsis + Image on the Right - Stack Overflow](https://stackoverflow.com/questions/40410786/constraintlayout-chains-and-text-ellipsis-image-on-the-right)


## 两者形成链，使用 layout_constraintHorizontal_chainStyle="packed" 配合 layout_constraintHorizontal_bias="0"
这能够使两个 View 紧凑，同时靠左  
但是如果前者较宽，会挤占后者的空间（也就是最初的问题）  
这时需要 wrap_content + layout_constrainedWidth


## 1 android:layout_width="wrap_content" + app:layout_constrainedWidth="true"
### WRAP_CONTENT : enforcing constraints (Added in 1.1)
> If a dimension is set to WRAP_CONTENT, in versions before 1.1 they will be treated as a literal dimension -- meaning, constraints will not limit the resulting dimension. While in general this is enough (and faster), in some situations, you might want to use WRAP_CONTENT, yet keep enforcing constraints to limit the resulting dimension. In that case, you can add one of the corresponding attribute:

最终布局

    <?xml version="1.0" encoding="utf-8"?>
    <androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
        xmlns:app="http://schemas.android.com/apk/res-auto"
        xmlns:tools="http://schemas.android.com/tools"
        android:layout_width="match_parent"
        android:layout_height="match_parent">

        <TextView
            android:id="@+id/tv_1"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:ellipsize="end"
            android:maxLines="1"
            app:layout_constrainedWidth="true"
            app:layout_constraintHorizontal_bias="0"
            app:layout_constraintHorizontal_chainStyle="packed"
            app:layout_constraintLeft_toLeftOf="parent"
            app:layout_constraintRight_toLeftOf="@+id/tv_2"
            app:layout_constraintTop_toTopOf="parent"
            tools:background="@sample/colors.json/green"
            tools:text="@sample/strings.json/long" />

        <TextView
            android:id="@+id/tv_2"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:layout_marginLeft="10dp"
            app:layout_constraintLeft_toRightOf="@+id/tv_1"
            app:layout_constraintRight_toRightOf="parent"
            app:layout_constraintTop_toTopOf="parent"
            tools:background="@sample/colors.json/red"
            tools:text="右" />

    </androidx.constraintlayout.widget.ConstraintLayout>
## 2 使用 android:layout_width="0dp" + app:layout_constraintWidth_default="wrap"
和 1 中的效果一样。