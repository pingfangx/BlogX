# 开始
    
    //绘制
    com.cloudy.zxing.ViewfinderView#onDraw
    
    设置回调
    android.hardware.Camera#setOneShotPreviewCallback
    2 = {StackTraceElement@8547} "com.cloudy.zxing.camera.CameraManager.requestPreviewFrame(CameraManager.java:196)"
    3 = {StackTraceElement@8548} "com.cloudy.zxing.CaptureActivityHandler.restartPreviewAndDecode(CaptureActivityHandler.java:158)"
    4 = {StackTraceElement@8549} "com.cloudy.zxing.CaptureActivityHandler.<init>(CaptureActivityHandler.java:75)"
    5 = {StackTraceElement@8550} "com.cloudy.zxing.CaptureActivity.initCamera(CaptureActivity.java:241)"
    6 = {StackTraceElement@8551} "com.cloudy.zxing.CaptureActivity.surfaceCreated(CaptureActivity.java:188)"
    7 = {StackTraceElement@8552} "android.view.SurfaceView.updateSurface(SurfaceView.java:664)"
    
    //预览帧回调
    com.cloudy.zxing.camera.PreviewCallback#onPreviewFrame
    
    //解码
    com.cloudy.zxing.DecodeHandler#handleMessage
    com.cloudy.zxing.DecodeHandler#decode
    
    
    //解码结果
    com.cloudy.zxing.CaptureActivityHandler#handleMessage
    com.cloudy.zxing.CaptureActivity#handleDecode
    
    
# 扫码成功后会什么为停止
重新看设置预览回调的方法

    android.hardware.Camera#setOneShotPreviewCallback
    
该方法的注释为    
> Installs a callback to be invoked for the next preview frame in addition to displaying it on the screen. After one invocation, the callback is cleared. This method can be called any time, even when preview is live. Any other preview callbacks are overridden.
> If you are using the preview data to create video or still images, strongly consider using MediaActionSound to properly indicate image capture or recording start/stop to the user.

也就是只回调一次。
所以在识别失败后

    com.cloudy.zxing.CaptureActivityHandler#handleMessage
    else if (message.what == R.id.decode_failed) {// We're decoding as fast as possible, so when one decode fails, start another.
            state = State.PREVIEW;
            cameraManager.requestPreviewFrame(decodeThread.getHandler(), R.id.decode);
        }
        
    又重新启动了。
    
# 最后
所以我们在成功识别后，要想重新启动，也要重启一次。
    com.cloudy.zxing.CaptureActivity#restartPreviewAfterDelay
    com.cloudy.zxing.CaptureActivityHandler#handleMessage
    com.cloudy.zxing.CaptureActivityHandler#restartPreviewAndDecode
    com.cloudy.zxing.camera.CameraManager#requestPreviewFrame
    