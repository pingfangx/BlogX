AsyncTask 内部持 Handler 进间线程间消息传递。

持有 Executor，WorkerRunnable，FutureTask

当调用 execute 时，线程池执行 FutureTask，执行 WorkerRunnable，于是调用 doInBackground

返回的结果在 FutureTask 的 done 方法中调用 postResult ，通过 Handler 发送。

于是回到了主线程，取出消息，调用 onPostExecute