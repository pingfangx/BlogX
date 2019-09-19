# FragmentPagerAdapter不刷新
# 0x00 问题
## 1.滑动时如何切换view？
## 2.PagerAdapter的实现？
## 3.为什么FragmentPagerAdapter不刷新？
## 4.FragmentPagerAdapter和FragmentStatePagerAdapter区别
## 5.滑动事件


## 0x01 滑动时如何切换view？
```
    //可以看到计算了下一个页面，然后set
    //android.support.v4.view.ViewPager#onTouchEvent
    public boolean onTouchEvent(MotionEvent ev) {
        ...
            case MotionEvent.ACTION_UP:
                if (mIsBeingDragged) {
                    int nextPage = determineTargetPage(currentPage, pageOffset, initialVelocity,
                            totalDelta);
                    setCurrentItemInternal(nextPage, true, true, initialVelocity);
                }
        ...
    }
    //通常的setCurrentItem也是转到setCurrentItemInternal
    public void setCurrentItem(int item, boolean smoothScroll) {
        mPopulatePending = false;
        setCurrentItemInternal(item, smoothScroll, false);
    }
    
    void setCurrentItemInternal(int item, boolean smoothScroll, boolean always) {
        setCurrentItemInternal(item, smoothScroll, always, 0);
    }
    void setCurrentItemInternal(int item, boolean smoothScroll, boolean always, int velocity) {
        if (mFirstLayout) {
            // We don't have any idea how big we are yet and shouldn't have any pages either.
            // Just set things up and let the pending layout handle things.
            mCurItem = item;
            if (dispatchSelected) {
                dispatchOnPageSelected(item);
            }
            requestLayout();
        } else {
            populate(item);
            scrollToItem(item, smoothScroll, velocity, dispatchSelected);
        }
    }
    //关键的populate方法
    
    void populate(int newCurrentItem) {
        ...
        final int pageLimit = mOffscreenPageLimit;
        final int startPos = Math.max(0, mCurItem - pageLimit);
        final int N = mAdapter.getCount();
        final int endPos = Math.min(N - 1, mCurItem + pageLimit);
        ...
        //创建一个新的item
        if (curItem == null && N > 0) {
            curItem = addNewItem(mCurItem, curIndex);
        }
        //后面根据pageLimit判断是否需要remove或add执行
        ...
                            mItems.remove(itemIndex);
                            mAdapter.destroyItem(this, pos, ii.object);
        ...
                        ii = addNewItem(pos, itemIndex);
        ...
        
        mAdapter.setPrimaryItem(this, mCurItem, curItem != null ? curItem.object : null);

        mAdapter.finishUpdate(this);
        
        ...
        
    }
    
    ItemInfo addNewItem(int position, int index) {
        ItemInfo ii = new ItemInfo();
        ii.position = position;
        ii.object = mAdapter.instantiateItem(this, position);
        ii.widthFactor = mAdapter.getPageWidth(position);
        if (index < 0 || index >= mItems.size()) {
            mItems.add(ii);
        } else {
            mItems.add(index, ii);
        }
        return ii;
    }
    
```
根据上面的分析，我们知道了在ViewPager通过
android.support.v4.view.PagerAdapter#instantiateItem(android.view.ViewGroup, int)  
android.support.v4.view.PagerAdapter#destroyItem(android.view.ViewGroup, int, java.lang.Object)  
来实例化和销毁item

