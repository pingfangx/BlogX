[Android 接口定义语言 (AIDL)  |  Android Developers](https://developer.android.google.cn/guide/components/aidl#Defining)

[Android AIDL使用步骤 - CSDN_WZM的博客 - CSDN博客](https://blog.csdn.net/w296365959/article/details/79817203)

# 创建 AIDL 文件
通过 AIDL 文件，将会生成相应接口，即 Stub 类，Stub 类即充当 IBinder

AIDL 服务器、客户端都有，相当于客户端就知道了接口，可以调用方法。而服务器要负责实现方法。


服务器实现 Service，在 onBind() 中返回 IBinder

客户端连接服务，在 onServiceConnected() 回调中得到 IBinder

# 具体的实现
可以参照生成的代码

Stub 是抽象类，asInterface 时返回 Stub.Proxy

实际传给客户端的也是 Stub.Proxy

调用方法时，通过 Parcel 读定


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