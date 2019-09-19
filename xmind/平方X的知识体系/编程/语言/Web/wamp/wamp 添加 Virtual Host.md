现在安装 wamp 后可使用工具添加了。  
Your VirtualHosts > VirtualHost Management  
打开 http://localhost/add_vhost.php 添加

添加监听也可以右键 > Tools > Add a Listen port for Apache

按以前的手动添加方式

    \apache2.4.35\conf\httpd.conf
        添加 Listen
        
        # Virtual hosts
        Include conf/extra/httpd-vhosts.conf
    
    # 使用 localhost:2222 和 discuz:2222 都可以访问
    \apache2.4.35\conf\extra\httpd-vhosts.conf
        <VirtualHost *:${MYPORT2222}>
            ServerName discuz
            DocumentRoot "d:/workspace/phpx/discuz"
            <Directory  "d:/workspace/phpx/discuz/">
                Options +Indexes +Includes +FollowSymLinks +MultiViews
                AllowOverride All
                Require local
            </Directory>
        </VirtualHost>