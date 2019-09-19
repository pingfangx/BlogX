[md]

最后使用的还是 WinHTTrack

想抓取 https://git-scm.com/book/zh/v2/  
使用以前自己珍藏的 Teleport Pro ，居然不可以抓 https 的。  
搜了一圏，
# 使用wget
```
wget -r -p -np -k --no-cookie --no-check-certificate –restrict-file-names=anscii https://git-scm.com/book/zh/v2/
-r 表示递归下载,会下载所有的链接,不过要注意的是,不要单独使用这个参数,因为如果你要下载的网站也有别的网站的链接,wget也会把别的网站的东西下载下来,所以要加上-np这个参数,表示不下载别的站点的链接. 
-np 表示不下载别的站点的链接. 
-k 表示将下载的网页里的链接修改为本地链接.
-p 获得所有显示网页所需的元素,比如图片什么的.
--no-cookie --no-check-certificate 使支持https
–restrict-file-names=anscii 否则中文乱码
```
可是还是带来了问题，就是内部链接在转为本地链接时无法正常转换，并且还要重命名所有文件。

# 于是又找了 WinHTTrack 
可是下载后为什么会有 .z 的压缩包，是我没设置对吗

# 换回 Teleport Ultra
搜索过程中知道
>Teleport Ultra 是著名的离线浏览软件Teleport Pro版本的增强版!

于是想着会不会支持 https 了，试了一下，果然成功了，前面白折腾 wget 、 WinHTTrack 了……  
可是……虽然支持 https 了，还是中文乱码啊，最后还是用的 WinHTTrack

# 换回 WinHTTrack
[官网下载](http://www.httrack.com/page/2/en/index.html)

[/md]