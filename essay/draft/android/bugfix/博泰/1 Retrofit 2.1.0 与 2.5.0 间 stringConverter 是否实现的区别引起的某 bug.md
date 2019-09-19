集成某第三方，其使用的 Retrofit 为 2.1.0，集成到项目中后，项目中是 2.5.0

最后发现是 retrofit2.Retrofit.stringConverter 中  
默认的 BuiltInConverters 是否实现 stringConverter 引起的

但是后续修改了报错 javax.net.ssl.SSLPeerUnverifiedException

请求出错，异常信息

    read:223, ReflectiveTypeAdapterFactory$Adapter (com.google.gson.internal.bind)
    fromJson:887, Gson (com.google.gson)
    fromJson:852, Gson (com.google.gson)
    fromJson:801, Gson (com.google.gson)
    fromJson:773, Gson (com.google.gson)
    setMessage:40, RestError (com.qinggan.mobile.tsp.restmiddle)
    onFailure:70, RestCallback (com.qinggan.mobile.tsp.restmiddle)
    run:80, ExecutorCallAdapterFactory$ExecutorCallbackCall$1$2 (retrofit2)
    handleCallback:873, Handler (android.os)
    dispatchMessage:99, Handler (android.os)
    loop:193, Looper (android.os)
    main:6669, ActivityThread (android.app)
    invoke:-1, Method (java.lang.reflect)
    run:493, RuntimeInit$MethodAndArgsCaller (com.android.internal.os)
    main:858, ZygoteInit (com.android.internal.os)

可以看到是执行的 ExecutorCallAdapterFactory 中的某内部类的 run，定位到 80 行

    @Override public void enqueue(final Callback<T> callback) {
      checkNotNull(callback, "callback == null");

      delegate.enqueue(new Callback<T>() {
        @Override public void onResponse(Call<T> call, final Response<T> response) {
          callbackExecutor.execute(new Runnable() {
            @Override public void run() {
              if (delegate.isCanceled()) {
                // Emulate OkHttp's behavior of throwing/delivering an IOException on cancellation.
                callback.onFailure(ExecutorCallbackCall.this, new IOException("Canceled"));
              } else {
                callback.onResponse(ExecutorCallbackCall.this, response);
              }
            }
          });
        }

        @Override public void onFailure(Call<T> call, final Throwable t) {
          callbackExecutor.execute(new Runnable() {
            @Override public void run() {
              //80 行
              callback.onFailure(ExecutorCallbackCall.this, t);
            }
          });
        }
      });
    }
    
看到是是失败时的回调，下断到失败线程

    onFailure:78, ExecutorCallAdapterFactory$ExecutorCallbackCall$1 (retrofit2)
    enqueue:109, OkHttpCall (retrofit2)
    enqueue:63, ExecutorCallAdapterFactory$ExecutorCallbackCall (retrofit2)
    asyncMethod:238, TspManager (com.qinggan.mobile.tsp.manager)
    requestUserLogin:303, TspManager (com.qinggan.mobile.tsp.manager)

查看抛出的 t 的堆栈

    java.lang.ClassCastException: java.lang.String cannot be cast to okhttp3.ResponseBody
    
    0 = {StackTraceElement@13633} "com.qinggan.mobile.tsp.a.c.convert(MZRestGsonResponseBodyConverter.java:33)"
    1 = {StackTraceElement@13634} "retrofit2.ParameterHandler$Field.apply(ParameterHandler.java:223)"
    2 = {StackTraceElement@13635} "retrofit2.RequestFactory.create(RequestFactory.java:108)"
    3 = {StackTraceElement@13636} "retrofit2.OkHttpCall.createRawCall(OkHttpCall.java:190)"
    4 = {StackTraceElement@13637} "retrofit2.OkHttpCall.enqueue(OkHttpCall.java:100)"
    5 = {StackTraceElement@13638} "retrofit2.ExecutorCallAdapterFactory$ExecutorCallbackCall.enqueue(ExecutorCallAdapterFactory.java:63)"
    6 = {StackTraceElement@13639} "com.qinggan.mobile.tsp.manager.TspManager.asyncMethod(TspManager.java:238)"
    7 = {StackTraceElement@13640} "com.qinggan.mobile.tsp.manager.TspManager.requestUserLogin(TspManager.java:303)"

