
# 0x04 FragmentPagerAdapter 和 FragmentStatePagerAdapter 区别
## 4.1 api翻译
### FragmentPagerAdapter
> FragmentPagerAdapter 是 PagerAdapter 的实现，它将每个页面表现为 Fragment。只要用户可以返回到页面上，Fragment 就会被持久在 fragment manager 中。

> 这个版本的 pager 最适用于有一小部分的静态 fragments 需要分页显示的情况，比如一组 tabs。用户访问的每个页面的 fragment 都将保留在内存中，尽管它的视图层次结构可能在不可见时被 destroy 了。这可能导致使用大量的内存，因为 fragment 实例可以保持任意数量的状态。对于较多数量的 pages，推荐使用 FragmentStatePagerAdapter。

### FragmentStatePagerAdapter
> FragmentStatePagerAdapter 是 PagerAdapter 的一个实现，它使用 Fragment 来管理每一页。该类也处理 fragment 状态的保存和恢复。

> 当有大量页面时，这个版本的 pager 更有用，它工作更像 list view。当页面对用户不可见时，它们的整个 fragment 可能被破坏，只保留该 fragment 的保存状态。与 FragmentPagerAdapter 相比，这样就可以使 pager 与每个访问页面相关联的内存占用更少，但在页面之间切换时可能会有更多的开销。

## 4.2 源码查看
FragmentStatePagerAdapter 处理了 saveState 和 restoreState  
另外再看
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

也就是一个是 attach detach  
一个是 add remove
detach 从 mAdded 移除，但是 mActive 仍持有  
remove 从 mAdded 移除，也从 mActive 移除  
mActive 持有，可以通过 getFragment、findFragmentById、findFragmentByTag 等方法获取