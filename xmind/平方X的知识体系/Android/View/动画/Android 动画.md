ObjectAnimator.ofObject 的原理以及 CircularRevealLinearLayout 示例中两种方法

View 中提到了 
从安卓 3.0 开始，对 view 进行动画较好的方式是使用 android.animation 包的相关 API。基于 Animator 的类改变 View 对象的真实属性，比如 alpha 、 translationX 等。这个行为与安卓 3.0 之前的基于 Animation 的类形成对比，之前的动画只能控制 view 在显示时的绘制。特别是 ViewPropertyAnimator 类使 View 的属性动画特别简单有效。

当然，你也可以用 3.0 以前的动画类来按制 view 的渲染。你可以给 view 附加一个 Animation 对象，用 setAnimation(android.view.animation.Animation) 或 startAnimation(android.view.animation.Animation) 方法。动画可以随时间改变 scale (缩放)，rotation (旋转)，translation (平移)和 alpha (透明度)。如果动画附加到一个有子 view 的 view，动画将会影响该 view 节点下的整个 view 树。当开始一个动画时，框架负责绘制合适的 view 直到动画完成。

9 新加的 
AnimatedImageDrawable
AnimatedVectorDrawable 

各动画的原理是什么

motionlayout

动画原理
start 动画不生效

属性动画