可以看到是 MZRestGsonResponseBodyConverter（混淆为 c） 执行 convert 时出现异常  
执行 retrofit2.ParameterHandler.Field#apply 是使用 valueConverter

      static final class Field<T> extends ParameterHandler<T> {
        private final String name;
        private final Converter<T, String> valueConverter;
        private final boolean encoded;

        Field(String name, Converter<T, String> valueConverter, boolean encoded) {
          this.name = checkNotNull(name, "name == null");
          this.valueConverter = valueConverter;
          this.encoded = encoded;
        }

        @Override void apply(RequestBuilder builder, @Nullable T value) throws IOException {
          if (value == null) return; // Skip null values.

          String fieldValue = valueConverter.convert(value);
          if (fieldValue == null) return; // Skip null converted values

          builder.addFormField(name, fieldValue, encoded);
        }
      }

下断构造函数查看 valueConverter 是如何赋值的

      <init>:216, ParameterHandler$Field (retrofit2)
      parseParameterAnnotation:547, RequestFactory$Builder (retrofit2)
      parseParameter:295, RequestFactory$Builder (retrofit2)
      build:182, RequestFactory$Builder (retrofit2)
      parseAnnotations:65, RequestFactory (retrofit2)
      parseAnnotations:25, ServiceMethod (retrofit2)
      loadServiceMethod:168, Retrofit (retrofit2)
      invoke:147, Retrofit$1 (retrofit2)
      invoke:1006, Proxy (java.lang.reflect)
      userLogin:-1, $Proxy6
      requestUserLogin:303, TspManager (com.qinggan.mobile.tsp.manager)
      loginTest:121, RemoteManager (com.qinggan.mobile.tsp.remote)
      test:20, CarControlActivityTest (com.cloudy.linglingbang.activity.car.connected)
      run:65, BaseInstrumentedTest$2 (com.cloudy.linglingbang)
      handleCallback:873, Handler (android.os)
      dispatchMessage:99, Handler (android.os)
      loop:193, Looper (android.os)
      main:6669, ActivityThread (android.app)
      invoke:-1, Method (java.lang.reflect)
      run:493, RuntimeInit$MethodAndArgsCaller (com.android.internal.os)
      main:858, ZygoteInit (com.android.internal.os)

parseParameterAnnotation 中的代码

          Converter<?, String> converter =
              retrofit.stringConverter(type, annotations);
          return new ParameterHandler.Field<>(name, converter, encoded);

调用的是 retrofit2.Retrofit#stringConverter

      public <T> Converter<T, String> stringConverter(Type type, Annotation[] annotations) {
        checkNotNull(type, "type == null");
        checkNotNull(annotations, "annotations == null");

        for (int i = 0, count = converterFactories.size(); i < count; i++) {
          Converter<?, String> converter =
              converterFactories.get(i).stringConverter(type, annotations, this);
          if (converter != null) {
            //noinspection unchecked
            return (Converter<T, String>) converter;
          }
        }

        // Nothing matched. Resort to default converter which just calls toString().
        //noinspection unchecked
        return (Converter<T, String>) BuiltInConverters.ToStringConverter.INSTANCE;
      }

