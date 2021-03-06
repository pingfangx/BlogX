# 总结
FragmentManager 调用 transaction.show  
show 会调用 onHiddenChanged

ViewPager 的 PagerAdapter#instantiateItem 手动调用 setUserVisibleHint
# onHiddenChanged
    android.support.v4.app.FragmentManagerImpl#moveFragmentToExpectedState
        ...
        if (f.mHiddenChanged) {
            completeShowHideFragment(f);
        }
        ...
    android.support.v4.app.FragmentManagerImpl#completeShowHideFragment        
    android.support.v4.app.Fragment#onHiddenChanged
    可以看到，与 mHiddenChanged 相关，其赋值位于
    
    public void showFragment(Fragment fragment) {
        if (DEBUG) Log.v(TAG, "show: " + fragment);
        if (fragment.mHidden) {
            fragment.mHidden = false;
            // Toggle hidden changed so that if a fragment goes through show/hide/show
            // it doesn't go through the animation.
            fragment.mHiddenChanged = !fragment.mHiddenChanged;
        }
    }
    
    也就是说，只有调用 showFragment 才会触发。


# setUserVisibleHint
    android.support.v4.view.ViewPager#populate()
    android.support.v4.view.ViewPager#populate(int)
    android.support.v4.view.ViewPager#addNewItem
    android.support.v4.view.PagerAdapter#instantiateItem(android.view.ViewGroup, int)
    android.support.v4.app.FragmentStatePagerAdapter#instantiateItem
    或者是
    android.support.v4.app.FragmentPagerAdapter#instantiateItem
        
        fragment.setUserVisibleHint(false);
        
# 为什么 ViewPager 不会触发 onHiddenChanged
相关的 FragmentPagerAdapter 只调用了 add  
问题转化为 add 会不会执行 show

    //添加操作
    
    android.support.v4.app.FragmentManagerImpl#beginTransaction    
        public FragmentTransaction beginTransaction() {
            return new BackStackRecord(this);
        }
    android.support.v4.app.BackStackRecord#add(int, android.support.v4.app.Fragment)    
        public FragmentTransaction add(int containerViewId, Fragment fragment) {
            doAddOp(containerViewId, fragment, null, OP_ADD);
            return this;
        }
    android.support.v4.app.BackStackRecord#doAddOp
        ...
        addOp(new Op(opcmd, fragment));
        ...
    android.support.v4.app.BackStackRecord#addOp        
        void addOp(Op op) {
            mOps.add(op);
            op.enterAnim = mEnterAnim;
            op.exitAnim = mExitAnim;
            op.popEnterAnim = mPopEnterAnim;
            op.popExitAnim = mPopExitAnim;
        }
        
    //执行操作
    
    android.support.v4.app.FragmentTransaction#commitNowAllowingStateLoss    
        @Override
        public void commitNowAllowingStateLoss() {
            disallowAddToBackStack();
            //第一个参数为 OpGenerator，传值 this
            mManager.execSingleAction(this, true);
        }
    android.support.v4.app.FragmentManagerImpl#execSingleAction
        public void execSingleAction(OpGenerator action, boolean allowStateLoss) {
            if (allowStateLoss && (mHost == null || mDestroyed)) {
                // This FragmentManager isn't attached, so drop the entire transaction.
                return;
            }
            ensureExecReady(allowStateLoss);
            //调用 BackStackRecord 的 generateOps 方法，将操作添加到 mTmpRecords 中
            if (action.generateOps(mTmpRecords, mTmpIsPop)) {
                mExecutingActions = true;
                try {
                    removeRedundantOperationsAndExecute(mTmpRecords, mTmpIsPop);
                } finally {
                    cleanupExec();
                }
            }

            doPendingDeferredStart();
            burpActive();
        }
        android.support.v4.app.BackStackRecord#generateOps
        public boolean generateOps(ArrayList<BackStackRecord> records, ArrayList<Boolean> isRecordPop) {
            if (FragmentManagerImpl.DEBUG) {
                Log.v(TAG, "Run: " + this);
            }

            records.add(this);
            isRecordPop.add(false);
            if (mAddToBackStack) {
                mManager.addBackStackState(this);
            }
            return true;
        }

    android.support.v4.app.FragmentManagerImpl#removeRedundantOperationsAndExecute
    android.support.v4.app.FragmentManagerImpl#executeOpsTogether
    android.support.v4.app.FragmentManagerImpl#executeOps
    android.support.v4.app.BackStackRecord#executeOps
    android.support.v4.app.FragmentManagerImpl#addFragment
    
    可以看到，调用 add 只会调用 addFragment，不会调用 showFragment
    因此不会调用 onHiddenChanged
    