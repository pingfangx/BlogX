glide 使用  placeholder 导至第一次加载出的图片大小异常

具体表现为，设置一张尺寸较大的 placeholder，比实际加载的图片大（或者因为 scaleType ，实际图片显示时宽度比 placeholder 小）  
在这种情况下，加载出的图片，会和 placeholder 一样大小，但是再次加载，会显示实际的大小（或满足 scaleType）

另外，如果加载出的图片要处理圆角，则 dontTransform 无效，需要 dontAnimate


这个问题与
[Android图片加载框架最全解析（五），Glide强大的图片变换功能](http://blog.csdn.net/guolin_blog/article/details/71524668)

中的问题好像一样，那是什么原因造成的呢。

查看加载
加在完成后，在 

    com.bumptech.glide.request.GenericRequest#onResourceReady(com.bumptech.glide.load.engine.Resource<?>, R) 

        if (requestListener == null || !requestListener.onResourceReady(result, model, target, loadedFromMemoryCache,
                isFirstResource)) {
            GlideAnimation<R> animation = animationFactory.build(loadedFromMemoryCache, isFirstResource);
            target.onResourceReady(result, animation);
        }
这里的 build 方法，构建了 GlideAnimation

    com.bumptech.glide.request.animation.DrawableCrossFadeFactory#build

    @Override
    public GlideAnimation<T> build(boolean isFromMemoryCache, boolean isFirstResource) {
        if (isFromMemoryCache) {
            return NoAnimation.get();
        } else if (isFirstResource) {
            return getFirstResourceAnimation();
        } else {
            return getSecondResourceAnimation();
        }
    }
第一次加载是时，isFromMemoryCache 为 false ，返回了一个 DrawableCrossFadeViewAnimation  
刷新时，返回了 NoAnimation

接下来，执行 animate

    com.bumptech.glide.request.target.ImageViewTarget#onResourceReady
    @Override
    public void onResourceReady(Z resource, GlideAnimation<? super Z> glideAnimation) {
        if (glideAnimation == null || !glideAnimation.animate(resource, this)) {
            setResource(resource);
        }
    }
    com.bumptech.glide.request.animation.DrawableCrossFadeViewAnimation#animate

    @Override
    public boolean animate(T current, ViewAdapter adapter) {
        Drawable previous = adapter.getCurrentDrawable();
        if (previous != null) {
            TransitionDrawable transitionDrawable = new TransitionDrawable(new Drawable[] { previous, current });
            transitionDrawable.setCrossFadeEnabled(true);
            transitionDrawable.startTransition(duration);
            adapter.setDrawable(transitionDrawable);
            return true;
        } else {
            defaultAnimation.animate(current, adapter);
            return false;
        }
    }
设置了一个 TransitionDrawable，会在 previous 和 current 中渐变  
这里的 current 是 GlideBitmapDrawable

    com.bumptech.glide.load.resource.bitmap.GlideBitmapDrawable#draw

    @Override
    public void draw(Canvas canvas) {
        if (applyGravity) {
            Gravity.apply(BitmapState.GRAVITY, width, height, getBounds(), destRect);
            applyGravity = false;
        }
        canvas.drawBitmap(state.bitmap, null, destRect, state.paint);
    }
这里，applyGravity 为 true ，然后运用后 destRect 就变了，于是按照 destRect 去绘制，所以就绘制错了。
而 applyGravity 的赋值在

    @Override
    protected void onBoundsChange(Rect bounds) {
        super.onBoundsChange(bounds);
        applyGravity = true;
    }
    
# 整理原因
第一次加载时设置了一个 GlideAnimation  
GlideAnimation 执行时设置了 TransitionDrawable  
最后是绘制 GlideBitmapDrawable#draw  
GlideBitmapDrawable 在 onBoundsChange 时更改了 applyGravity ，并且在 draw 修改了 bounds  
导致最后绘制出来的有问题

而这里的宽高又被 drawable 的宽高影响

    com.bumptech.glide.request.animation.DrawableCrossFadeViewAnimation#animate
    com.bumptech.glide.request.animation.GlideAnimation.ViewAdapter#setDrawable
    com.bumptech.glide.request.target.ImageViewTarget#setDrawable
    android.widget.ImageView#setImageDrawable
    android.widget.ImageView#updateDrawable
            mDrawableWidth = d.getIntrinsicWidth();
            mDrawableHeight = d.getIntrinsicHeight();
                android.graphics.drawable.LayerDrawable#getIntrinsicWidth
    android.widget.ImageView#configureBounds
            mDrawable.setBounds(0, 0, dwidth, dheight);
    android.graphics.drawable.Drawable#setBounds(int, int, int, int)
    android.graphics.drawable.Drawable#onBoundsChange
    com.bumptech.glide.load.resource.bitmap.GlideBitmapDrawable#onBoundsChange


而 drawable 的宽高被 transform 影响

    com.bumptech.glide.load.engine.EngineRunnable#decode
    com.bumptech.glide.load.engine.EngineRunnable#decodeFromSource
    com.bumptech.glide.load.engine.DecodeJob#decodeFromSource
    com.bumptech.glide.load.engine.DecodeJob#transformEncodeAndTranscode
    com.bumptech.glide.load.engine.DecodeJob#transform    
    com.bumptech.glide.load.resource.gifbitmap.GifBitmapWrapperTransformation#transform
    com.bumptech.glide.load.resource.bitmap.BitmapTransformation#transform(com.bumptech.glide.load.engine.Resource<android.graphics.Bitmap>, int, int)
        
        int targetWidth = outWidth == Target.SIZE_ORIGINAL ? toTransform.getWidth() : outWidth;
        int targetHeight = outHeight == Target.SIZE_ORIGINAL ? toTransform.getHeight() : outHeight;
        Bitmap transformed = transform(bitmapPool, toTransform, targetWidth, targetHeight);
    com.bumptech.glide.load.resource.bitmap.FitCenter#transform
    com.bumptech.glide.load.resource.bitmap.TransformationUtils#fitCenter
    

# 解决方案
## 设置 scaleType
    com.bumptech.glide.GenericRequestBuilder#into(android.widget.ImageView)
    不运用 transform，默认为 UnitTransformation

## 设置 dontTransform
    添加一个 UnitTransformation
    com.bumptech.glide.GenericRequestBuilder#into(android.widget.ImageView)
    isTransformationSet 补赋为 true ，不再添加
    应此不处理，不影响宽高

## 设置 dontAnimate
    animationFactory 设置为 NoAnimationFactory
    com.bumptech.glide.request.GenericRequest#onResourceReady(com.bumptech.glide.load.engine.Resource<?>, R) 
    最后在调用 com.bumptech.glide.request.animation.NoAnimation#animate 时返回 false

## 设置 .override(Target.SIZE_ORIGINAL, Target.SIZE_ORIGINAL)

com.bumptech.glide.load.resource.bitmap.BitmapTransformation#transform(com.bumptech.glide.load.engine.Resource<android.graphics.Bitmap>, int, int)

处理宽高时使用的原始宽高