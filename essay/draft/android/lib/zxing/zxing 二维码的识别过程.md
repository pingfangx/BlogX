
[zxing扫描二维码和识别图片二维码及其优化策略](https://blog.csdn.net/u012917700/article/details/52369175)  

[二维码的生成细节和原理](https://coolshell.cn/articles/10590.html)

# com.cloudy.zxing.DecodeHandler#decode
    
        PlanarYUVLuminanceSource source = activity.getCameraManager().buildLuminanceSource(data, width, height);
        if (source != null) {
            BinaryBitmap bitmap = new BinaryBitmap(new GlobalHistogramBinarizer(source));
            try {
                rawResult = multiFormatReader.decodeWithState(bitmap);
            } catch (ReaderException re) {
                // continue
            } finally {
                multiFormatReader.reset();
            }
        }