可以看到由 converterFactories 处理
那么 converterFactories 是如何设置的  
下断 retrofit2.Retrofit.Builder.addConverterFactory

        addConverterFactory:523, Retrofit$Builder (retrofit2)
        newRetrofit:82, ServiceManager (com.qinggan.mobile.tsp.manager)
        getService:98, ServiceManager (com.qinggan.mobile.tsp.manager)
        requestUserLogin:303, TspManager (com.qinggan.mobile.tsp.manager)
        loginTest:121, RemoteManager (com.qinggan.mobile.tsp.remote)
        test:20, CarControlActivityTest (com.cloudy.linglingbang.activity.car.connected)
        run:65, BaseInstrumentedTest$2 (com.cloudy.linglingbang)
        handleCallback:873, Handler (android.os)
        dispatchMessage:99, Handler (android.os)
        loop:193, Looper (android.os)
        main:6669, ActivityThread (android.app)
        invoke:-1, Method (java.lang.reflect)
        run:493, RuntimeInit$MethodAndArgsCaller (com.android.internal.os)
        main:858, ZygoteInit (com.android.internal.os)
可以看到是创建的是候调用的 addConverterFactory

        com.qinggan.mobile.tsp.a.a


最终定位到了转换类为 com.qinggan.mobile.tsp.a.c

回到一开始的异常

    java.lang.ClassCastException: java.lang.String cannot be cast to okhttp3.ResponseBody
    0 = {StackTraceElement@13633} "com.qinggan.mobile.tsp.a.c.convert(MZRestGsonResponseBodyConverter.java:33)"

    public T a(ResponseBody var1) {
        Object var4;
        try {
            String var2 = var1.string();
            Log.d("Gson", "response json --> " + var2);
            Object var3 = null;

            try {
                var3 = this.c.fromJson(var2);
                Log.e("Gson", "object --> " + var3);
            } catch (Exception var8) {
                Log.e("Gson", "handle exception");
                var3 = this.a(var3, var2);
            }

            var4 = var3;
        } finally {
            var1.close();
        }

        return var4;
    }



    但是 c 中没有 convert 方法，javap -c -p 查看
      public java.lang.Object convert(java.lang.Object);
        Code:
           0: aload_0
           1: aload_1
           2: checkcast     #14                 // class okhttp3/ResponseBody
           5: invokevirtual #25                 // Method a:(Lokhttp3/ResponseBody;)Ljava/lang/Object;
           8: areturn

    可以看到直接转为 ResponseBody，然后调用 a 方法
    也就是说此时传到 convert 的参数是 String，但是它想要的是 ResponseBody  
    于是转换异常了。

为了了解转换逻辑，先断点看一下旧版本的逻辑

    a:45, c (com.qinggan.mobile.tsp.a)
    convert:33, c (com.qinggan.mobile.tsp.a)
    toResponse:117, ServiceMethod (retrofit2)
    parseResponse:211, OkHttpCall (retrofit2)
    onResponse:106, OkHttpCall$1 (retrofit2)
    execute:135, RealCall$AsyncCall (okhttp3)
    run:32, NamedRunnable (okhttp3.internal)
    runWorker:1167, ThreadPoolExecutor (java.util.concurrent)
    run:641, ThreadPoolExecutor$Worker (java.util.concurrent)
    run:764, Thread (java.lang)

按顺序看一下

    okhttp3.internal.NamedRunnable.run
        execute();
    okhttp3.RealCall.AsyncCall.execute

        Response response = getResponseWithInterceptorChain();
        if (retryAndFollowUpInterceptor.isCanceled()) {
          signalledCallback = true;
          responseCallback.onFailure(RealCall.this, new IOException("Canceled"));
        } else {
          signalledCallback = true;
          responseCallback.onResponse(RealCall.this, response);
        }
    okhttp3.Callback.onResponse
        response = parseResponse(rawResponse);
    retrofit2.OkHttpCall.parseResponse

        ExceptionCatchingRequestBody catchingBody = new ExceptionCatchingRequestBody(rawBody);
        try {
          T body = serviceMethod.toResponse(catchingBody);
          return Response.success(body, rawResponse);
        } catch (RuntimeException e) {
          // If the underlying source threw an exception, propagate that rather than indicating it was
          // a runtime exception.
          catchingBody.throwIfCaught();
          throw e;
        }
    retrofit2.ServiceMethod.toResponse
          T toResponse(ResponseBody body) throws IOException {
            return responseConverter.convert(body);
          }
    com.qinggan.mobile.tsp.a.c.a(okhttp3.ResponseBody)

