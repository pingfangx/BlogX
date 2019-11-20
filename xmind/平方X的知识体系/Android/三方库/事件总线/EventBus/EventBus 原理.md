S:
* 注册，记录该类定义哪些 EventType(类 -> List<EventType>)，然后将相关的订阅方法添加到 EventType 对应的订阅器中(EventType -> List<Subscription>)
* 取消注册，subscriptionsByEventType 根据该类中注册的所有事件类型移除 Subscription，typesBySubscriber 中移除当前类
* 发送，HandlerPoster，PendingPostQueue，入列，发送消息，收到消息后处理激活状态，一直从队列中取出并执行
* 粘性，stickyEvents，保存事件，后续注册时直接就收到事件