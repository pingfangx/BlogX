[md]

>本文由平方X发表于平方X网，转载请注明出处。[http://blog.pingfangx.com/2397.html](http://blog.pingfangx.com/2397.html)

在上一篇中简单提了一下[ShapeDrawable和GradientDrawable ](http://blog.pingfangx.com/2385.html)
```
android.graphics.drawable.GradientDrawable#inflate
android.graphics.drawable.GradientDrawable#inflateChildElements
android.graphics.drawable.GradientDrawable#updateGradientDrawableStroke
android.graphics.drawable.GradientDrawable#setStroke(int, android.content.res.ColorStateList, float, float)
android.graphics.drawable.GradientDrawable#setStrokeInternal

        DashPathEffect e = null;
        if (dashWidth > 0) {
            e = new DashPathEffect(new float[] { dashWidth, dashGap }, 0);
        }
        mStrokePaint.setPathEffect(e);

        

public class DashPathEffect extends PathEffect {

    public DashPathEffect(float intervals[], float phase) {
        if (intervals.length < 2) {
            throw new ArrayIndexOutOfBoundsException();
        }
        native_instance = nativeCreate(intervals, phase);
    }
    
    private static native long nativeCreate(float intervals[], float phase);
}

public class PathEffect {

    protected void finalize() throws Throwable {
        nativeDestructor(native_instance);
        native_instance = 0;  // Other finalizers can still call us.
    }

    private static native void nativeDestructor(long native_patheffect);
    long native_instance;
}



到了 native 不知道怎么继续了，于是今天查一下。

参考[Mirhunana 的转载《如何查找native方法》](http://blog.csdn.net/hp910315/article/details/51733410)  
他转自[gityuan.《Android JNI原理分析》](http://gityuan.com/2016/05/28/android-jni/)  
方法名android.graphics.DashPathEffect#nativeCreate
转android_graphics_DashPathEffect#nativeCreate
在/framework/base/core/jni/中搜索DashPathEffect
定位到frameworks/base/core/jni/android/graphics/PathEffect.cpp

    android::RegisterMethodsOrDie(env, "android/graphics/DashPathEffect", gDashPathEffectMethods,
                                  NELEM(gDashPathEffectMethods));

然后是
    static const JNINativeMethod gDashPathEffectMethods[] = {
    { "nativeCreate", "([FF)J", (void*)SkPathEffectGlue::Dash_constructor }
};

然后是
frameworks/base/core/jni/android/graphics/PathEffect.cpp
class SkPathEffectGlue {
    ...
        static jlong Dash_constructor(JNIEnv* env, jobject,
                                      jfloatArray intervalArray, jfloat phase) {
        AutoJavaFloatArray autoInterval(env, intervalArray);
        int         count = autoInterval.length() & ~1;  // even number
#ifdef SK_SCALAR_IS_FLOAT
        SkScalar*   intervals = autoInterval.ptr();
#else
        #error Need to convert float array to SkScalar array before calling the following function.
#endif
        SkPathEffect* effect = SkDashPathEffect::Make(intervals, count, phase).release();
        return reinterpret_cast<jlong>(effect);
    }
}

接下来Make方法
external/skia/src/effects/SkDashPathEffect.cpp
sk_sp<SkPathEffect> SkDashPathEffect::Make(const SkScalar intervals[], int count, SkScalar phase) {
    if (!SkDashPath::ValidDashPath(phase, intervals, count)) {
        return nullptr;
    }
    return sk_sp<SkPathEffect>(new SkDashPathEffect(intervals, count, phase));
}

构造函数
SkDashPathEffect::SkDashPathEffect(const SkScalar intervals[], int count, SkScalar phase)
        : fPhase(0)
        , fInitialDashLength(-1)
        , fInitialDashIndex(0)
        , fIntervalLength(0) {
    SkASSERT(intervals);
    SkASSERT(count > 1 && SkIsAlign2(count));

    fIntervals = (SkScalar*)sk_malloc_throw(sizeof(SkScalar) * count);
    fCount = count;
    for (int i = 0; i < count; i++) {
        fIntervals[i] = intervals[i];
    }

    // set the internal data members
    SkDashPath::CalcDashParameters(phase, fIntervals, fCount,
            &fInitialDashLength, &fInitialDashIndex, &fIntervalLength, &fPhase);
}

CalcDashParameters
external/skia/src/utils/SkDashPath.cpp

void SkDashPath::CalcDashParameters(SkScalar phase, const SkScalar intervals[], int32_t count,
                                    SkScalar* initialDashLength, int32_t* initialDashIndex,
                                    SkScalar* intervalLength, SkScalar* adjustedPhase) {
    SkScalar len = 0;
    for (int i = 0; i < count; i++) {
        len += intervals[i];
    }
    *intervalLength = len;
    // Adjust phase to be between 0 and len, "flipping" phase if negative.
    // e.g., if len is 100, then phase of -20 (or -120) is equivalent to 80
    if (adjustedPhase) {
        if (phase < 0) {
            phase = -phase;
            if (phase > len) {
                phase = SkScalarMod(phase, len);
            }
            phase = len - phase;

            // Due to finite precision, it's possible that phase == len,
            // even after the subtract (if len >>> phase), so fix that here.
            // This fixes http://crbug.com/124652 .
            SkASSERT(phase <= len);
            if (phase == len) {
                phase = 0;
            }
        } else if (phase >= len) {
            phase = SkScalarMod(phase, len);
        }
        *adjustedPhase = phase;
    }
    SkASSERT(phase >= 0 && phase < len);

    *initialDashLength = find_first_interval(intervals, phase,
                                            initialDashIndex, count);

    SkASSERT(*initialDashLength >= 0);
    SkASSERT(*initialDashIndex >= 0 && *initialDashIndex < count);
}


static SkScalar find_first_interval(const SkScalar intervals[], SkScalar phase,
                                    int32_t* index, int count) {
    for (int i = 0; i < count; ++i) {
        SkScalar gap = intervals[i];
        if (phase > gap || (phase == gap && gap)) {
            phase -= gap;
        } else {
            *index = i;
            return gap - phase;
        }
    }
    // If we get here, phase "appears" to be larger than our length. This
    // shouldn't happen with perfect precision, but we can accumulate errors
    // during the initial length computation (rounding can make our sum be too
    // big or too small. In that event, we just have to eat the error here.
    *index = 0;
    return intervals[0];
}


```

好了，到此，我们应该能找到是怎么创建 DashPathEffect 的了，但是问题来了，自己对底层这一块不熟悉，还是不知道怎么画出来的。  
所以，还是需要下一篇（也许多年后吧）……



[/md]