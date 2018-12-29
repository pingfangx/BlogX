一开始看踩坑博文的时候看到了，但是并没有在官方的版本介绍里，因此没有注意。  
但是没想到测试时还是触发了，因为微信分享回调 Activity 就是一个透明，此 Activity 就不能设置方向。  
而官方版本介绍里没提，可能是因为这是一个 issue，被修复了的，而不是 feature

[Only fullscreen activities can request orientation？一个搞笑的坑！](https://zhuanlan.zhihu.com/p/32190223)

> 综上可见，这个改动的目的是想阻止非全屏的Activity锁定屏幕旋转，因为当前Activity是透明的，浮动的或可滑动取消的，是否锁屏应该由全屏的Activity决定，而不是并没有全部占据屏幕的Activity决定。

在合并的 manifest 中搜索的

    app/build/intermediates/merged_manifests/a_testDebug/processA_testDebugManifest/merged/AndroidManifest.xml

    screenorientation.*\n.*theme