
recyclerView.addOnScrollListener(new RecyclerView.OnScrollListener() {
    @Override
    public void onScrollStateChanged(RecyclerView recyclerView, int newState) {
        if (newState == RecyclerView.SCROLL_STATE_IDLE) {
           Glide.with(mContext).resumeRequests();//恢复Glide加载图片
        }else {
           Glide.with(mContext).pauseRequests();//禁止Glide加载图片
        }
    }
});