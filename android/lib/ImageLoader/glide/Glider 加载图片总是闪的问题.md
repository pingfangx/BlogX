使用 Glide 调试发没有使用缓存

    com.bumptech.glide.request.SingleRequest#begin
    com.bumptech.glide.request.SingleRequest#onSizeReady
    com.bumptech.glide.load.engine.Engine#load
    com.bumptech.glide.load.engine.Engine#loadFromCache
    com.bumptech.glide.load.engine.Engine#getEngineResourceFromCache
    发现 key 不致，也就是 key 的 hashCode 计算不一致
    com.bumptech.glide.util.LruCache#remove
    com.bumptech.glide.load.engine.EngineKey#hashCode
    
      public int hashCode() {
        if (hashCode == 0) {
          hashCode = model.hashCode();
          hashCode = 31 * hashCode + signature.hashCode();
          hashCode = 31 * hashCode + width;
          hashCode = 31 * hashCode + height;
          hashCode = 31 * hashCode + transformations.hashCode();
          hashCode = 31 * hashCode + resourceClass.hashCode();
          hashCode = 31 * hashCode + transcodeClass.hashCode();
          hashCode = 31 * hashCode + options.hashCode();
        }
        return hashCode;
      }

发现是 transformations 的 hashCode 总是变，其类型为
    com.bumptech.glide.util.CachedHashCodeArrayMap
    
    
最后发现是因为 继承了 BitmapTransformation 但是没有重写 hashCode  

    com.bumptech.glide.load.Key#updateDiskCacheKey
    
重写了 hashCode 之后还是不行，因为
    java.util.HashMap#removeNode
    在移除时使用了 equals 判断，也就是一开始说的 hashCode 与 equals 要对应。
    
于是参照

    com.bumptech.glide.load.resource.bitmap.RoundedCorners

修改为

    
    @Override
    public boolean equals(Object o) {
        if (o instanceof RotateTransformation) {
            RotateTransformation other = (RotateTransformation) o;
            return rotateRotationAngle == other.rotateRotationAngle;
        }
        return false;
    }

    @Override
    public int hashCode() {
        return Util.hashCode(ID.hashCode(),
                Util.hashCode(rotateRotationAngle));
    }
也可以直接使用 IDEA 工具生成。

## 修改 hashCode 和 equals
## 修改 downloadOnly 使用缓存
  虽然使用缓存是不推荐的
  private EngineResource<?> loadFromCache(Key key, boolean isMemoryCacheable) {
    if (!isMemoryCacheable) {
      return null;
    }
    ...
    
最后是帖子大图会闪，这是因为 setData 总是清空重新加载。