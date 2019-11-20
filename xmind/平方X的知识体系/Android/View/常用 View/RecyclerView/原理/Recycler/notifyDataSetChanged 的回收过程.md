如果调用 notifyDataSetChanged 默认情况下，只能回收 5 个 ViewHolder
# 调用 notifyDataSetChanged 会标记为无效
    addFlags:11179, RecyclerView$ViewHolder (androidx.recyclerview.widget)
    markKnownViewsInvalid:4612, RecyclerView (androidx.recyclerview.widget)
                holder.addFlags(ViewHolder.FLAG_UPDATE | ViewHolder.FLAG_INVALID);
    processDataSetCompletelyChanged:4600, RecyclerView (androidx.recyclerview.widget)
    onChanged:5431, RecyclerView$RecyclerViewDataObserver (androidx.recyclerview.widget)
    notifyChanged:12133, RecyclerView$AdapterDataObservable (androidx.recyclerview.widget)
    notifyDataSetChanged:7233, RecyclerView$Adapter (androidx.recyclerview.widget)
    
# 不会添加到 mCachedViews 而是直接添加到 mRecyclerPool

            if (forceRecycle || holder.isRecyclable()) {
                if (mViewCacheMax > 0
                        && !holder.hasAnyOfTheFlags(ViewHolder.FLAG_INVALID
                        | ViewHolder.FLAG_REMOVED
                        | ViewHolder.FLAG_UPDATE
                        | ViewHolder.FLAG_ADAPTER_POSITION_UNKNOWN)) {
                    // Retire oldest cached view
                    int cachedViewSize = mCachedViews.size();
                    if (cachedViewSize >= mViewCacheMax && cachedViewSize > 0) {
                        recycleCachedViewAt(0);
                        cachedViewSize--;
                    }

                    int targetCacheIndex = cachedViewSize;
                    if (ALLOW_THREAD_GAP_WORK
                            && cachedViewSize > 0
                            && !mPrefetchRegistry.lastPrefetchIncludedPosition(holder.mPosition)) {
                        // when adding the view, skip past most recently prefetched views
                        int cacheIndex = cachedViewSize - 1;
                        while (cacheIndex >= 0) {
                            int cachedPos = mCachedViews.get(cacheIndex).mPosition;
                            if (!mPrefetchRegistry.lastPrefetchIncludedPosition(cachedPos)) {
                                break;
                            }
                            cacheIndex--;
                        }
                        targetCacheIndex = cacheIndex + 1;
                    }
                    mCachedViews.add(targetCacheIndex, holder);
                    cached = true;
                }
                if (!cached) {
                    addViewHolderToRecycledViewPool(holder, true);
                    recycled = true;
                }
            }
            
当从 layout 调用到 scrapOrRecycleView 时进入 recycleViewHolderInternal

由于此时有标志 FLAG_INVALID 因此不会添加到 mCachedViews，而是直接添加到 mRecyclerPool

回收池的结构是以 itemType 为键的 SparseArray

其值为 ScrapData，包含 int mMaxScrap 和 ArrayList<ViewHolder> mScrapHeap，因为 mMaxScrap 默认值为 5，所以每个 mScrapHeap 包含 5 个 ViewHolder

