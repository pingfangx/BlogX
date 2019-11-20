LayoutInspector 获取

    DecorView
        LinearLayout
            ViewStub(action_mod_bar_stub)
            FrameLayout
                ActionBarOverlayLayout
                    ContentFrameLayout(content)
                        内容
                    ActionBarContainer
        View(navigationBarBackground)
        View(statusBarBackground)
        
创建 DecorView， 向 DecorView 中通过某个布局 id 加载 View

加载之后通过 content id 查找作为 mConentParent