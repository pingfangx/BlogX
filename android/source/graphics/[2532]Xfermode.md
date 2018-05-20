Q:
* 官方 demo 在哪
* 为什么叫 xfermode
* 为什么叫 PorterDuffXfermode
* 相关 mode 的命名
* 各模式的官方 demo 与错误示范
* 如何计算

源码
[BitmapDemo](https://github.com/pingfangx/AndroidX/tree/master/demo/BitmapDemo)

截图
![](https://raw.githubusercontent.com/pingfangx/AndroidX/master/demo/BitmapDemo/screenshot/screenshot.png)

# 0x01 官方 demo 在哪
折腾了 import sample ，最终也没有找到  
最后在博客中找到
[戎码之路《Android Paint Xfermode 学习小结》](https://www.cnblogs.com/libertycode/p/6290497.html)
> 而上面这张图片对应的官方DEMO代码如下：https://android.googlesource.com/platform/development/+/master/samples/ApiDemos/src/com/example/android/apis/graphics/Xfermodes.java

于是搜索 ApiDemos，然后发现，我好像又错过了什么？？？
* 模拟器上（26 有，可以打开，27 镜像中没有，app 目录中有，但是实际看不到）  
avd\MI5_API_27.avd\data\app\ApiDemos\ApiDemos.apk
* 镜像中（27怎么没了）  
sdk\system-images\android-26\google_apis_playstore\x86\data\app\ApiDemos\ApiDemos.apk
* 源码中  
android-7.1.2_r33\development\samples\ApiDemos\src\com\example\android\apis\ApiDemos.java  
android-7.1.2_r33\development\samples\ApiDemos\src\com\example\android\apis\graphics\Xfermodes.java

# 0x02 为什么叫 xfermode
眨眼睛~  
官方文档只是说
> Xfermode is the base class for objects that are called to implement custom "transfer-modes" in the drawing pipeline.


# 0x03 为什么叫 PorterDuffXfermode
这在官方的文档中是有解释的。  
[PorterDuff.Mode](https://developer.android.google.cn/reference/android/graphics/PorterDuff.Mode)
>The name of the parent class is an homage to the work of Thomas Porter and Tom Duff, presented in their seminal 1984 paper titled "Compositing Digital Images".

甚至还有 pdf 文件 [p253-porter.pdf](https://keithp.com/~keithp/porterduff/p253-porter.pdf)


# 0x04 相关 mode 的命名
这个时候需要 pdf 中的内容帮助理解  
> Useful operators include A over B, A in B, and A held out by B.   
A over B is the placement of foreground A in front of background B.  
A in B refers only to that part of A inside picture B.  
A held out by B, normally shortened to A out B, refers only to that part of A outside picture B.  
For completeness, we include the less useful operators A atop B and A xor B.  
A atop B is the union of A in B and B out A.  
Thus, paper atop table includes paper where it is on top of table, and table otherwise;   
area beyond the edge of the table is out of the picture.  
A xor B is the union of A out B and B out A. 

# 0x05 各模式的官方 demo 与错误示范
一些常见问题
## 5.1 关闭硬件加速
要设为 soft 默认的硬件加速和 NONE 都不行  
默认的硬件加速时：  
表现为如果不保存图层，CLEAR 会显示黑色（软件加速后显示正常）  
DARKEN、LIGHTEN 等显示不正常

## 5.2 保存图层
默层直接绘制是不可以的，更多应该了解　saveLayer 相关  
否则 CLEAR 等显示黑色或不正常

## 5.3 图形大小与图形透明度
### APIDemo
官方的 APIDemo 中使用了圆和正方形，直接在 canvas 上绘制，在不同的位置绘制  
绘制区域分别为  
左上的 3/4
右下的 1/4-19/20

### API Reference
给出了两张大小相同的图，我直接保存下来发现不行，因为不透明啊  
看到图上的棋盘想当然认为是透明，其实不是啊，就是棋盘，透明是看不到的

## 正确打开方式
最后写出的 demo 中绘制了 4 种情况，其中 1 和 3 都是正确的结果。
1. 官方 Api demo  
直接在 canvas 上绘制，在不同的位置绘制  
2. 官方 API Reference  
官方 API 修改为透明的图片，然后绘制
3. 不 saveLayer
4. 不透明  
两张大小相同的图，官方 API 直接保存，但注意只是棋盘示意，实际不透明

# 0x06 如何计算
详细的计算分析在论文中，原论文粗略看了一下，好像有更复杂的运算过程，笔者简单理解为
* alpha 可以理解 0-255 转为 0-1  
* 颜色也一样，拆分为 RGB 单独计算。  

总共 18 个 mode ，包括 12 个 Alpha compositing modes 和 5 个 Blending modes，还有一个 ADD （为什么没有包含在上面？）  

> 结果（或输出）的 alpha 值标记为 αout. 结果（或输出）的颜色值标记为 Cout.

以 SRC_TOP 为例，原文中公式加查表得

    c(O)
    =c(A)F(A)+c(B)F(B)
    =c(A)a(B)+c(B)(1-a(A))
    即
    Cout=αdst*Csrc+(1−αsrc)*Cdst



以计算 ADD 为例  
## ADD
### 公式
    αout=max(0,min(αsrc+αdst,1))
    Cout=max(0,min(Csrc+Cdst,1))
### 截图已知
    #FFCC44 ADD #66AAFF = #FFFFFF

    #e91e63 ADD #2196f3 = #ffb4ff

### 求证过程
    是这样算吗？
    -0x33bc=0xFFFFFF+1-0x33bc=0xffcc44
    -0x995501=0xFFFFFF+1-0x995501=0x66aaff
    
    
    ff+66>ff，则=ff，或者转为 0-1 也一样。  
    都大于 ff，所以最终结果为 #FFFFFF
    
    再看，0x1e+0x96=0xb4，所以结果为 #ffb4ff
    
以计算 DARKEN 为例

    保留源像素和目标像素的最小分量。
    Cout=(1−αdst)*Csrc+(1−αsrc)*Cdst+min(Csrc,Cdst)
    #FFCC44 DARKEN #66AAFF = #66AA44

以 OVERLAY 为例
这里原文公式好像有问题，前面多了一个 *   ??

但是又看到 [porter_duff_browser_android](https://github.com/ldo/porter_duff_browser_android/blob/master/src/Main.java) 中有

    [Sa + (1 - Sa) * Da,(2 * Dc ≤ Da ? 2 * Sc * Dc : Sa * Da - 2 * (Da - Dc) * (Sa - Sc))\n + (Sc * (1 - Da) + Dc * (1 - Sa))]
            

# 参考文献
[PorterDuff.Mode](https://developer.android.google.cn/reference/android/graphics/PorterDuff.Mode)  
包括自己的汉化版  
[戎码之路《Android Paint Xfermode 学习小结》](https://www.cnblogs.com/libertycode/p/6290497.html)  
[p253-porter.pdf](https://keithp.com/~keithp/porterduff/p253-porter.pdf)  
[自定义控件其实很简单1/6](https://blog.csdn.net/aigestudio/article/details/41316141)  
[细数PorterDuffXferMode的几个坑， PorterDuffXferMode不正确的真正原因](https://blog.csdn.net/u010335298/article/details/51983420)  
[Android中Xfermode简单用法](https://www.2cto.com/kf/201504/388144.html)  
[Android灵魂画家的18种混合模式](https://www.jianshu.com/p/4bdf7d034dee)  