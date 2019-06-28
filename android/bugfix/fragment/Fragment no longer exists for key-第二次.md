# 处理过程
## 异常堆栈
    java.lang.IllegalStateException: Fragment no longer exists for key f0: index 0
        at android.support.v4.app.FragmentManagerImpl.getFragment(FragmentManager.java:938)
        at android.support.v4.app.FragmentStatePagerAdapter.restoreState(FragmentStatePagerAdapter.java:217)
        at android.support.v4.view.ViewPager.onRestoreInstanceState(ViewPager.java:1461)
        at android.view.View.dispatchRestoreInstanceState(View.java:18608)
        at android.view.ViewGroup.dispatchRestoreInstanceState(ViewGroup.java:3821)
        at android.view.ViewGroup.dispatchRestoreInstanceState(ViewGroup.java:3827)
        at android.view.View.restoreHierarchyState(View.java:18586)
        at android.support.v4.app.Fragment.restoreViewState(Fragment.java:494)
        at android.support.v4.app.FragmentManagerImpl.moveToState(FragmentManager.java:1486)
        at android.support.v4.app.FragmentManagerImpl.moveFragmentToExpectedState(FragmentManager.java:1784)
        at android.support.v4.app.FragmentManagerImpl.moveToState(FragmentManager.java:1852)
        at android.support.v4.app.BackStackRecord.executeOps(BackStackRecord.java:802)
        at android.support.v4.app.FragmentManagerImpl.executeOps(FragmentManager.java:2625)
        at android.support.v4.app.FragmentManagerImpl.executeOpsTogether(FragmentManager.java:2411)
        at android.support.v4.app.FragmentManagerImpl.removeRedundantOperationsAndExecute(FragmentManager.java:2366)
        at android.support.v4.app.FragmentManagerImpl.execSingleAction(FragmentManager.java:2243)
        at android.support.v4.app.BackStackRecord.commitNowAllowingStateLoss(BackStackRecord.java:654)
        at android.support.v4.app.FragmentStatePagerAdapter.finishUpdate(FragmentStatePagerAdapter.java:168)
        at android.support.v4.view.ViewPager.populate(ViewPager.java:1244)
        at android.support.v4.view.ViewPager.setCurrentItemInternal(ViewPager.java:669)
        at android.support.v4.view.ViewPager.setCurrentItemInternal(ViewPager.java:631)
        at android.support.v4.view.ViewPager.setCurrentItem(ViewPager.java:612)

错误好像和上一次一样，但是原因不一样
具体场景

* ViewPager 中有 4 个 Frament，其中第 2 个也有 ViewPager

* 第 2 个 Fragment 使用 FragmentStatePagerAdapter，同时加载数据

* 切换到第 4 个 Fragment，第 2 个 destroy，其 adapter saveState  
  保存时会判断 isAdded 才保存

* 从第 4 个 Fragment 切回第 2 个，adapter restoreState

  恢复时 Fragment 找不到，报错。


        @Nullable
        public Fragment getFragment(Bundle bundle, String key) {
            int index = bundle.getInt(key, -1);
            if (index == -1) {
                return null;
            } else {
                Fragment f = (Fragment)this.mActive.get(index);
                if (f == null) {
                    this.throwException(new IllegalStateException("Fragment no longer exists for key " + key + ": index " + index));
                }
    
                return f;
            }
        }
        此次原因为 mActive 中没有，移到 mAdded 中了。

​        

按理说，保存时判断了 isAdded，所以恢复时应该在才对。

下断于

android.support.v4.app.FragmentStatePagerAdapter#saveState

android.support.v4.app.FragmentManagerImpl#makeInactive

