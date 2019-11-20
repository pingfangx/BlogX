# startService
    onCreate
    onStartCommand
    onDestroy

重复调用 startService 不会调用 onCreate 只会重复调用 onStartCommand

# bindService
    onCreate
    onBind
    onUmbind
    onDestroy