可以看到，旧版本是用来转换结果的，设置过程为

    ServiceMethod
        this.responseConverter = builder.responseConverter;
    retrofit2.ServiceMethod.Builder.build
         responseConverter = createResponseConverter();
    retrofit2.ServiceMethod.Builder.createResponseConverter
        return retrofit.responseBodyConverter(responseType, annotations);
    retrofit2.Retrofit.responseBodyConverter
    retrofit2.Retrofit.nextResponseBodyConverter

        int start = converterFactories.indexOf(skipPast) + 1;
        for (int i = start, count = converterFactories.size(); i < count; i++) {
          Converter<ResponseBody, ?> converter =
              converterFactories.get(i).responseBodyConverter(type, annotations, this);
          if (converter != null) {
            //noinspection unchecked
            return (Converter<ResponseBody, T>) converter;
          }
        }

# 原本是用来转换结果的，为什么被用来转换字段了
创建 call 并入列的过程，在 retrofit2.OkHttpCall.enqueue 中

          call = rawCall = createRawCall();
          call.enqueue(...)

2.1.0 创建 call

    enqueue:85, OkHttpCall (retrofit2)
    createRawCall:178, OkHttpCall (retrofit2)
    toRequest:109, ServiceMethod (retrofit2)
    apply:182, ParameterHandler$Field (retrofit2)
        builder.addFormField(name, valueConverter.convert(value), encoded);
    convert:58, BuiltInConverters$StringConverter (retrofit2)
    convert:62, BuiltInConverters$StringConverter (retrofit2)
        return value;

2.5.0 中创建 call

    java.lang.ClassCastException: java.lang.String cannot be cast to okhttp3.ResponseBody
    0 = {StackTraceElement@13633} "com.qinggan.mobile.tsp.a.c.convert(MZRestGsonResponseBodyConverter.java:33)"
    1 = {StackTraceElement@13634} "retrofit2.ParameterHandler$Field.apply(ParameterHandler.java:223)"
    2 = {StackTraceElement@13635} "retrofit2.RequestFactory.create(RequestFactory.java:108)"
    3 = {StackTraceElement@13636} "retrofit2.OkHttpCall.createRawCall(OkHttpCall.java:190)"

所以因为 convert 不对，应该使用 BuiltInConverters$StringConverter 却使用了本来用来转换 Response 的 a.c
    

