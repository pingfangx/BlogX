[md]

# 准备要翻译的文件
一开始用的本地的 `C:\Program Files\Git\mingw64\share\doc\git-doc` 但是没有方便的跳转。  
于是使用官网的 [https://git-scm.com/docs](https://git-scm.com/docs)  
抓取的时候，因为不同的版本有不同的文件，导致抓了很久，下一次可以正则匹配一下。  
用 TeleportUltra 抓完之后，Topics 点击不可用，最后又使用的 WinHTTrack

是我正则没写对还是 Everything 不支持负向零宽断言，  
`D:\\workspace\\TranslatorX\\GitDocs\\source\\GitDocs\\git-scm\.com\\docs.+\\2\.(?!14)`  
我只好用 2\.[^1] 删除了一次，又用 2\.1[^4] 删除一次

# 准备参考词典
有一些是通用的，使用 equals 生成一个 pseudo.tmx 主到 auto 导入。  
然后写了一个 python 脚本抓谷歌翻译，使用 empty 生成 pseudo.tmx ，翻译后放入 tm 参考翻译（不放入 auto）。  
* 翻译时可以过滤一部分内容，如以 $ 开头的等。 见 [machine_translation.py](https://github.com/pingfangx/PythonX/blob/feature-android_studio_translator/ToolsX/android_studio_translator/machine_translation/machine_translation.py)



[/md]