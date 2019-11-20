# tryGetViewHolderForPositionByDeadline
一般是绘制流程和滚动过程，
以 LinearLayoutManager 为例，在绘制时，onLayout 转到 LinearLayoutManager#onLayoutChildren

然后调用 fill 方法，layoutChunk 方法，在 layoutChunk 中会获取 view 然后添加到 RecyclerView 中

在 layoutChunk 中获取 view 的方法是调用 Reycler 的方法，getViewForPosition，然后会调用

tryGetViewHolderForPositionByDeadline，这也就是复用 view 的关键方法。

在滚动过程中，滚动也会调用 LinearLayoutManager#scrollVerticallyBy, 然后调用 fill layoutChunk

tryGetViewHolderForPositionByDeadline 有多种情况获取 ViewHolder
* getScrapOrHiddenOrCachedHolderForPosition
* getScrapOrCachedViewForId
* ViewCacheExtension#getViewForPositionAndType
* RecycledViewPool#getRecycledView
* Adapter#createViewHolder

# getScrapOrHiddenOrCachedHolderForPosition
根据 position 获取 holder

这里面有 2 个 or，也就是有 3 ViewHolder 的一源，分别是
* scrap 对应 mAttachedScrap，来源于 layout 布骤中临时 remove 的 ViewHolder
* hidden 对应 mChildHelper.findHiddenNonRemovedView 来源于动画，具体没测试
* cached 对应 mCachedViews，来源于 layout 及 scroll


# 回收过程
## scrapOrRecycleView
### androidx.recyclerview.widget.RecyclerView.Recycler#scrapView
scrap 来源于 layout 过程，当调用 notifyItemRemoved，会在 dispatchLayoutStep1 调用 processAdapterUpdatesAndSetAnimationFlags，
最终添加 REMOVE 的 flag

随后，当调用 onLayoutChildren 时 detachAndScrapAttachedViews 会调用
scrapOrRecycleView，当 isRemoved() 时执行 scrap 添加到 mAttachedScrap 中  
否则如果满足 if (viewHolder.isInvalid() && !viewHolder.isRemoved() && !mRecyclerView.mAdapter.hasStableIds()) {

则会执行 recycle

### androidx.recyclerview.widget.RecyclerView.Recycler#recycleView
该方法从 scroll 过程调用
### androidx.recyclerview.widget.RecyclerView.Recycler#recycleViewHolderInternal
回收时，mCachedViews 受限于最大值，默认为 2，可以由预加载增大

如果大于最大值，则会将最早加入的 ViewHolder 移除并添加 RecycledViewPool