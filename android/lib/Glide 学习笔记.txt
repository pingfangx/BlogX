http://blog.csdn.net/guolin_blog/article/details/53759439

* 默认使用 RGB_565 是在哪里初始化设置加载的
* 缓存策略，是如何缓存与读取缓存的

郭霖 大佬的文章已经分析了很多，于是按他的文章进行学习，也学习一下详细分析的一些步骤。

# 0x01 Glide的基本用法

## 配置
    apply plugin: 'kotlin-kapt'
    ...
    compile 'com.github.bumptech.glide:glide:4.5.0'
    kapt 'com.github.bumptech.glide:compiler:4.5.0'
    ...
    <uses-permission android:name="android.permission.INTERNET" />

## 使用
v3 与 v4 的用法区别还是很大的，也是醉醉的。

Glide 改为了 GlideApp

        GlideApp.with(this)
                .load("https://www.baidu.com/img/bd_logo1.png")
                .placeholder(R.mipmap.ic_launcher)
                .error(R.mipmap.ic_launcher_round)
                .transition(DrawableTransitionOptions.withCrossFade(3000))
                .circleCrop()
                .override(50, 100)
                .diskCacheStrategy(DiskCacheStrategy.NONE)
                .into(iv)
                
                
# 0x02 执行流程
> 应该认准一个功能点，然后去分析这个功能点是如何实现的。但只要去追寻主体的实现逻辑即可，千万不要试图去搞懂每一行代码都是什么意思，那样很容易会陷入到思维黑洞当中，而且越陷越深。因为这些庞大的系统都不是由一个人写出来的，每一行代码都想搞明白，就会感觉自己是在盲人摸象，永远也研究不透。如果只是去分析主体的实现逻辑，那么就有比较明确的目的性，这样阅读源码会更加轻松，也更加有成效。
## with
通过 context 参数创建一个 RequestManagerRetriever，然后调用 com.bumptech.glide.manager.RequestManagerRetriever 的 get 方法。

创建时，会添加一个 com.bumptech.glide.manager.RequestManagerFragment ，用于监听生命周期。

## load
已经简化为一个 RequestBuilder

## into
* 创建 ViewTarget 和 Request
* 调用 Request.begin
* 回调 Request.onSiezeReady
* Engine 创建 EnginJob ，执行 EngineJob#start
* DecodeJob 生成 DataFetcherGenerator，创建 DataFetcher 执行 loadData
* 回调 onDataFetcherReady
* DecodeJob 执行 Decode 
* EnginJob 回调 onResourceReady，通过 Handler 传到主线程，回调 Request
* Request 回调 onResourceReady
* ViewTarget 回调 onResourceReady

## 相关问题
### ViewTarget 是如何创建的
调用的 GlideContext#buildImageViewTarget ，使用 imageViewTargetFactory 创建  
该 Factory 在 Glide 初始时，在初始化时 GlideContent 时 new 了一个。

### Request 是如何创建的
RequestBuilder#buildRequest 方法，在 buildRequestRecursive 中绕啊绕，但因为执行 obtainRequest 所以生成 SingleRequest

### DataFetcherGenerator 是如何工作的
在 getNextGenerator 中生成，传递的 decodeHelper 是 DecodeJob 初始化的。  
DecodeHelper#getLoadData 通过 Registry#getModelLoaders 来获取 ModelLoader  
这些 ModelLoader 在 Glide 初始化时注册，调用 ModelLoader#buildLoadData 生成 LoadData  
然后调用 loadData.fetcher.loadData  
com.bumptech.glide.load.model.MultiModelLoader.MultiFetcher#loadData  
com.bumptech.glide.load.data.HttpUrlFetcher#loadData  

### 加载的数据是如何 decode 的
在 HttpUrlFetcher#loadData 中返回 InputStream  
传到 SourceGenerator#onDataReady  
再到 DecodeJob#onDataFetcherReady，在 DecodeJob 处理，获取 LoadPath
执行 LoadPath#load  
DecodePath#decode  
ResourceDecoder#decode
Downsampler#decode
Downsampler#calculateScaling
Downsampler#calculateConfig

### 默认的 Config 是怎么换成 ARGB_8888
    在 com.bumptech.glide.load.resource.bitmap.Downsampler#decode(java.io.InputStream, int, int, com.bumptech.glide.load.Options, com.bumptech.glide.load.resource.bitmap.Downsampler.DecodeCallbacks)
    中有 DecodeFormat decodeFormat = options.get(DECODE_FORMAT);
    public static final Option<DecodeFormat> DECODE_FORMAT = Option.memory(
      "com.bumptech.glide.load.resource.bitmap.Downsampler.DecodeFormat", DecodeFormat.DEFAULT);
    
    com.bumptech.glide.load.DecodeFormat#DEFAULT
    public static final DecodeFormat DEFAULT = PREFER_ARGB_8888_DISALLOW_HARDWARE;
