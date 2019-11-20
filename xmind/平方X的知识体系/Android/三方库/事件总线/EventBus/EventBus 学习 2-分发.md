# 分发
    org.greenrobot.eventbus.EventBus#post
    org.greenrobot.eventbus.EventBus#postSingleEvent
    org.greenrobot.eventbus.EventBus#postSingleEventForEventType
    根据事件类型调用
    
    private boolean postSingleEventForEventType(Object event, PostingThreadState postingState, Class<?> eventClass) {
        CopyOnWriteArrayList<Subscription> subscriptions;
        synchronized (this) {
            subscriptions = subscriptionsByEventType.get(eventClass);
        }
        if (subscriptions != null && !subscriptions.isEmpty()) {
            for (Subscription subscription : subscriptions) {
                postingState.event = event;
                postingState.subscription = subscription;
                boolean aborted = false;
                try {
                    postToSubscription(subscription, event, postingState.isMainThread);
                    aborted = postingState.canceled;
                } finally {
                    postingState.event = null;
                    postingState.subscription = null;
                    postingState.canceled = false;
                }
                if (aborted) {
                    break;
                }
            }
            return true;
        }
        return false;
    }
    
    private void postToSubscription(Subscription subscription, Object event, boolean isMainThread) {
        switch (subscription.subscriberMethod.threadMode) {
            case POSTING:
                invokeSubscriber(subscription, event);
                break;
            case MAIN:
                if (isMainThread) {
                    invokeSubscriber(subscription, event);
                } else {
                    mainThreadPoster.enqueue(subscription, event);
                }
                break;
            case MAIN_ORDERED:
                if (mainThreadPoster != null) {
                    mainThreadPoster.enqueue(subscription, event);
                } else {
                    // temporary: technically not correct as poster not decoupled from subscriber
                    invokeSubscriber(subscription, event);
                }
                break;
            case BACKGROUND:
                if (isMainThread) {
                    backgroundPoster.enqueue(subscription, event);
                } else {
                    invokeSubscriber(subscription, event);
                }
                break;
            case ASYNC:
                asyncPoster.enqueue(subscription, event);
                break;
            default:
                throw new IllegalStateException("Unknown thread mode: " + subscription.subscriberMethod.threadMode);
        }
    }
    
    void invokeSubscriber(Subscription subscription, Object event) {
        try {
            subscription.subscriberMethod.method.invoke(subscription.subscriber, event);
        } catch (InvocationTargetException e) {
            handleSubscriberException(subscription, event, e.getCause());
        } catch (IllegalAccessException e) {
            throw new IllegalStateException("Unexpected exception", e);
        }
    }
    可以看到调用 mainThreadPoster.enqueue
    接口方法为 org.greenrobot.eventbus.Poster#enqueue
    
# mainThreadPoster 的创建

    mainThreadSupport = builder.getMainThreadSupport();
    mainThreadPoster = mainThreadSupport != null ? mainThreadSupport.createPoster(this) : null;
    
    mainThreadSupport 的创建
        
    MainThreadSupport getMainThreadSupport() {
        if (mainThreadSupport != null) {
            return mainThreadSupport;
        } else if (Logger.AndroidLogger.isAndroidLogAvailable()) {
            Object looperOrNull = getAndroidMainLooperOrNull();
            return looperOrNull == null ? null :
                    new MainThreadSupport.AndroidHandlerMainThreadSupport((Looper) looperOrNull);
        } else {
            return null;
        }
    }
    
    class AndroidHandlerMainThreadSupport implements MainThreadSupport {

        private final Looper looper;

        public AndroidHandlerMainThreadSupport(Looper looper) {
            this.looper = looper;
        }

        @Override
        public boolean isMainThread() {
            return looper == Looper.myLooper();
        }

        @Override
        public Poster createPoster(EventBus eventBus) {
            return new HandlerPoster(eventBus, looper, 10);
        }
    }
    可以看到，最后实现 createPoster 是创建了一个 HandlerPoster
    
# org.greenrobot.eventbus.HandlerPoster#enqueue
    public class HandlerPoster extends Handler implements Poster {

        private final PendingPostQueue queue;
        private final int maxMillisInsideHandleMessage;
        private final EventBus eventBus;
        private boolean handlerActive;

        protected HandlerPoster(EventBus eventBus, Looper looper, int maxMillisInsideHandleMessage) {
            super(looper);
            this.eventBus = eventBus;
            this.maxMillisInsideHandleMessage = maxMillisInsideHandleMessage;
            queue = new PendingPostQueue();
        }

        public void enqueue(Subscription subscription, Object event) {
            //创建 pendingPost 池有大小限制
            PendingPost pendingPost = PendingPost.obtainPendingPost(subscription, event);
            synchronized (this) {
                //加入队列
                queue.enqueue(pendingPost);
                if (!handlerActive) {
                    handlerActive = true;
                    //如果未激活，则发送消息，如果已激活，收到消息会一直从队列中取
                    if (!sendMessage(obtainMessage())) {
                        throw new EventBusException("Could not send handler message");
                    }
                }
            }
        }

        @Override
        public void handleMessage(Message msg) {
            boolean rescheduled = false;
            try {
                long started = SystemClock.uptimeMillis();
                while (true) {
                    //出列
                    PendingPost pendingPost = queue.poll();
                    if (pendingPost == null) {
                        synchronized (this) {
                            //再检查
                            // Check again, this time in synchronized
                            pendingPost = queue.poll();
                            if (pendingPost == null) {
                                //没有 post 停止
                                handlerActive = false;
                                return;
                            }
                        }
                    }
                    //执行
                    eventBus.invokeSubscriber(pendingPost);
                    long timeInMethod = SystemClock.uptimeMillis() - started;
                    if (timeInMethod >= maxMillisInsideHandleMessage) {
                        //超时，重新发送
                        //TODO handleMessage 处理的时间限制
                        if (!sendMessage(obtainMessage())) {
                            throw new EventBusException("Could not send handler message");
                        }
                        rescheduled = true;
                        return;
                    }
                }
            } finally {
                handlerActive = rescheduled;
            }
        }
    }
    
    void invokeSubscriber(PendingPost pendingPost) {
        Object event = pendingPost.event;
        Subscription subscription = pendingPost.subscription;
        PendingPost.releasePendingPost(pendingPost);
        if (subscription.active) {
            invokeSubscriber(subscription, event);
        }
    }