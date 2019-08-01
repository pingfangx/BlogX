# 允许局域网访问
将Require local 改为 Require all granted 

    <VirtualHost *:8012>
        DocumentRoot "${SRVROOT}/www"
        ServerName localhost
        ErrorLog "${SRVROOT}/logs/error.log"
        TransferLog "${SRVROOT}/logs/access.log"
    </VirtualHost>

    <VirtualHost *:80>
        DocumentRoot "${PINGFANGX_ROOT}"
        ServerName localhost.pingfangx.com
        ErrorLog "${SRVROOT}/logs/error.log"
        TransferLog "${SRVROOT}/logs/access.log"
        <Directory  "${PINGFANGX_ROOT}">
            Options +Indexes +Includes +FollowSymLinks +MultiViews
            AllowOverride all
            Require all granted
        </Directory>
    </VirtualHost>



# 端口
默认有 80 端口，本地虽然通过修改 host 指定域名访问，但是手机不能使用域名。  
手机只能通过 ip，通过 ip 不指定端口时默认是 80，于是要修改为默认的 80 是要访问的路径。

# https 与 http
由于证书是针对域名的，通过 ip 访问只能访问 http  

于是相关 form aciton 等都要进行修改。