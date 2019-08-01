# 从一个调用开始
    retrofit2.Retrofit#create
    
      public <T> T create(final Class<T> service) {
        Utils.validateServiceInterface(service);
        if (validateEagerly) {
          eagerlyValidateMethods(service);
        }
        return (T) Proxy.newProxyInstance(service.getClassLoader(), new Class<?>[] { service },
            new InvocationHandler() {
              private final Platform platform = Platform.get();
              private final Object[] emptyArgs = new Object[0];

              @Override public @Nullable Object invoke(Object proxy, Method method,
                  @Nullable Object[] args) throws Throwable {
                // If the method is a method from Object then defer to normal invocation.
                if (method.getDeclaringClass() == Object.class) {
                  return method.invoke(this, args);
                }
                if (platform.isDefaultMethod(method)) {
                  return platform.invokeDefaultMethod(method, service, proxy, args);
                }
                return loadServiceMethod(method).invoke(args != null ? args : emptyArgs);
              }
            });
      }

    retrofit2.HttpServiceMethod#invoke
    
      @Override final @Nullable ReturnT invoke(Object[] args) {
        Call<ResponseT> call = new OkHttpCall<>(requestFactory, args, callFactory, responseConverter);
        return adapt(call, args);
      }
      
    retrofit2.HttpServiceMethod.CallAdapted#adapt
    
    @Override protected ReturnT adapt(Call<ResponseT> call, Object[] args) {
      return callAdapter.adapt(call);
    }
    
    callAdapter 由 callAdapterFactories 创建
    
    retrofit2.HttpServiceMethod
    
    CallAdapter<ResponseT, ReturnT> callAdapter =
        createCallAdapter(retrofit, method, adapterType, annotations);
        
    retrofit2.HttpServiceMethod#createCallAdapter
    retrofit2.Retrofit#callAdapter
    retrofit2.Retrofit#nextCallAdapter
    
    int start = callAdapterFactories.indexOf(skipPast) + 1;
    for (int i = start, count = callAdapterFactories.size(); i < count; i++) {
      CallAdapter<?, ?> adapter = callAdapterFactories.get(i).get(returnType, annotations, this);
      if (adapter != null) {
        return adapter;
      }
    }

    而 callAdapterFactories 在创建时配置
    .addCallAdapterFactory(RxJava2CallAdapterFactory.create())