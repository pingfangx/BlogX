默认是先加速后减速  
如果设置地传 null 则会赋值为线性的


看调用方法

    android.animation.Animator#setInterpolator
    android.animation.ValueAnimator#setInterpolator
    
    @Override
    public void setInterpolator(TimeInterpolator value) {
        if (value != null) {
            mInterpolator = value;
        } else {
            mInterpolator = new LinearInterpolator();
        }
    }
    如果传 null 会赋值为 LinearInterpolator
    如果不调用此方法
    
    
    private static final TimeInterpolator sDefaultInterpolator =
            new AccelerateDecelerateInterpolator();
    private TimeInterpolator mInterpolator = sDefaultInterpolator;
    