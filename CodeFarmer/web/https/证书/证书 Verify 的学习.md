# java.security.Signature#verify(byte[])
    传入一段内容，判断这段内容的签名是否与入参签名一致。
## 使用方式
    Signature signature = Signature.getInstance("MD5withRSA");
    signature.initVerify(pub);
    signature.update(updateData);
    boolean verifies = signature.verify(sigedText);
## 实现代码
### initVerify
    java.security.Signature#initVerify(java.security.PublicKey)
    java.security.SignatureSpi#engineInitVerify
    sun.security.rsa.RSASignature#engineInitVerify
    
    protected void engineInitVerify(PublicKey var1) throws InvalidKeyException {
        RSAPublicKey var2 = (RSAPublicKey)RSAKeyFactory.toRSAKey(var1);
        this.privateKey = null;
        this.publicKey = var2;
        this.initCommon(var2, (SecureRandom)null);
    }
    
### update
    java.security.Signature#update(byte[], int, int)
    java.security.SignatureSpi#engineUpdate(byte[], int, int)
    sun.security.rsa.RSASignature#engineUpdate(byte)
    
    protected void engineUpdate(byte var1) throws SignatureException {
        this.md.update(var1);
        this.digestReset = false;
    }
### verify
    java.security.Signature#verify(byte[])
    java.security.SignatureSpi#engineVerify(byte[])
    sun.security.rsa.RSASignature.SHA256withRSA
    sun.security.rsa.RSASignature#engineVerify
    
    protected boolean engineVerify(byte[] var1) throws SignatureException {
        if (var1.length != RSACore.getByteLength(this.publicKey)) {
            throw new SignatureException("Signature length not correct: got " + var1.length + " but was expecting " + RSACore.getByteLength(this.publicKey));
        } else {
            // 获取 update 中传入内容的摘要
            byte[] var2 = this.getDigestValue();

            try {
                byte[] var3 = RSACore.rsa(var1, this.publicKey);
                byte[] var4 = this.padding.unpad(var3);
                // 解码签名中的摘要
                byte[] var5 = decodeSignature(this.digestOID, var4);
                //比对
                return MessageDigest.isEqual(var2, var5);
            } catch (BadPaddingException var6) {
                return false;
            } catch (IOException var7) {
                throw new SignatureException("Signature encoding error", var7);
            }
        }
    }
    
# sun.security.x509.X509CertImpl#verify(java.security.PublicKey, java.lang.String)
    证书的实现。
    传入一个发行者公钥，判断整个证书的签名，与证书中包含的发行者签名是否一致。
    
    public synchronized void verify(PublicKey var1, String var2) throws CertificateException, NoSuchAlgorithmException, InvalidKeyException, NoSuchProviderException, SignatureException {
        if (var2 == null) {
            var2 = "";
        }

        if (this.verifiedPublicKey != null && this.verifiedPublicKey.equals(var1) && var2.equals(this.verifiedProvider)) {
            if (!this.verificationResult) {
                throw new SignatureException("Signature does not match.");
            }
        } else if (this.signedCert == null) {
            throw new CertificateEncodingException("Uninitialized certificate");
        } else {
            Signature var3 = null;
            if (var2.length() == 0) {
                var3 = Signature.getInstance(this.algId.getName());
            } else {
                var3 = Signature.getInstance(this.algId.getName(), var2);
            }

            var3.initVerify(var1);
            byte[] var4 = this.info.getEncodedInfo();
            var3.update(var4, 0, var4.length);
            this.verificationResult = var3.verify(this.signature);
            this.verifiedPublicKey = var1;
            this.verifiedProvider = var2;
            if (!this.verificationResult) {
                throw new SignatureException("Signature does not match.");
            }
        }
    }