# 报错
    class com.bumptech.glide.load.engine.GlideException: Failed to load resource
      Cause (1 of 4): class com.bumptech.glide.load.engine.GlideException: Failed LoadPath{DirectByteBuffer->GifDrawable->GifDrawable}, DATA_DISK_CACHE, https://dftest.00bang.net/images/T1tkJTB4VT1RCvBVdK.gif
    
    直接断点 GlideException 的构造函数
    

      @NonNull
      private Resource<ResourceType> decodeResourceWithList(DataRewinder<DataType> rewinder, int width,
          int height, @NonNull Options options, List<Throwable> exceptions) throws GlideException {
        Resource<ResourceType> result = null;
        //noinspection ForLoopReplaceableByForEach to improve perf
        for (int i = 0, size = decoders.size(); i < size; i++) {
          ResourceDecoder<DataType, ResourceType> decoder = decoders.get(i);
          try {
            DataType data = rewinder.rewindAndGet();
            if (decoder.handles(data, options)) {
              data = rewinder.rewindAndGet();
              result = decoder.decode(data, width, height, options);
            }
            // Some decoders throw unexpectedly. If they do, we shouldn't fail the entire load path, but
            // instead log and continue. See #2406 for an example.
          } catch (IOException | RuntimeException | OutOfMemoryError e) {
            if (Log.isLoggable(TAG, Log.VERBOSE)) {
              Log.v(TAG, "Failed to decode data for " + decoder, e);
            }
            exceptions.add(e);
          }

          if (result != null) {
            break;
          }
        }

        if (result == null) {
          throw new GlideException(failureMessage, new ArrayList<>(exceptions));
        }
        return result;
      }
      
      因为 if (decoder.handles(data, options)) 返回 false
      
      @Override
      public boolean handles(@NonNull InputStream source, @NonNull Options options) throws IOException {
        return !options.get(GifOptions.DISABLE_ANIMATION)
            && ImageHeaderParserUtils.getType(parsers, source, byteArrayPool) == ImageType.GIF;
      }
      
      设置了禁用动画
      查看 options 的赋值
      发现以前为了设置圆角而设置了 dontAnimate()