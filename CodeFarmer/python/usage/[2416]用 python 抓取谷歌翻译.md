[md]

之前在 java 上做了 OmegaT 的插件，这一次想用 python 选把生成的伪翻译翻译一遍。
# tk 的计算
还是使用之前的网址`https://translate.google.cn/#%s/%s/%s`  
但这一次遇到问题了，先加载出 `<span class="short_text" id="result_box"></span>` 之后就卡着不动了，不能加载出翻译结果。  
一开始想着是不是需要处理异步加载，搜了一下，找到:  
[血色--残阳.《Python 爬虫之Google翻译实现》](http://blog.csdn.net/yingshukun/article/details/53470424)  
使用了[cocoa520.《Google_TK》](https://github.com/cocoa520/Google_TK) 来计算 tk 参数。  
测试了一下可用，但它是把项目中的 js 代码复制过来，然后用 python 调用 js，我觉得直接改写成 python 就可以了嘛，不用再引入一个库。

# python 重写
[google_tk.py](https://github.com/pingfangx/PythonX/blob/feature-android_studio_translator/ToolsX/android_studio_translator/machine_translation/google_tk.py)

# 相关源码
[machine_translation.py](https://github.com/pingfangx/PythonX/blob/feature-android_studio_translator/ToolsX/android_studio_translator/machine_translation/machine_translation.py)

[/md]