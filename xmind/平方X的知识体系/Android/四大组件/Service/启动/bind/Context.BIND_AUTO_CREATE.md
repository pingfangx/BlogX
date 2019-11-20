bindService 的时候需要指定 Context.BIND_AUTO_CREATE

这样会自动创建.

如果为 0，则不会自动创建。但是如果后续 startService 会直接绑定上，不需要再次调用 bindService