# 0x02 PagerAdapter的实现？
## 2.1 FragmentPagerAdapter
```

    @Override
    public Object instantiateItem(ViewGroup container, int position) {
        if (mCurTransaction == null) {
            mCurTransaction = mFragmentManager.beginTransaction();
        }

        //获取id,默认实现是return position;
        final long itemId = getItemId(position);

        // 名字return "android:switcher:" + viewId + ":" + id;
        String name = makeFragmentName(container.getId(), itemId);

        // 是否已经有了fragment?        
        Fragment fragment = mFragmentManager.findFragmentByTag(name);
        if (fragment != null) {
            if (DEBUG) Log.v(TAG, "Attaching item #" + itemId + ": f=" + fragment);
            //已经有了,执行attach
            mCurTransaction.attach(fragment);
        } else {
            //没有选获取,执行add
            fragment = getItem(position);
            if (DEBUG) Log.v(TAG, "Adding item #" + itemId + ": f=" + fragment);
            mCurTransaction.add(container.getId(), fragment,
                    makeFragmentName(container.getId(), itemId));
        }
        if (fragment != mCurrentPrimaryItem) {
            //不是当前的,不可见
            fragment.setMenuVisibility(false);
            fragment.setUserVisibleHint(false);
        }

        return fragment;
    }

    @Override
    public void destroyItem(ViewGroup container, int position, Object object) {
        if (mCurTransaction == null) {
            mCurTransaction = mFragmentManager.beginTransaction();
        }
        if (DEBUG) Log.v(TAG, "Detaching item #" + getItemId(position) + ": f=" + object
                + " v=" + ((Fragment)object).getView());
        //执行detach
        mCurTransaction.detach((Fragment)object);
    }
    
    @Override
    public void setPrimaryItem(ViewGroup container, int position, Object object) {
        Fragment fragment = (Fragment)object;
        if (fragment != mCurrentPrimaryItem) {
            if (mCurrentPrimaryItem != null) {
                mCurrentPrimaryItem.setMenuVisibility(false);
                mCurrentPrimaryItem.setUserVisibleHint(false);
            }
            if (fragment != null) {
                fragment.setMenuVisibility(true);
                fragment.setUserVisibleHint(true);
            }
            mCurrentPrimaryItem = fragment;
        }
    }

    @Override
    public void finishUpdate(ViewGroup container) {
        if (mCurTransaction != null) {
            mCurTransaction.commitNowAllowingStateLoss();
            mCurTransaction = null;
        }
    }
    
    public long getItemId(int position) {
        return position;
    }

    private static String makeFragmentName(int viewId, long id) {
        return "android:switcher:" + viewId + ":" + id;
    }
```
## 2.2 FragmentManager
```
    //android.support.v4.app.FragmentManager#findFragmentByTag
    //android.support.v4.app.FragmentManagerImpl#findFragmentByTag
    //可以看到就是在mAdded和mActive中查找
    @Override
    public Fragment findFragmentByTag(String tag) {
        if (mAdded != null && tag != null) {
            // First look through added fragments.
            for (int i=mAdded.size()-1; i>=0; i--) {
                Fragment f = mAdded.get(i);
                if (f != null && tag.equals(f.mTag)) {
                    return f;
                }
            }
        }
        if (mActive != null && tag != null) {
            // Now for any known fragment.
            for (int i=mActive.size()-1; i>=0; i--) {
                Fragment f = mActive.get(i);
                if (f != null && tag.equals(f.mTag)) {
                    return f;
                }
            }
        }
        return null;
    }
    //mAdded的add在
    android.support.v4.app.FragmentManagerImpl#addFragment
    android.support.v4.app.FragmentManagerImpl#attachFragment
    remove在
    android.support.v4.app.FragmentManagerImpl#removeFragment
    android.support.v4.app.FragmentManagerImpl#detachFragment
    
    //mActive的add在
    android.support.v4.app.FragmentManagerImpl#makeActive
    仅在addFragment时调用
    android.support.v4.app.FragmentManagerImpl#addFragment
    没有remove方法,置空在
    android.support.v4.app.FragmentManagerImpl#makeInactive
    //这个调用在下述方法,比较复杂,没认真看,但是在关闭页面时会执行,在ViewPager切换时不会执行到,也就不会清除mActive中的Fragment
    android.support.v4.app.FragmentManagerImpl#moveToState(android.support.v4.app.Fragment, int, int, int, boolean)
    
    
    根据以前的分析,我们知道
    android.support.v4.app.FragmentTransaction#commit
    由android.support.v4.app.BackStackRecord实现
    最后会执行到
    android.support.v4.app.BackStackRecord#executeOps
    在executeOps中会执行addFragment,attachFragment或removeFragment,detachFragment
    
    FragmentPagerAdapter中的
    @Override
    public void finishUpdate(ViewGroup container) {
        if (mCurTransaction != null) {
            mCurTransaction.commitNowAllowingStateLoss();
            mCurTransaction = null;
        }
    }
    也是一样的,最终执行到
    android.support.v4.app.BackStackRecord#executeOps
    
```
# 0x03 为什么FragmentPagerAdapter不刷新？
## 3.1 原因
通过2中的分析我们得出结论
    FragmentPagerAdapter在instantiateItem执行了
    android.support.v4.app.FragmentTransaction#attach和
    android.support.v4.app.FragmentTransaction#add(int, android.support.v4.app.Fragment, java.lang.String)  
    
    在destroyItem执行了
    android.support.v4.app.FragmentTransaction#detach
    这3个方法会让FragmentManagerImpl中的mAdded执行add和remove
    
    但只有add会使mActive执行add,没有执行到remove方法
    因此当在instantiateItem调用android.support.v4.app.FragmentManager#findFragmentByTag时,虽然新设置的Adapter已经变了,但是
    mFragmentManager不变,tag不变,于是在mActive中找到了之前的Fragment,于是没有发化,仍然显示之前的Fragment.
