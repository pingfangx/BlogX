# 1 bug 流程
## 正常流程
启动动画 > 品牌动画 > 显示广告 > 跳转

## bug 触发流程
在显示广告延时过程中，按 back finish。  
在延时结束前，重新打开 app，此时延时结束会继续触发跳转，同时又重新走一遍跳转。  
因此会跳转两次。


# 2 测试 3 个延时过程
## 启动动画
android.view.View#postDelayed

在延时结束前关闭，在延时结束前重新打开  
延时结束继续触发，展示两次品牌动画，使用的是 android.view.View#startAnimation  
因为一个 View 只能展示一个动画，所以动画结束只会触发一次

## 品牌动画
android.view.animation.AnimationSet#setDuration

在延时结束前关闭，在延时结束前重新打开  
品牌动画结束触发两次，显示广告触发两次，但是只触发一次跳转

## 显示广告
android.view.View#postDelayed

在延时结束前关闭，在延时结束前重新打开，即 bug 触发情形  
第一次延时结束触发，跳转  
如果此时第二次走到了显示品牌动画，会继续动画 > 广告 > 跳转  
如果品牌动画还未开始，或刚开始执行（具体时间节点不确定），则会停住，当返回时才触发动画结束



# 3 相关知识点
## 使用 android.view.View#postDelayed 在 Activity finish 后不会执行

TODO 原理及原因

## android.view.View#startAnimation 在 Activity 跳转后不会继续执行，返回才继续

# 4 解决方案
禁用返回键的 finish