而 3.0 的默认值为 PREFER_RGB_565

### 有透明度时是如何处理的
    在 com.bumptech.glide.load.resource.bitmap.Downsampler#calculateConfig 有判断
    获取类型 DefaultImageHeaderParser#getType(com.bumptech.glide.load.resource.bitmap.DefaultImageHeaderParser.Reader)
    通过读取前面部分字节判断类型，然后判断是否有为透明度 PNG_A 和 WEBP_A 有

### placeholder 是如何生效的
持有 com.bumptech.glide.RequestBuilder#requestOptions
在创建 Request 时传递过去，在 com.bumptech.glide.request.SingleRequest#begin 方法中调用了  
com.bumptech.glide.request.target.Target#onLoadStarted，此时传的 placeholder 即从 requestOptions 中获取。

### error 是如何生效的
    com.bumptech.glide.load.data.HttpUrlFetcher#loadData 回调
    com.bumptech.glide.load.engine.SourceGenerator#onLoadFailed  再回调  
    com.bumptech.glide.load.engine.DecodeJob#onDataFetcherFailed
    com.bumptech.glide.load.engine.DecodeJob#notifyFailed
    com.bumptech.glide.request.SingleRequest#onLoadFailed(com.bumptech.glide.load.engine.GlideException, int)
    com.bumptech.glide.request.SingleRequest#setErrorPlaceholder

### override 如何生效
override 宽高从 RequestBuilder → Request → Engine → DecodeJob ，最后传给 decode 去了，所以只用于加载出的数据的 decode

### transform 怎么生效
decode 成功后，回调 com.bumptech.glide.load.engine.DecodeJob#onResourceDecoded
之前通过 com.bumptech.glide.request.RequestOptions#transform(com.bumptech.glide.load.Transformation<android.graphics.Bitmap>)
添加到 transformations 中，回调时执行
com.bumptech.glide.load.Transformation#transform


# 0x03 缓存
## 内存缓存
    Glide 的构造，在 com.bumptech.glide.GlideBuilder#build 中  
    new 了一个 LruResourceCache，  
    作为参数 new 了一个 Engine  
    engine 作为参数 new 了 glide  

### 弱引用
    com.bumptech.glide.load.engine.Engine#load
    com.bumptech.glide.load.engine.Engine#loadFromActiveResources
    弱引用保存加载中的缓存
    
    保存
    com.bumptech.glide.load.engine.EngineJob#handleResultOnMainThread
    com.bumptech.glide.load.engine.Engine#onEngineJobComplete
    以及下面的从外部加载
### LruCache
com.bumptech.glide.load.engine.Engine#loadFromCache  
TODO Lru 原理

    com.bumptech.glide.load.engine.EngineResource#acquire
    com.bumptech.glide.load.engine.EngineResource#release
    com.bumptech.glide.load.engine.Engine#onResourceReleased
    
内存缓存，先从 activeResources 读取。
如果没有，则从 LruCache 读取，读取后移除，加入 activeResources  
释放使用时，从 activeResources 移除，写入 LruCache

## 硬盘缓存
    getNextGenerator 返回 ResourceCacheGenerator 或 DataCacheGenerator
    然后分别在它们的 startNext 中获取，注意 key 的不同
    
    写入：
    com.bumptech.glide.load.engine.DecodeJob#onDataFetcherReady
    com.bumptech.glide.load.engine.DecodeJob#decodeFromRetrievedData
    先调用 com.bumptech.glide.load.engine.DecodeJob#decodeFromData
    回调 com.bumptech.glide.load.engine.DecodeJob#onResourceDecoded
    com.bumptech.glide.load.engine.DecodeJob.DeferredEncodeManager#init
    
    然后调用 com.bumptech.glide.load.engine.DecodeJob#notifyEncodeAndRelease
    com.bumptech.glide.load.engine.DecodeJob.DeferredEncodeManager#encode
    
# 0x04 自定义组件
前面还有两篇，回调与监听，图片变换，这里不详述了。  
## 如何加载的
    通过注解，生成了 GeneratedAppGlideModuleImpl，内部包含自定义的 AppGlideModule  
    相关操作传到 GeneratedAppGlideModuleImpl，再转到自定义的 AppGlideModule
    
    com.bumptech.glide.Glide#getAnnotationGeneratedGlideModules
    
    也可以获取 manifest 中的 com.bumptech.glide.module.ManifestParser#parse

# LruCache
[bumptech/glide](https://github.com/bumptech/glide)  
[JakeWharton/DiskLruCache](https://github.com/JakeWharton/DiskLruCache)  
[ Android DiskLruCache完全解析，硬盘缓存的最佳方案](http://blog.csdn.net/guolin_blog/article/details/28863651)