通过上面的分析,我们有几种解决方法
## 3.2 解决方法
如果需要保留，用3.2.2，否则用3.2.3。
### 3.2.1 清空android.support.v4.app.FragmentManagerImpl#mActive
    //android.support.v4.app.FragmentManagerImpl#getFragments
    @Override
    public List<Fragment> getFragments() {
        return mActive;
    }
    调用该方法获得mActive后再执行clear,可以实现.
    但是mActive清空以后,会在android.support.v4.app.FragmentPagerAdapter#instantiateItem中新获取Fragment,
    然后add,因些会让Fragment重新执秆onAttach和onCreate
### 3.2.2 重写getItemId以获得不同的tag
    注意如果使用view的id可能会相邻,需要时可将其*10
### 3.2.3 使用FragmentStatePagerAdapter代替FragmentPagerAdapter
    相比FragmentPagerAdapter在destroyItem执行detach，FragmentStatePagerAdapter会执行remove
    详见4.3
## 3.3 更多问题
### 3.3.1 为什么更改数据源后,调用PagerAdapter的notifyDataSetChanged无效?
追源码
```
    //android.support.v4.view.PagerAdapter#notifyDataSetChanged
    public void notifyDataSetChanged() {
        synchronized (this) {
            if (mViewPagerObserver != null) {
                mViewPagerObserver.onChanged();
            }
        }
        //这里追进去,mObservers没有,因此没作用
        mObservable.notifyChanged();
    }
    //android.support.v4.view.ViewPager.PagerObserver
    //它继承了android.database.DataSetObserver
    private class PagerObserver extends DataSetObserver {
        PagerObserver() {
        }

        @Override
        public void onChanged() {
            dataSetChanged();
        }
        @Override
        public void onInvalidated() {
            dataSetChanged();
        }
    }
    
    //android.support.v4.view.ViewPager#dataSetChanged
    void dataSetChanged() {
        // This method only gets called if our observer is attached, so mAdapter is non-null.

        final int adapterCount = mAdapter.getCount();
        mExpectedAdapterCount = adapterCount;
        boolean needPopulate = mItems.size() < mOffscreenPageLimit * 2 + 1
                && mItems.size() < adapterCount;
        int newCurrItem = mCurItem;

        boolean isUpdating = false;
        for (int i = 0; i < mItems.size(); i++) {
            final ItemInfo ii = mItems.get(i);
            //①获取位置
            final int newPos = mAdapter.getItemPosition(ii.object);

            if (newPos == PagerAdapter.POSITION_UNCHANGED) {
                //②如果没变化,不会对isUpdating及needPopulate赋值
                continue;
            }
            
            ...
        }

        if (isUpdating) {
            mAdapter.finishUpdate(this);
        }

        Collections.sort(mItems, COMPARATOR);

        if (needPopulate) {
            ...
        }
    }
    
    //android.support.v4.view.PagerAdapter#getItemPosition
    //FragmentPagerAdapter和FragmentStatePagerAdapter都没有重写此方法
    public int getItemPosition(Object object) {
        return POSITION_UNCHANGED;
    }
```
可以看到,因为没有重写getItemPosition方法,在调用notifyDataSetChanged时,  
几乎不会进行任何操作,包括android.support.v4.app.FragmentPagerAdapter#instantiateItem也不会执行,也就不会更新Fragment.
就算重写了getItemPosition方法,也只会重新执行instantiateItem方法,是否更新Fragment还是需要3.2中的解决方法.

