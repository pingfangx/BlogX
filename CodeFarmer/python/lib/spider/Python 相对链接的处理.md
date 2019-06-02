使用  urllib.parse.urljoin 


写爬虫的时候相对链接一直调试不驿，耽误了一下午。


一开始在 Spider 中有

            # 因为拼接路径会添加一个 '/'，所以添加一个 '../'
            link = os.path.join(current_url, '../', link)
            link = os.path.normpath(link)
中间件中有


            path = os.path.normpath(os.path.join(url, path))
            path = path.replace('\\', '/')
            path = path.replace(':/', '://')
            
    中间件中明显是错误的，因为 a/b/ 拼上 ../1.html 可能为 a/1.html 
    但是 a/b/2.html 拼上 ../1.html 也应该为 a/1.html 
    1.html 与 2.html 在同一级，即在 b 目录上，因此上一级就是 a 了。
    
    但是使用 join 后，其实是 a/b/2.html/../1.html
    只能回到 a/b/ 
    
后来想到，应该有轮子的呀，哎，要是早知道就好了。  
查了一下，使用 urllib.parse.urljoin 即可