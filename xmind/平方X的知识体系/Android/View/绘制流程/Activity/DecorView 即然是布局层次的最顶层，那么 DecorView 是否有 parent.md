在 Window DecorView 创建时序图.puml 中看到

onCreate 中创建 DecorView 之后，DecorView 就是最顶层。

但是在 handleResumeActivity 中，会调用 WindowManagerImpl 的 addView 方法，将 DecorView 添加到 ViewRootImpl 当中

此时 ViewRootImpl 才是最顶层的 parent，相关的事件分发、绘制流程等，都是从 ViewRootImpl 开始的。
