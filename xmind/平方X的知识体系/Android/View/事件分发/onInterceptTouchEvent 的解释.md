onInterceptTouchEvent 的文档中有以下几点

1. 你将在这里收到 down 事件。
2. down 事件将由此 view group 的一个 child 处理，或者由你自己的 onTouchEvent() 方法处理；  
2.1 这意味着你应该实现 onTouchEvent() 以返回 true，这样你将继续看到手势的其余部分(而不是寻找 parent view 来处理它)。  
2.2 此外，通过从 onTouchEvent() 返回 true，你将不会在 onInterceptTouchEvent() 中收到任何后续事件，并且所有触摸必须像正常一样在 onTouchEvent() 中处理。
3. 只要你从这个函数返回 false，每个后续事件(直到并包括最后一个 up)将首先转发到这里，然后转发到目标的 onTouchEvent()。
4. 如果从此处返回 true，则不会收到任何后续事件：目标 view 将接收相同的事件，但操作是 {@link MotionEvent#ACTION_CANCEL}，所有其他事件将被传递到你的 onTouchEvent() 方法，不再出现在这里。

# 结合源码


            // 检查拦截。
            final boolean intercepted;
            if (actionMasked == MotionEvent.ACTION_DOWN // 1 首先收到 down 事件
                    || mFirstTouchTarget != null) {
                // 2.2 因为 mFirstTouchTarget 为 null，不会再调用 onInterceptTouchEvent
                // 3 如果 mFirstTouchTarget 不为 null，总是会调用 onInterceptTouchEvent
                final boolean disallowIntercept = (mGroupFlags & FLAG_DISALLOW_INTERCEPT) != 0;
                if (!disallowIntercept) {
                    intercepted = onInterceptTouchEvent(ev);
                    ev.setAction(action); // 恢复操作以防更改
                } else {
                    intercepted = false;
                }
            } else {
                // 没有触摸目标，并且此操作不是初始 down，因此此 view group 继续拦截触摸。
                //
                intercepted = true;
            }
            
            ...

            // 分发到触摸目标。
            // 2 由自己处理或 child 处理
            if (mFirstTouchTarget == null) {
                // 没有触摸目标，因此把它当作一个普通 view。
                // 2.1 收到后续的事件
                handled = dispatchTransformedTouchEvent(ev, canceled, null,
                        TouchTarget.ALL_POINTER_IDS);
            } else {
                // 分发到触摸目标，但如果我们已经发送到新的触摸目标，则不包括它。
                // 如果需要，取消触摸目标。
                TouchTarget predecessor = null;
                TouchTarget target = mFirstTouchTarget;
                while (target != null) {
                    final TouchTarget next = target.next;
                    if (alreadyDispatchedToNewTouchTarget && target == newTouchTarget) {
                        handled = true;
                    } else {
                        // 4 如果 intercepted 返回了 true，同时有 target 就会执行 cancel
                        final boolean cancelChild = resetCancelNextUpFlag(target.child)
                                || intercepted;
                        if (dispatchTransformedTouchEvent(ev, cancelChild,
                                target.child, target.pointerIdBits)) {
                            handled = true;
                        }
                        if (cancelChild) {
                            if (predecessor == null) {
                                mFirstTouchTarget = next;
                            } else {
                                predecessor.next = next;
                            }
                            target.recycle();
                            target = next;
                            continue;
                        }
                    }
                    predecessor = target;
                    target = next;
                }
            }