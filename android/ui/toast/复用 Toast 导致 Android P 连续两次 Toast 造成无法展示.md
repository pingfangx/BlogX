# 复用 Toast 导致 Android P 连续两次 Toast 造成无法展示。

[Toast 原理](https://ivanljt.github.io/blog/2017/07/28/Toast%20%E5%8E%9F%E7%90%86%E6%B5%85%E6%9E%90/)


    android.widget.Toast#show
        
        public void show() {
            if (mNextView == null) {
                throw new RuntimeException("setView must have been called");
            }

            INotificationManager service = getService();
            String pkg = mContext.getOpPackageName();
            TN tn = mTN;
            tn.mNextView = mNextView;

            try {
                service.enqueueToast(pkg, tn, mDuration);
            } catch (RemoteException e) {
                // Empty
            }
        }
    NotificationManagerService.mService.enqueueToast
        ...
        
        // If the package already has a toast, we update its toast
        // in the queue, we don't move it to the end of the queue.
        if (index >= 0) {
            record = mToastQueue.get(index);
            record.update(duration);
            try {
                record.callback.hide();
            } catch (RemoteException e) {
            }
            record.update(callback);
        } else {
            Binder token = new Binder();
            mWindowManagerInternal.addWindowToken(token, TYPE_TOAST, DEFAULT_DISPLAY);
            record = new ToastRecord(callingPid, pkg, callback, duration, token);
            mToastQueue.add(record);
            index = mToastQueue.size() - 1;
        }
        keepProcessAliveIfNeededLocked(callingPid);
        // If it's at index 0, it's the current toast.  It doesn't matter if it's
        // new or just been updated.  Call back and tell it to show itself.
        // If the callback fails, this will remove it from the list, so don't
        // assume that it's valid after this.
        if (index == 0) {
            showNextToastLocked();
        }
        ...
    
    showNextToastLocked
        record.callback.show(record.token);
        scheduleDurationReachedLocked(record);
        
    这里 callback 就是 TN，而 scheduleDurationReachedLocked 则用来 hide
    com.android.server.notification.NotificationManagerService#scheduleDurationReachedLocked
    private void scheduleDurationReachedLocked(ToastRecord r)
    {
        mHandler.removeCallbacksAndMessages(r);
        Message m = Message.obtain(mHandler, MESSAGE_DURATION_REACHED, r);
        long delay = r.duration == Toast.LENGTH_LONG ? LONG_DELAY : SHORT_DELAY;
        mHandler.sendMessageDelayed(m, delay);
    }
    com.android.server.notification.NotificationManagerService.WorkerHandler#handleMessage
    com.android.server.notification.NotificationManagerService#handleDurationReached
    com.android.server.notification.NotificationManagerService#cancelToastLocked
        ToastRecord record = mToastQueue.get(index);
            record.callback.hide();
    
    接下来看 show 方法
    android.widget.Toast.TN#show
        public void show(IBinder windowToken) {
            if (localLOGV) Log.v(TAG, "SHOW: " + this);
            mHandler.obtainMessage(SHOW, windowToken).sendToTarget();
        }
        
    android.os.Handler#handleMessage
        case SHOW: {
            IBinder token = (IBinder) msg.obj;
            handleShow(token);
            break;
        }
    android.widget.Toast.TN#handleShow
            if (mHandler.hasMessages(CANCEL) || mHandler.hasMessages(HIDE)) {
                return;
            }
    调试发现 mHandler.hasMessages(HIDE) 为 true ，直接 return 了。
    
    HIDE 是通过 hide() 方法加的
    android.widget.Toast.TN#hide
        public void hide() {
            if (localLOGV) Log.v(TAG, "HIDE: " + this);
            mHandler.obtainMessage(HIDE).sendToTarget();
        }
        
# 项目中 bug 原因
在 enqueueToast 时，先调用了 TN#show  
在 handleMessage 之前，又调用了第二次 Toast#show  
于是 enqueueToast 再次调用，执行了 TN#hide  

当调用 handleMessage 时，因为 mHandler.hasMessages(HIDE) 导致都不展示了。

# 为什么 Android P 会出现该问题
比较 27 和 28 的 NotificationManagerService 源码，发现就是 28 多了下面的 hide 语句

        try {
            record.callback.hide();
        } catch (RemoteException e) {
        }
        
查看修改记录
定位到文件，然后 git blame ，查看指定行。
> With the blame view, you can view the line-by-line revision history for an entire file, or view the revision history of a single line within a file by clicking . Each time you click , you'll see the previous revision information for that line, including who committed the change and when.

[Hide previous toast from pkg before updating](https://github.com/aosp-mirror/platform_frameworks_base/commit/99298431b0badf5df62d7ec536da9152c7689a7e)


# 验证

    com.android.server.notification.NotificationManagerService#scheduleDurationReachedLocked
        
    static final int LONG_DELAY = PhoneWindowManager.TOAST_WINDOW_TIMEOUT;
    static final int SHORT_DELAY = 2000; // 2 seconds
        long delay = r.duration == Toast.LENGTH_LONG ? LONG_DELAY : SHORT_DELAY;
        
    com.android.server.policy.PhoneWindowManager#TOAST_WINDOW_TIMEOUT
    public static final int TOAST_WINDOW_TIMEOUT = 3500; // 3.5 seconds
    

    先展示 1 然后展示 2
        Toast.makeText(context, "1", Toast.LENGTH_LONG).show();
        view.postDelayed(new Runnable() {
            @Override
            public void run() {
                Toast.makeText(context, "2", Toast.LENGTH_LONG).show();
            }
        }, 500);
        
    展示 2
        Toast.makeText(context, "1", Toast.LENGTH_LONG).show();
        view.postDelayed(new Runnable() {
            @Override
            public void run() {
                Toast.makeText(context, "2", Toast.LENGTH_LONG).show();
            }
        }, 0);
        
    展示 2
    
        Toast.makeText(context, "1", Toast.LENGTH_LONG).show();
        Toast.makeText(context, "2", Toast.LENGTH_LONG).show();
    
    项目中则是复用 Toast （历史遗留代码）
    不展示
        Toast toast=Toast.makeText(context,"1",Toast.LENGTH_LONG);
        toast.show();
        toast.setText("2");
        toast.show();
        
# 解决
历史遗留的 ToastUtils 的复用实现是不需要的，可以看 NotificationManagerService 也作了优化。  
改变简单调用 Toast.makeTest().show() 即可。