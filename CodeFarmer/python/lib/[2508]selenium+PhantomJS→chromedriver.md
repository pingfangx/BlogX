[Darkeril.《python爬虫的最佳实践(五)--selenium+PhantomJS的简单使用》](https://www.jianshu.com/p/520749be7377)

[Selenium](http://www.seleniumhq.org/)  
[PhantomJS](https://github.com/ariya/phantomjs)  
下载后配置环境变量，可以用命令行打开，但是还是运行不了。  
找到
> 第二步需要把phantomjs.exe拷贝放到python的安装目录下，才可以启动phantomjs。

后来提示被弃用，于是改用 chromedriver  
[chromedriver](https://sites.google.com/a/chromium.org/chromedriver/home)  
一样需要将其复制到 python 安装目录下。环境变理无需设置。

phantomjs 是打开无界面的浏览器，测试的时候实在太慢了。  
chromedriver 打开 chrome ，速度正常。



# 指定 Chrome 的位置
chromedrive 会查找 chrome ，没找到报
cannot find Chrome binary
路径应该在 C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe
但是因为我手动修改了安装路径，导致找不到。

一开始我想在查找路径处添加快捷方式，失败（因为快捷方式带扩展名）
又想生成一个 exe 放那，估计也不行，无法建立连接。

看参数可以传
chrome_options

只传一个带 binary 的字典不行，需要别的参数。
看到默认处理是
selenium.webdriver.chrome.webdriver.WebDriver#create_options
于是直接 
```
from selenium.webdriver.chrome.options import Options as ChromeOptions

        chrome_options = ChromeOptions()
        # 见类中的方法
        chrome_options.binary_location = r'D:\software\browser\Chrome\Application\chrome.exe'
        driver = webdriver.Chrome(chrome_options=chrome_options)
```
成功。