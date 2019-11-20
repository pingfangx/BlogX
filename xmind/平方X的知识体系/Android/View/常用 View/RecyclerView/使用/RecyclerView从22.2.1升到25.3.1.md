RecyclerView从22.2.1升到25.3.1
添加header，之前的item如果高是match_parent，可以正常显示，但是升级后高度就变成了match_parent，查一下原因。
        View localCarTypeView = layoutInflater.inflate(R.layout.item_store_home_header, getRefreshController().getRecyclerView(), false);
        wrapperAdapter.addHeaderView(localCarTypeView);
        
        
        