# Field#apply 中的 valueConverter 如何创建的
之前断点过 valueConverter 是如何赋值的
    
        RequestFactory.parameterHandlers = builder.parameterHandlers;
        builder.parameterHandlers
              parameterHandlers = new ParameterHandler<?>[parameterCount];
              for (int p = 0; p < parameterCount; p++) {
                parameterHandlers[p] = parseParameter(p, parameterTypes[p], parameterAnnotationsArray[p]);
              }

         retrofit2.RequestFactory.Builder.parseParameter
           ParameterHandler<?> annotationAction =
               parseParameterAnnotation(p, parameterType, annotations, annotation);

              result = annotationAction;

          retrofit2.RequestFactory.Builder.parseParameterAnnotation



      对应 valueConverter 的创建过程
      <init>:216, ParameterHandler$Field (retrofit2)
      parseParameterAnnotation:547, RequestFactory$Builder (retrofit2)
      parseParameter:295, RequestFactory$Builder (retrofit2)
      build:182, RequestFactory$Builder (retrofit2)
      parseAnnotations:65, RequestFactory (retrofit2)
      parseAnnotations:25, ServiceMethod (retrofit2)
      loadServiceMethod:168, Retrofit (retrofit2)

      所以回到了 parseParameterAnnotation
      retrofit2.RequestFactory.Builder.parseParameterAnnotation
      //当是字段时
      else if (annotation instanceof Field) {
            if...
                } else {
                  //普通类型时
                  Converter<?, String> converter =
                      retrofit.stringConverter(type, annotations);
                  return new ParameterHandler.Field<>(name, converter, encoded);
                }

       所以是 retrofit2.Retrofit.stringConverter 返回的有问题
         public <T> Converter<T, String> stringConverter(Type type, Annotation[] annotations) {
           checkNotNull(type, "type == null");
           checkNotNull(annotations, "annotations == null");

           for (int i = 0, count = converterFactories.size(); i < count; i++) {
             Converter<?, String> converter =
                 converterFactories.get(i).stringConverter(type, annotations, this);
             if (converter != null) {
               //noinspection unchecked
               return (Converter<T, String>) converter;
             }
           }

           // Nothing matched. Resort to default converter which just calls toString().
           //noinspection unchecked
           return (Converter<T, String>) BuiltInConverters.ToStringConverter.INSTANCE;
         }
        此时 converterFactories 有 3 个元素，分别是
        BuiltInConverters
        a
        OptionalConverterFactory

    在 2.1.0 中
    retrofit2.BuiltInConverters.stringConverter
      public <T> Converter<T, String> stringConverter(Type type, Annotation[] annotations) {
        checkNotNull(type, "type == null");
        checkNotNull(annotations, "annotations == null");

        for (int i = 0, count = converterFactories.size(); i < count; i++) {
          Converter<?, String> converter =
              converterFactories.get(i).stringConverter(type, annotations, this);
          if (converter != null) {
            //noinspection unchecked
            return (Converter<T, String>) converter;
          }
        }

        // Nothing matched. Resort to default converter which just calls toString().
        //noinspection unchecked
        return (Converter<T, String>) BuiltInConverters.ToStringConverter.INSTANCE;
      }

      其 BuiltInConverters 已经实现了 stringConverter() 所以直接返回了 BuiltInConverters
      @Override public Converter<?, String> stringConverter(Type type, Annotation[] annotations,
          Retrofit retrofit) {
        if (type == String.class) {
          return StringConverter.INSTANCE;
        }
        return null;
      }

      2.5.0 中
        retrofit2.Retrofit.stringConverter
        public <T> Converter<T, String> stringConverter(Type type, Annotation[] annotations) {
          checkNotNull(type, "type == null");
          checkNotNull(annotations, "annotations == null");

          for (int i = 0, count = converterFactories.size(); i < count; i++) {
            Converter<?, String> converter =
                converterFactories.get(i).stringConverter(type, annotations, this);
            if (converter != null) {
              //noinspection unchecked
              return (Converter<T, String>) converter;
            }
          }

          // Nothing matched. Resort to default converter which just calls toString().
          //noinspection unchecked
          return (Converter<T, String>) BuiltInConverters.ToStringConverter.INSTANCE;
        }
        BuiltInConverters 并没有实现 stringConverter() 而是当所以工厂都未生产时，才返回 BuiltInConverters.ToStringConverter.INSTANCE
        
        
        
# 去除 stringConverter
最后回到了问题的原因  
com.qinggan.mobile.tsp.a.a  
它重写了 stringConverter 方法，其实可能不需要重写的  
retrofit2.converter.gson.GsonConverterFactory 也没有重写这个方法。  
该方法返回的转换器用来转换参数的注解的类型的。

> Returns a Converter for converting type to a String, or null if type cannot be handled by this factory. This is used to create converters for types specified by @Field, @FieldMap values, @Header, @HeaderMap, @Path, @Query, and @QueryMap values.

默认实现为 retrofit2.BuiltInConverters.ToStringConverter  
直接 toString()  
在 2.1.0 中重写了方法，在 a 之前，于是返回默认转换器。  
2.5.0 去除了方法重写，结果就被 a 替换了。

但是删除后测试报错 javax.net.ssl.SSLPeerUnverifiedException