[md]

>本文由平方X发表于平方X网，转载请注明出处。[http://blog.pingfangx.com/2382.html](http://blog.pingfangx.com/2382.html)

换了AndroidStudio之后，慢慢都要记了。
# 0x01 下载
[官网下载](https://www.eclipse.org/downloads/)  
我还是不喜欢安装的，于是点[Download Packages](https://www.eclipse.org/downloads/eclipse-packages/)  
# 0x02 汉化
这个汉化可以对自己汉化AndroidStudio作一些参考。  
[Eclipse Babel ](https://www.eclipse.org/babel/downloads.php)  
官方给的方法是  
>* Open the install wizard with 'Help' > 'Install new software...'
>* Add the Babel p2 repository: http://download.eclipse.org/tech ... site/R0.15.0/oxygen
>* Select/install your language pack of choice
>* Restart Eclipse and you should get a translated Eclipse

我们也可以在*Babel Language Pack Zips*下点击*Oxygen*（对应eclipse版本）  
在*Language: Chinese (Simplified)*下找到
`BabelLanguagePack-eclipse-zh_*.zip*`
下载完后解压到eclipse目录即可。

# 0x03 配置
`\.metadata\.plugins\org.eclipse.core.runtime\.settings`
## 编码
窗口→首选项→常规→工作空间→文本文件编码
## 代码提示
窗口→首选项→Java→编辑器→内容辅助
## 格式化
窗口→首选项→Java→代码样式→格式化程序  
注释→去除 New line after @param tags

# 0x04 导出
导出→java→可运行的 JAR 文件→库处理  
第1和应该是不可用的，都重新打包别人的代码了。  
第3比较好，但是需要连文件夹一起，适合所需库比较多的情况。  
一般我选第2.
* Extra required libraries into generated JAR  
附加所需库到生成的 JAR,会提取出所有的代码
* Package required libraries into generated JAR  
打包所需库到生成的 JAR,会将库的jar包打包到生成的jar中
* Copy required libraries into a sub-folder next to the generated JAR
复制所需库在生成的 JAR 包旁边的子文件中。

[/md]