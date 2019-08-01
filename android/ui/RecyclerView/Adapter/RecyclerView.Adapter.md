# notifyDataSetChanged
## 会什么通知数据变化，布局就会变化
    android.support.v7.widget.RecyclerView.Adapter#notifyDataSetChanged
    
        public final void notifyDataSetChanged() {
            mObservable.notifyChanged();
        }
    android.support.v7.widget.RecyclerView.AdapterDataObservable#notifyChanged
        public void notifyChanged() {
            for (int i = mObservers.size() - 1; i >= 0; i--) {
                mObservers.get(i).onChanged();
            }
        }
        
    Adapter 持有的 mObservable
    
        private final AdapterDataObservable mObservable = new AdapterDataObservable();
        
    
        public void registerAdapterDataObserver(AdapterDataObserver observer) {
            mObservable.registerObserver(observer);
        }
        
    而调用 registerAdapterDataObserver 的地方为
    android.support.v7.widget.RecyclerView#setAdapterInternal
    
    private void setAdapterInternal(Adapter adapter, boolean compatibleWithPrevious,
            boolean removeAndRecycleViews) {
        if (mAdapter != null) {
            mAdapter.unregisterAdapterDataObserver(mObserver);
            mAdapter.onDetachedFromRecyclerView(this);
        }
        if (!compatibleWithPrevious || removeAndRecycleViews) {
            removeAndRecycleViews();
        }
        mAdapterHelper.reset();
        final Adapter oldAdapter = mAdapter;
        mAdapter = adapter;
        if (adapter != null) {
            adapter.registerAdapterDataObserver(mObserver);
            adapter.onAttachedToRecyclerView(this);
        }
        if (mLayout != null) {
            mLayout.onAdapterChanged(oldAdapter, mAdapter);
        }
        mRecycler.onAdapterChanged(oldAdapter, mAdapter, compatibleWithPrevious);
        mState.mStructureChanged = true;
        setDataSetChangedAfterLayout();
    }

    
    RecyclerView 持有的 mObserver
    
    private final RecyclerViewDataObserver mObserver = new RecyclerViewDataObserver();
    android.support.v7.widget.RecyclerView.RecyclerViewDataObserver
    android.support.v7.widget.RecyclerView.RecyclerViewDataObserver#onChanged
        @Override
        public void onChanged() {
            assertNotInLayoutOrScroll(null);
            mState.mStructureChanged = true;

            setDataSetChangedAfterLayout();
            if (!mAdapterHelper.hasPendingUpdates()) {
                requestLayout();
            }
        }
        
    可以看到，RecyclerView 创建了一个观察者，设置 Adapter 时注册观察者。  
    当观察到数据变化时，调用 requestLayout()
    
    