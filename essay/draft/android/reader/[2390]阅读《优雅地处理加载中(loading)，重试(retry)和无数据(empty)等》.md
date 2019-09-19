[md]

>本文由平方X发表于平方X网，转载请注明出处。[http://blog.pingfangx.com/2390.html](http://blog.pingfangx.com/2390.html)

感谢[KingJA.《优雅地处理加载中(loading)，重试(retry)和无数据(empty)等》](http://www.jianshu.com/p/2d3537101281)  
[项目地址](https://github.com/KingJA/LoadSir)

会封装提供了一些思路。

# 如何做到即可以全局配置又可以单独设置
全局就用单例，单独设置用内部 builder 新建了一个实例（构造方法依然是私有的，只有内部的 builder 调用）。

# 作用过程
在 application 中设置全局配置的时候，会 setDefaultCallback  
调用 LoadSir.getDefault().register 时
LoadService 的构造方法有com.kingja.loadsir.core.LoadService#initCallback  
这里面调用了loadLayout.showCallback(defalutCallback);

最后的 showCallbackView 才把 view 展示出来。
```

    private void showCallbackView(Class<? extends Callback> status) {
        if (preCallback != null) {
            callbacks.get(preCallback).onDetach();
        }
        if (getChildCount() > 0) {
            removeAllViews();
        }
        for (Class key : callbacks.keySet()) {
            if (key == status) {
                View rootView = callbacks.get(key).getRootView();
                addView(rootView);
                callbacks.get(key).onAttach(context, rootView);
                preCallback = status;
            }
        }
    }
```

# Fragment 的作用过程
```
@Nullable
@Override
public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle
        savedInstanceState) {
    //第一步：获取布局View
    rootView = View.inflate(getActivity(), R.layout.fragment_a_content, null);
    //第二步：注册布局View
    LoadService loadService = LoadSir.getDefault().register(rootView, new Callback.OnReloadListener() {
        @Override
        public void onReload(View v) {
            // 重新加载逻辑
        }
    });
    //第三步：返回LoadSir生成的LoadLayout
    return loadService.getLoadLayout();
}
protected void loadNet() {
        // 进行网络访问...
        // 进行回调
        loadService.showSuccess();//成功回调
        loadService.showCallback(EmptyCallback.class);//其他回调
    }

```

[/md]