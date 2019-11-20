[APK签名机制之——JAR签名机制详解](https://blog.csdn.net/zwjemperor/article/details/80877305)

# 先看 MANIFEST.MF
所有文件及摘要

# CERT.SF
* 整个MF文件的摘要（SHA1-Digest-Manifest）
* MF中相应条目的摘要

# CERT.RSA
证书信息及对cert.sf文件的签名