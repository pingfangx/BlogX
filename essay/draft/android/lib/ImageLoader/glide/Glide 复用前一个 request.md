加载缓存和联网加载，最后只请求了一次图片

    com.bumptech.glide.RequestBuilder#into(Y, com.bumptech.glide.request.RequestListener<TranscodeType>, com.bumptech.glide.request.RequestOptions)
    
      private <Y extends Target<TranscodeType>> Y into(
          @NonNull Y target,
          @Nullable RequestListener<TranscodeType> targetListener,
          @NonNull RequestOptions options) {
        Util.assertMainThread();
        Preconditions.checkNotNull(target);
        if (!isModelSet) {
          throw new IllegalArgumentException("You must call #load() before calling #into()");
        }

        options = options.autoClone();
        Request request = buildRequest(target, targetListener, options);

        Request previous = target.getRequest();
        if (request.isEquivalentTo(previous)
            && !isSkipMemoryCacheWithCompletePreviousRequest(options, previous)) {
          request.recycle();
          // If the request is completed, beginning again will ensure the result is re-delivered,
          // triggering RequestListeners and Targets. If the request is failed, beginning again will
          // restart the request, giving it another chance to complete. If the request is already
          // running, we can let it continue running without interruption.
          if (!Preconditions.checkNotNull(previous).isRunning()) {
            // Use the previous request rather than the new one to allow for optimizations like skipping
            // setting placeholders, tracking and un-tracking Targets, and obtaining View dimensions
            // that are done in the individual Request.
            previous.begin();
          }
          return target;
        }

        requestManager.clear(target);
        target.setRequest(request);
        requestManager.track(target, request);

        return target;
      }

    可以看到使用 com.bumptech.glide.request.Request#isEquivalentTo 判断
    
      @Override
      public boolean isEquivalentTo(Request o) {
        if (o instanceof SingleRequest) {
          SingleRequest<?> that = (SingleRequest<?>) o;
          return overrideWidth == that.overrideWidth
              && overrideHeight == that.overrideHeight
              && Util.bothModelsNullEquivalentOrEquals(model, that.model)
              && transcodeClass.equals(that.transcodeClass)
              && requestOptions.equals(that.requestOptions)
              && priority == that.priority
              // We do not want to require that RequestListeners implement equals/hashcode, so we don't
              // compare them using equals(). We can however, at least assert that the same amount of
              // request listeners are present in both requests
              && listenerCountEquals(this, that);
        }
        return false;
      }
      
    所以因为 model 相等（也就是图片地址相等），所以才只请求一次。