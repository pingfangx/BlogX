一开始以为只会调用一次，但是我们的场景是 ViewPager + FragmentAdapter  
导致实际过程中重新调用，调用过程如下
# ViewPager
android.support.v4.view.ViewPager#setCurrentItem(int)
android.support.v4.view.ViewPager#setCurrentItemInternal(int, boolean, boolean)
android.support.v4.view.ViewPager#setCurrentItemInternal(int, boolean, boolean, int)
android.support.v4.view.ViewPager#populate(int)
在这一步中处理 item
    先调用
    android.support.v4.view.PagerAdapter#startUpdate(android.view.ViewGroup)
    添加
    android.support.v4.view.ViewPager#addNewItem
    android.support.v4.view.PagerAdapter#instantiateItem(android.view.ViewGroup, int)
    移除
    android.support.v4.view.PagerAdapter#destroyItem(android.view.ViewGroup, int, java.lang.Object)
    然后调用
    android.support.v4.view.PagerAdapter#setPrimaryItem(android.view.ViewGroup, int, java.lang.Object)
    android.support.v4.view.PagerAdapter#finishUpdate(android.view.ViewGroup)

# Adapter
## android.support.v4.app.FragmentStatePagerAdapter
android.support.v4.app.FragmentStatePagerAdapter#instantiateItem
android.support.v4.app.FragmentStatePagerAdapter#destroyItem
android.support.v4.app.FragmentStatePagerAdapter#finishUpdate
    调用
    android.support.v4.app.FragmentTransaction#commitNowAllowingStateLoss

# android.support.v4.app.BackStackRecord
android.support.v4.app.BackStackRecord#commitNowAllowingStateLoss
android.support.v4.app.FragmentManagerImpl#execSingleAction
android.support.v4.app.FragmentManagerImpl#optimizeAndExecuteOps
android.support.v4.app.FragmentManagerImpl#executeOpsTogether
android.support.v4.app.FragmentTransition#startTransitions
android.support.v4.app.FragmentTransition#calculateFragments
android.support.v4.app.FragmentTransition#addToFirstInLastOut
android.support.v4.app.FragmentManagerImpl#moveToState(android.support.v4.app.Fragment, int, int, int, boolean)

# android.support.v4.app.FragmentManagerImpl
android.support.v4.app.FragmentManagerImpl#moveToState(android.support.v4.app.Fragment, int, int, int, boolean)
android.support.v4.app.Fragment#onAttach(android.content.Context)