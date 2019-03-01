布局内有两个 TextView ，它们有相同的 id。  
代码为

    mTvTitle.setText()
但是结果两个 TextView 的文字都变了。  
按理说只持有一个 TextView ，只能改变一个才对。

经过调试发现，TextView 由 helper 持有，  
而 helper 实例化了两次，两次实例化时持有了不同的 TextView。