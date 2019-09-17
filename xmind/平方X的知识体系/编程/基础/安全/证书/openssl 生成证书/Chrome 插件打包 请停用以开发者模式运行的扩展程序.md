# 请停用以开发者模式运行的扩展程序

以开发者模式运行的扩展程序可能会损害您的计算机。如果您不是开发者，那么，为安起见，应停用以开发者模式运行的扩展程序。


# 方法一 打包
生成私钥打包，使用

    openssl genrsa -out userkey.pem 4096
    
生成私钥，进行打包

## 打包扩展程序错误
私钥的输入值必须采用有效格式（必须是采用 PKCS#8 格式且经过 PEM 编码的 RSA 密钥）。

于是转为 PKCS#8

    openssl pkcs8 -topk8 -inform PEM -in <in_file> -outform PEM -out <out_file>

## 该扩展程序未列在 Chrome 网上应用店中，并可能是在您不知情的情况下添加的。
因为 chrome 更新了，失败