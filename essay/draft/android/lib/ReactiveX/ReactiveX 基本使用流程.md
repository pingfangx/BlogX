> In ReactiveX an observer subscribes to an Observable. 

所以简单总结，就是

* 以各种方式创建 Observable
* 使用各种操作符操作 Observable
* 可选地使用调度器
* 创建 Observer 并订阅到 Observable
* 在 Observable 的 SubscribeActual 中直接或间接地操作 Observer

下例

    Observable<Integer> observable = Observable.create(new ObservableOnSubscribe<Integer>() {
        @Override
        public void subscribe(ObservableEmitter<Integer> emitter) throws Exception {
            emitter.onNext(i++);
            emitter.onComplete();
        }
    });
    observable.subscribe(new Consumer<Integer>() {
        @Override
        public void accept(Integer integer) throws Exception {
            System.out.println("Consumer " + integer);
        }
    });
结合时度图，我们知道，创建的 Observable 具体类为 ObservableCreate

在 SubscribeActual 方法中，创建了 CreateEmitter，然后调用
subscribe(ObservableEmitter)
后续操作 ObservableEmitter 即直接操作其持有的 Observer