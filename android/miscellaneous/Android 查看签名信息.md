使用 keytool 查看
# apk
解压出 META-INF/CERT.RSA  
    keytool -printcert -file <filename>
    
# keystore
    keytool -list -v -keystore <keystore>