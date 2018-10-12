一开始还以为直接调的 ViewGroup 的方法

    android.support.v7.widget.RecyclerView.LayoutManager#addView(android.view.View)
    android.support.v7.widget.RecyclerView.LayoutManager#addViewInt
    android.support.v7.widget.ChildHelper#addView(android.view.View, int, boolean)
    转到了 ChildHelper
    android.support.v7.widget.RecyclerView.LayoutManager#mChildHelper
    赋值是 recyclerView.mChildHelper
    android.support.v7.widget.RecyclerView#initChildrenHelper
    会调用 android.support.v7.widget.RecyclerView#dispatchChildAttached
    及 android.support.v7.widget.RecyclerView#dispatchChildDetached
    
    接下来会调用
    android.support.v7.widget.RecyclerView.Adapter#onViewAttachedToWindow
    及 android.support.v7.widget.RecyclerView.OnChildAttachStateChangeListener#onChildViewAttachedToWindow