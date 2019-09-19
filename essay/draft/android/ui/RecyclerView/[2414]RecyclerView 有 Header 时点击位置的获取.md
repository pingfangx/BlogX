[md]

ViewHolder 中要获取点击的位置，使用 getAdapterPosition()  

# 0x00 header 引入问题
后在引入了 HeaderAndFooterWrapperAdapter 之后（实现方式为将 header 视为一种 item view），  
getAdapterPosition() 获取的是外部 adapter 的 position ，于是会包含 header 的数量，需要将其减去。

# 0x01 直接获取
一开始就是在需要使用 getAdapterPosition() 的地方，手动获取 adapter ，减去 header 数量。

# 0x02 提供方法设置 headersCount
一开始提供了方法 setHeadersCount()，但是每次申明 ViewHolder 时都要记得手动设置  
最终的 05 还是用回了这个方法。

# 0x03 在 bindTo 中设置 position
bindTo 由封装的 adapter 中的 onBindViewHolder 调用，第次调用重新设置 position 即可，一开始也能正常调用。  
直到有一次我测试时发现 notifyItemRemoved 并没有调用 bindTo

# 0x04 在 bindTo 中添加方法获取 position
```

    public int getPositionOfData() {
        int headersCount = 0;
        try {
            Class viewHolderClass = RecyclerView.ViewHolder.class;
            Field recyclerViewField = viewHolderClass.getDeclaredField("mOwnerRecyclerView");
            if (recyclerViewField != null) {
                recyclerViewField.setAccessible(true);
                RecyclerView ownerRecyclerView = (RecyclerView) recyclerViewField.get(this);
                recyclerViewField.setAccessible(false);
                if (ownerRecyclerView != null) {
                    RecyclerView.Adapter adapter = ownerRecyclerView.getAdapter();
                    if (adapter != null && adapter instanceof HeaderAndFooterWrapperAdapter) {
                        headersCount = ((HeaderAndFooterWrapperAdapter) adapter).getHeadersCount();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return getAdapterPosition() - getHeadersCount();
    }
```

# 0x05 在 HeaderAndFooterWrapperAdapter 中的onCreateViewHolder 中设置
```
        if (holder != null && holder instanceof BaseRecyclerViewHolder) {
            ((BaseRecyclerViewHolder) holder).setHeadersCount(getHeadersCount());
        }
```


[/md]