### 3.3.2 为什么对ViewPager执有的PagerAdapter进行了重新赋值,还是不会变化?
赋值这一块有点不太熟悉了,ViewPager中的mAdapter指向了参数adapter的地址.
类中对mAdapter进行重新赋值,相当于新建了一个PagerAdapter对象,然后把mAdapter变量指向了它.
这不会影响ViewPager中的mAdapter.
当然,如果不进行重新赋值,则类中mAdapter和ViewPager的mAdapter指向同一个对象,是可以操作的.
```
//android.support.v4.view.ViewPager#setAdapter
    public void setAdapter(PagerAdapter adapter) {
        if (mAdapter != null) {
            mAdapter.setViewPagerObserver(null);
            mAdapter.startUpdate(this);
            for (int i = 0; i < mItems.size(); i++) {
                final ItemInfo ii = mItems.get(i);
                mAdapter.destroyItem(this, ii.position, ii.object);
            }
            mAdapter.finishUpdate(this);
            mItems.clear();
            removeNonDecorViews();
            mCurItem = 0;
            scrollTo(0, 0);
        }

        final PagerAdapter oldAdapter = mAdapter;
        mAdapter = adapter;
        ...
    }
```
### 3.3.3 修改了PagerAdapter,重新调用了android.support.v4.view.ViewPager#setAdapter,也无效?
就是3.1中的问题,因为mFragmentManager是同一个(getSupportFragmentManager()),所以  
android.support.v4.app.FragmentManager#findFragmentByTag
仍然能够找到.

# 0x04 FragmentPagerAdapter和FragmentStatePagerAdapter区别
## 4.1 api翻译
## 4.2 源码查看
主要是两个方法,添加和移除  
FragmentPagerAdapter在instantiateItem中,如果已经存在了,则attach,否则getItem,然后add  
在destroyItem中执行detach

而FragmentStatePagerAdapter在instantiateItem中执行的add,在destroyItem中执行remove

