主要是记录了解决过程，没有查看原因。


为了有阴影，需要
    
    WindowManager.LayoutParams params = window.getAttributes();
    params.alpha = 0.7f;
    window.setAttributes(params);
    
为了点击阴影部分取消，需要

    setBackgroundDrawable(DeprecatedUtils.createEmptyBitmapDrawable());
    //设置后才能点击外部消失，如果不设置，外部也会接受到点击事件
    setFocusable(true);
    
为了适应宽高

    
    setWidth(ViewGroup.LayoutParams.WRAP_CONTENT);
    setHeight(ViewGroup.LayoutParams.WRAP_CONTENT);

但是这样对 recyclerView 还是无效，需要 setLayoutManager

        mRecyclerView.setLayoutManager(new NestedLinearLayoutManager(context));

接下来 recyclerView 计算了宽高，但是 item 无法正常显示

无法根据 item 计算宽度，因此指定 recyclerView 的宽度

item 的字无法居中，将其宽度设为 match_parent

showAsDropDown 时无法距窗体右侧有间距，设置负的 xoff 也无效，于是在 recyclerView 外层包一个布局