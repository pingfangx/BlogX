# 服务器
* 服务器创建 Handler
* 服务器使用 Handler 创建 Messenger
* 在 onBind() 中调用 Messenger.binder 返回 IBinder

# 客户端向服务器发送消息
* 客户端接收到 IBinder 用于创建一个 Messenger  
这里可以看到 Messenger 有两个构造函数，一个接受 Handler 一个接受 IBinder
* 客户端持有 Messenger 就可以调用 send 方法发送消息

# 服务器向客户端回复消息
* 客户端创建一个 ClientMessenger，在通过 ServerMessenger 向服务器发送消息时，设置 Message.replyTo 为客户端的 ClientMessenger