[片段  |  Android Developers](https://developer.android.google.cn/guide/components/fragments#Lifecycle)

首先写下 Activity 的生命周期，共 7 个，3对加1

    onCreate
    onStart
    onResume
    onPause
    onStop
    onDestory
    
    onRestart
    
然后插入 附加与创建 View
    
    onAttach
    
    onCreate
    onCreateView
    onActivityCreated
    onStart
    onResume
    onPause
    onStop
    onDestoryView
    onDestory
    
    onDetach
    
# 与 Activity 一起测试
    FragmentLifecycleActivity onCreate
    fragment onAttach
    fragment onCreate
    fragment onCreateView
    fragment onActivityCreated
    fragment onStart
    FragmentLifecycleActivity onStart
    FragmentLifecycleActivity onResume
    fragment onResume
    
    fragment onPause
    FragmentLifecycleActivity onPause
    fragment onStop
    FragmentLifecycleActivity onStop
    fragment onDestroyView
    fragment onDestroy
    fragment onDetach
    FragmentLifecycleActivity onDestroy
    
    在 Activity 的 onCreate 中添加
    可以看到，除了 onCreate, onResume 在 Activity 之后
    onStart, onPause, onStop, onDestory 都在 Activity 之前。