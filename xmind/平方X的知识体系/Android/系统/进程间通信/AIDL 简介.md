# aidl
核心是 aidl 文件，这个文件服务器客户端都有。

接下来会创建一个接口继承 IInterface

    public interface IDemoAidlInterface extends android.os.IInterface
    
然后是一个 Stub 抽象继承 Binder 实现接口
    
    public static abstract class Stub extends android.os.Binder implements com.pingfangx.demo.androidx.activity.android.app.service.IDemoAidlInterface
    
最后是一个 Proxy 实现接口


当调用 Stub.asInterface() 就会返回 Proxy 类

# asInterface(android.os.IBinder obj)
通过 onServiceConnected 传过来了远程服务，

使用 IBinder 创建了 Proxy，当调用相关方法的时候，Proxy 就使用传过来的 IBinder 作为 mRemote

调用 transact 的方法。

# 客户端调用 transact
当客户端方法的时候，使用持有的 IBinder 调用 transact

      @Override public int calculate(int a, int b) throws android.os.RemoteException
      {
        android.os.Parcel _data = android.os.Parcel.obtain();
        android.os.Parcel _reply = android.os.Parcel.obtain();
        int _result;
        try {
          _data.writeInterfaceToken(DESCRIPTOR);
          _data.writeInt(a);
          _data.writeInt(b);
          boolean _status = mRemote.transact(Stub.TRANSACTION_calculate, _data, _reply, 0);
          if (!_status && getDefaultImpl() != null) {
            return getDefaultImpl().calculate(a, b);
          }
          _reply.readException();
          _result = _reply.readInt();
        }
        finally {
          _reply.recycle();
          _data.recycle();
        }
        return _result;
      }
      
transact 使用两个 Parcel，一个写入参数，一个读出返回结果

# 服务端也一个样
以 aidl 同名的接口继承 IBinder

Stub 类继承 Binder，实现接口

服务在 onBinde 的时候返回一个 IBinder 就是 Stub 类

当客户端调用 transact 方法的时候，Stub 类中的 onTransact 方法执行

读取参数，使用实现的方法计算，返回结果。