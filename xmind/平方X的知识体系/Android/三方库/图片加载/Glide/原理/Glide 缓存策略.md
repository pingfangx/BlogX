# 加载到同一个 Target
在 into 方法中，会创建 Target 和 Request，同时会检查 Target 对应的 Request  
通过 Target#setRequest 和 getRequest 设置获取，ViewTarget 是通过 tag 实现

如果 Target 的 Request 与当前的 Request 相同，会直接重新启动之前的 Request

如果之前的 Request 已经请求完成，会直接返回

# 从内存加载
com.bumptech.glide.load.engine.Engine#load
在 load 中创建 EngineKey, 通过 loadFromMemory 方法加载缓存
## loadFromActiveResources
活跃资源是 ActiveResources 类，以 key 为键，保存在 HashMap 中创建

每一项是 ResourceWeakReference，包含 key 的弱引用。

同时带有 queue，如果被回收则从 HashMap 中移除。

## loadFromCache
* LruCache
* new LinkedHashMap<>(100, 0.75f, true);
* com.bumptech.glide.util.LruCache#trimToSize


# 磁盘缓存
com.bumptech.glide.load.engine.DecodeJob#run

## DecodeJob.RESOURCE_CACHE
    com.bumptech.glide.load.engine.ResourceCacheGenerator#startNext
    ResourceCacheKey
## DecodeJob.DATA_CACHE
    com.bumptech.glide.load.engine.DataCacheGenerator#startNext
    DiskLruCache
    String safeKey = safeKeyGenerator.getSafeKey(key);

# 网络加载
DecodeJob.Stage#SOURCE