调试发现，先调用了保存

    saveState:191, FragmentStatePagerAdapter (android.support.v4.app)
    onSaveInstanceState:1445, ViewPager (android.support.v4.view)
    dispatchSaveInstanceState:18516, View (android.view)
    dispatchSaveInstanceState:3796, ViewGroup (android.view)
    dispatchSaveInstanceState:3802, ViewGroup (android.view)
    saveHierarchyState:18499, View (android.view)
    saveFragmentViewState:2897, FragmentManagerImpl (android.support.v4.app)
    saveFragmentBasicState:2918, FragmentManagerImpl (android.support.v4.app)
    saveFragmentInstanceState:992, FragmentManagerImpl (android.support.v4.app)
    destroyItem:144, FragmentStatePagerAdapter (android.support.v4.app)
    populate:1178, ViewPager (android.support.v4.view)
    setCurrentItemInternal:669, ViewPager (android.support.v4.view)
    setCurrentItemInternal:631, ViewPager (android.support.v4.view)
    setCurrentItem:612, ViewPager (android.support.v4.view)
    onClick:272, PagerSlidingTabStrip$3 (com.cloudy.linglingbang.app.widget)
    performClick:6597, View (android.view)
    performClickInternal:6574, View (android.view)
    access$3100:778, View (android.view)
    run:25885, View$PerformClick (android.view)
    handleCallback:873, Handler (android.os)
    dispatchMessage:99, Handler (android.os)
    loop:193, Looper (android.os)
    main:6669, ActivityThread (android.app)
    invoke:-1, Method (java.lang.reflect)
    run:493, RuntimeInit$MethodAndArgsCaller (com.android.internal.os)
    main:858, ZygoteInit (com.android.internal.os)
        
    然后却又将其隐藏了
    makeInactive:1906, FragmentManagerImpl (android.support.v4.app)
    moveToState:1601, FragmentManagerImpl (android.support.v4.app)
    moveFragmentToExpectedState:1784, FragmentManagerImpl (android.support.v4.app)
    moveToState:1852, FragmentManagerImpl (android.support.v4.app)
    dispatchStateChange:3269, FragmentManagerImpl (android.support.v4.app)
    dispatchDestroy:3260, FragmentManagerImpl (android.support.v4.app)
    performDestroy:2694, Fragment (android.support.v4.app)
    moveToState:1591, FragmentManagerImpl (android.support.v4.app)
    moveFragmentToExpectedState:1784, FragmentManagerImpl (android.support.v4.app)
    executeOps:797, BackStackRecord (android.support.v4.app)
    executeOps:2625, FragmentManagerImpl (android.support.v4.app)
    executeOpsTogether:2411, FragmentManagerImpl (android.support.v4.app)
    removeRedundantOperationsAndExecute:2366, FragmentManagerImpl (android.support.v4.app)
    execSingleAction:2243, FragmentManagerImpl (android.support.v4.app)
    commitNowAllowingStateLoss:654, BackStackRecord (android.support.v4.app)
    finishUpdate:168, FragmentStatePagerAdapter (android.support.v4.app)
    populate:1244, ViewPager (android.support.v4.view)
    setCurrentItemInternal:669, ViewPager (android.support.v4.view)
    setCurrentItemInternal:631, ViewPager (android.support.v4.view)
    setCurrentItem:612, ViewPager (android.support.v4.view)
    onClick:272, PagerSlidingTabStrip$3 (com.cloudy.linglingbang.app.widget)
    performClick:6597, View (android.view)
    performClickInternal:6574, View (android.view)
    access$3100:778, View (android.view)
    run:25885, View$PerformClick (android.view)
    handleCallback:873, Handler (android.os)
    dispatchMessage:99, Handler (android.os)
    loop:193, Looper (android.os)
    main:6669, ActivityThread (android.app)
    invoke:-1, Method (java.lang.reflect)
    run:493, RuntimeInit$MethodAndArgsCaller (com.android.internal.os)
    main:858, ZygoteInit (com.android.internal.os)
对比发现，在 pupulate 方法中，先调用 destroyItem 保存状态，然后调用 finishUpdate 取消激活，执行 performDestroy

问题出在哪，感觉好像还是出在了嵌套使用，是不是不能嵌套，这一部分太复杂，没有掌握得特别清楚。

因为内部倒是 saveState 了，但是外部的 Adapter 直接将第二个 Fragment destroy 了。



# 解决方案

同一中的解决方案

或者 setOffscreenPageLimit 不让其 onDestory，则可以正常执行 restoreState