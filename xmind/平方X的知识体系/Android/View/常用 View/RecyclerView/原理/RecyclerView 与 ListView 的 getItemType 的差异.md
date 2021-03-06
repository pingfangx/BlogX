* 为什么 ListView 即需要 getItemViewType 又需要 getViewTypeCount
* 为什么 RecyclerView 只需要 getItemViewType

S:
* ListView 使用一个数组来保存回收的 View，数组 index 即为类型，数组中每个元素是一个 ArrayList 用于添加和移除 View
* RecyclerView 使用一个 List 保存，获取每个元素比较 type，所以不需要连续。

[Android ListView工作原理完全解析，带你从源码的角度彻底理解](https://blog.csdn.net/guolin_blog/article/details/44996879)
# android.widget.Adapter

    android.widget.Adapter#getItemViewType
    android.widget.Adapter#getViewTypeCount
    
    android.widget.ListView#setAdapter
    android.widget.AbsListView.RecycleBin#setViewTypeCount
    
        public void setViewTypeCount(int viewTypeCount) {
            if (viewTypeCount < 1) {
                throw new IllegalArgumentException("Can't have a viewTypeCount < 1");
            }
            //noinspection unchecked
            ArrayList<View>[] scrapViews = new ArrayList[viewTypeCount];
            for (int i = 0; i < viewTypeCount; i++) {
                scrapViews[i] = new ArrayList<View>();
            }
            mViewTypeCount = viewTypeCount;
            mCurrentScrap = scrapViews[0];
            mScrapViews = scrapViews;
        }
        
    android.widget.AbsListView.RecycleBin#addScrapView
        ...
        
            // Remove but don't scrap header or footer views, or views that
            // should otherwise not be recycled.
            final int viewType = lp.viewType;
            if (!shouldRecycleViewType(viewType)) {
                // Can't recycle. If it's not a header or footer, which have
                // special handling and should be ignored, then skip the scrap
                // heap and we'll fully detach the view later.
                if (viewType != ITEM_VIEW_TYPE_HEADER_OR_FOOTER) {
                    getSkippedScrap().add(scrap);
                }
                return;
            }
            ...
                if (mViewTypeCount == 1) {
                    mCurrentScrap.add(scrap);
                } else {
                    mScrapViews[viewType].add(scrap);
                }

    ListView 持有一个 mScrapViews 数组，其 size 是 viewTypeCount  
    每个元素是一个列表，持有该 viewType 的废弃的 view  
    滑出一个，就缓存一个，然后新建一个，又复用并移除缓存的一个。
    如果只重写 getItemViewType，则 getViewTypeCount 仍是 1，不会异常
    但是如果重写了 getViewTypeCount 不为 1 且与 getItemViewType 不匹配，则在 addScrapView 时异常
    getItemViewType 可以返回负数，在 shouldRecycleViewType 中处理，为负又分为是否是 Header Footer

# android.support.v7.widget.RecyclerView.Adapter
通过以前对 RecyclerView 的分析，我们回忆一下。  
在 tryGetViewHolderForPositionByDeadline 中有多个方法来获取废弃的、隐藏的、缓存的 ViewHolder  
其中的方法可以看到，直接遍历废弃的、缓存的 ViewHolder，然后用 id 及 type 判断相等。

    android.support.v7.widget.RecyclerView.Recycler#getScrapOrCachedViewForId
    
        ViewHolder getScrapOrCachedViewForId(long id, int type, boolean dryRun) {
            // Look in our attached views first
            final int count = mAttachedScrap.size();
            for (int i = count - 1; i >= 0; i--) {
                final ViewHolder holder = mAttachedScrap.get(i);
                if (holder.getItemId() == id && !holder.wasReturnedFromScrap()) {
                    if (type == holder.getItemViewType()) {
                        holder.addFlags(ViewHolder.FLAG_RETURNED_FROM_SCRAP);
                        if (holder.isRemoved()) {
                            // this might be valid in two cases:
                            // > item is removed but we are in pre-layout pass
                            // >> do nothing. return as is. make sure we don't rebind
                            // > item is removed then added to another position and we are in
                            // post layout.
                            // >> remove removed and invalid flags, add update flag to rebind
                            // because item was invisible to us and we don't know what happened in
                            // between.
                            if (!mState.isPreLayout()) {
                                holder.setFlags(ViewHolder.FLAG_UPDATE, ViewHolder.FLAG_UPDATE
                                        | ViewHolder.FLAG_INVALID | ViewHolder.FLAG_REMOVED);
                            }
                        }
                        return holder;
                    } else if (!dryRun) {
                        // if we are running animations, it is actually better to keep it in scrap
                        // but this would force layout manager to lay it out which would be bad.
                        // Recycle this scrap. Type mismatch.
                        mAttachedScrap.remove(i);
                        removeDetachedView(holder.itemView, false);
                        quickRecycleScrapView(holder.itemView);
                    }
                }
            }

            // Search the first-level cache
            final int cacheSize = mCachedViews.size();
            for (int i = cacheSize - 1; i >= 0; i--) {
                final ViewHolder holder = mCachedViews.get(i);
                if (holder.getItemId() == id) {
                    if (type == holder.getItemViewType()) {
                        if (!dryRun) {
                            mCachedViews.remove(i);
                        }
                        return holder;
                    } else if (!dryRun) {
                        recycleCachedViewAt(i);
                        return null;
                    }
                }
            }
            return null;
        }