## 4.3 detach和remove的区别
detach
```
    //android.support.v4.app.BackStackRecord#executeOps
    //参考[1]
    void executeOps() {
        ...
            switch (op.cmd) {
                ...
                case OP_DETACH:
                    f.setNextAnim(op.exitAnim);
                    mManager.detachFragment(f);
                    break;
                ...
            }
            if (!mAllowOptimization && op.cmd != OP_ADD) {
                mManager.moveFragmentToExpectedState(f);
            }
        ...
    }
    //android.support.v4.app.FragmentManagerImpl#detachFragment
    public void detachFragment(Fragment fragment) {
        if (DEBUG) Log.v(TAG, "detach: " + fragment);
        if (!fragment.mDetached) {
            fragment.mDetached = true;
            if (fragment.mAdded) {
                // We are not already in back stack, so need to remove the fragment.
                if (mAdded != null) {
                    if (DEBUG) Log.v(TAG, "remove from detach: " + fragment);
                    //①从mAdded里面remove
                    mAdded.remove(fragment);
                }
                if (fragment.mHasMenu && fragment.mMenuVisible) {
                    mNeedMenuInvalidate = true;
                }
                fragment.mAdded = false;
            }
        }
    }
    //android.support.v4.app.FragmentManagerImpl#moveFragmentToExpectedState
    void moveFragmentToExpectedState(Fragment f) {
        if (f == null) {
            return;
        }
        //这里的状态为5,RESUMED
        int nextState = mCurState;
        //②没有赋值mRemoving,不会对nextState重新赋值
        if (f.mRemoving) {
            if (f.isInBackStack()) {
                nextState = Math.min(nextState, Fragment.CREATED);
            } else {
                nextState = Math.min(nextState, Fragment.INITIALIZING);
            }
        }
        moveToState(f, nextState, f.getNextTransition(), f.getNextTransitionStyle(), false);
        ...
    }
    
    //android.support.v4.app.FragmentManagerImpl#moveToState(android.support.v4.app.Fragment, int, int, int, boolean)
    
    void moveToState(Fragment f, int newState, int transit, int transitionStyle,
            boolean keepActive) {
        // Fragments that are not currently added will sit in the onCreate() state.
        if ((!f.mAdded || f.mDetached) && newState > Fragment.CREATED) {
            //③之前赋值了mDetached,此处将newState置为CREATED
            newState = Fragment.CREATED;
        }
        if (f.mRemoving && newState > f.mState) {
            // While removing a fragment, we can't change it to a higher state.
            newState = f.mState;
        }
        // Defer start if requested; don't allow it to move to STARTED or higher
        // if it's not already started.
        if (f.mDeferStart && f.mState < Fragment.STARTED && newState > Fragment.STOPPED) {
            newState = Fragment.STOPPED;
        }
        if (f.mState < newState) {
            ...
        } else if (f.mState > newState) {
            switch (f.mState) {
                ...
                case Fragment.CREATED:
                    if (newState < Fragment.CREATED) {
                        //④因为是==CREATED,没有进入此逻辑
                        ...
                    }
            }
        }

        if (f.mState != newState) {
            Log.w(TAG, "moveToState: Fragment state for " + f + " not updated inline; "
                    + "expected state " + newState + " found " + f.mState);
            f.mState = newState;
        }
    }

```
再看remove
```
    //android.support.v4.app.BackStackRecord#executeOps
    
    void executeOps() {
        ...
            switch (op.cmd) {
                ...
                case OP_REMOVE:
                    f.setNextAnim(op.exitAnim);
                    mManager.removeFragment(f);
                    break;
                ...
            }
            if (!mAllowOptimization && op.cmd != OP_ADD) {
                mManager.moveFragmentToExpectedState(f);
            }
        }
        ...
    }
    
    //android.support.v4.app.FragmentManagerImpl#removeFragment
    public void removeFragment(Fragment fragment) {
        if (DEBUG) Log.v(TAG, "remove: " + fragment + " nesting=" + fragment.mBackStackNesting);
        final boolean inactive = !fragment.isInBackStack();
        if (!fragment.mDetached || inactive) {
            if (mAdded != null) {
                //①从mAdded移除
                mAdded.remove(fragment);
            }
            if (fragment.mHasMenu && fragment.mMenuVisible) {
                mNeedMenuInvalidate = true;
            }
            fragment.mAdded = false;
            //②将mRemoving置为true
            fragment.mRemoving = true;
        }
    }
    
    //android.support.v4.app.FragmentManagerImpl#moveFragmentToExpectedState
    
    void moveFragmentToExpectedState(Fragment f) {
        if (f == null) {
            return;
        }
        int nextState = mCurState;
        if (f.mRemoving) {
            //③ 因为②中已将mRemoving置为true,此处将newState置为INITIALIZING
            if (f.isInBackStack()) {
                nextState = Math.min(nextState, Fragment.CREATED);
            } else {
                nextState = Math.min(nextState, Fragment.INITIALIZING);
            }
        }
        moveToState(f, nextState, f.getNextTransition(), f.getNextTransitionStyle(), false);
        ...
    }
    
    //android.support.v4.app.FragmentManagerImpl#moveToState(android.support.v4.app.Fragment, int, int, int, boolean)
    
    void moveToState(Fragment f, int newState, int transit, int transitionStyle,
            boolean keepActive) {
        ...
        if (f.mState < newState) {
            ...
        } else if (f.mState > newState) {
            switch (f.mState) {
                ...
                case Fragment.CREATED:
                    if (newState < Fragment.CREATED) {
                        ...
                        if (f.getAnimatingAway() != null) {
                            ...
                        } else {
                            ...
                            if (!keepActive) {
                                //参数为false
                                if (!f.mRetaining) {
                                    //④执行到此步
                                    makeInactive(f);
                                } else {
                                    f.mHost = null;
                                    f.mParentFragment = null;
                                    f.mFragmentManager = null;
                                }
                            }
                        }
                    }
            }
        }

        if (f.mState != newState) {
            Log.w(TAG, "moveToState: Fragment state for " + f + " not updated inline; "
                    + "expected state " + newState + " found " + f.mState);
            f.mState = newState;
        }
    }
    
    //android.support.v4.app.FragmentManagerImpl#makeInactive
    void makeInactive(Fragment f) {
        if (f.mIndex < 0) {
            return;
        }

        if (DEBUG) Log.v(TAG, "Freeing fragment index " + f);
        //⑤置为null
        mActive.set(f.mIndex, null);
        if (mAvailIndices == null) {
            mAvailIndices = new ArrayList<Integer>();
        }
        mAvailIndices.add(f.mIndex);
        mHost.inactivateFragment(f.mWho);
        f.initState();
    }

```
可以看到detach只是从mAdded中移除,而remove则从mAdded中移除,也在mActive置为null.
也就是3.2.3中的原因.

# 5.滑动事件
这个将在别的文章里分析
# 参考文献
[1].码匠2016.[Fragment之底层关键操作函数moveToState](http://blog.csdn.net/xude1985/article/details/50831288)