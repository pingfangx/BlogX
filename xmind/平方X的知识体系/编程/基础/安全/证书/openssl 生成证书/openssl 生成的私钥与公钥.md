在《openssl 生成证书》中有介绍

    openssl genrsa -out userkey.pem 4096
    
生成的私钥，根据基本知识，我们需要公钥、私钥对，为什么这里只需要私钥就可以了呢？  
这里需要回顾《RSA 算法 2 公、私钥生成过程及 RSA 算法的可靠性》  
虽然回顾了还是记不太清，但只要记住，可以由私钥求出公钥（但是不可以从公钥推出私钥，因为大整数分解的难度）

同时 openssl 也提供了方法由私钥生成公钥

    openssl rsa -in <private key in> -pubout -out <public key out>
    
    
[Generating Public and Private Keys with openssl.exe](http://lunar.lyris.com/help/lm_help/12.0/Content/generating_public_and_private_keys.html)