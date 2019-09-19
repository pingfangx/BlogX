Q:
* 更解 DisplayMetrics{density=3.0, width=1080, height=1920, scaledDensity=3.0, xdpi=428.625, ydpi=427.789}
* 一张相同大小的图，在不同手机上如何展示
* 一张相同大小的图，放在不同目录中如何展示


# 术语
density  [ˈdensəti] 密度  
[Dimension](https://developer.android.com/guide/topics/resources/more-resources#Dimension)
[daɪˈmenʃn]

## Android 支持的单位

### dp
    Density-independent Pixels（密度无关像素） - 一个基于屏幕物理密度的抽象单位这些单位相对于 160 dpi(dots per inch 每英寸点数)的屏幕，该种屏幕 1dp 大致等于 1px。在更高密度的屏幕上运行时，用于绘制 1dp 的像素数按照适合屏幕 dpi 的系数放大。同样，当在较低密度屏幕上时，用于 1dp 的像素数按比例缩小。dp 与像素的比率将随着屏幕密度而变化，但不一定是成正比的。使用 dp 单位(而不是 px 单位)是一种简单的解决方案，可以使布局中的视图尺寸适当调整以适应不同的屏幕密度。换句话说，它为不同设备的 UI 元素的实际大小提供了一致性。
### sp
    Scale-independent Pixels（缩放无关像素）- 这与 dp 单位类似，但它也可以根据用户的字体大小首选项进行缩放。建议您在指定字体大小时使用此单位，以便根据屏幕密度和用户偏好调整它们。
### pt
    Points（点） - 基于屏幕物理尺寸的 1/72 英寸。
### px
    Pixels（像素） - 对应屏幕上的实际像素。建议不要使用此计量单位，因为实际展示可能因设备而不同；每个设备每英寸可以有不同数量的像素，并且在屏幕上可以有更多或更少的总像素。
### mm
    Millimeters（毫米） - 基于屏幕的物理尺寸。
### in
    Inches（英寸） - 基于屏幕的物理尺寸。
    
## 其他相关术语    
### [英寸](https://zh.wikipedia.org/wiki/%E8%8B%B1%E5%AF%B8)
1 英寸 = 2.54 厘米（cm）= 25.4 毫米（mm）

在英制，12英寸（吋）为1英尺（呎），36英寸为1码
### [分辨率](https://zh.wikipedia.org/wiki/%E5%88%86%E8%BE%A8%E7%8E%87)
resolution  [ˌrezəˈlu:ʃn]  
泛指量测或显示系统对细节的分辨能力

> 另外，ppi和dpi经常都会出现混用现象。但是他们所用的领域也存在区别。从技术角度说，“像素”只存在于计算机显示领域，而“点”只出现于打印或印刷领域。

### [dpi](https://zh.wikipedia.org/wiki/%E6%AF%8F%E8%8B%B1%E5%AF%B8%E7%82%B9%E6%95%B0)
Dots Per Inch，每英寸点数
屏幕密度

    屏幕物理区域中的像素量；通常称为 dpi（每英寸 点数）。
    
六种通用的密度：

[支持的屏幕范围](https://developer.android.com/guide/practices/screens_support?hl=zh-cn#range)

[DisplayMetrics](https://developer.android.com/reference/android/util/DisplayMetrics)
    
    ldpi（低）~120dpi
    mdpi（中）~160dpi
    hdpi（高）~240dpi
    xhdpi（超高）~320dpi
    xxhdpi（超超高）~480dpi
    xxxhdpi（超超超高）~640dpi
    
### [ppi](https://zh.wikipedia.org/wiki/%E6%AF%8F%E8%8B%B1%E5%AF%B8%E5%83%8F%E7%B4%A0)
Pixels Per Inch，每英寸像素，又被称为像素密度
    
# 部分源码
    android.util.DisplayMetrics#setToDefaults
    public static int DENSITY_DEVICE = getDeviceDensity();
    public void setToDefaults() {
        widthPixels = 0;
        heightPixels = 0;
        density =  DENSITY_DEVICE / (float) DENSITY_DEFAULT;
        densityDpi =  DENSITY_DEVICE;
        scaledDensity = density;
        xdpi = DENSITY_DEVICE;
        ydpi = DENSITY_DEVICE;
        noncompatWidthPixels = widthPixels;
        noncompatHeightPixels = heightPixels;
        noncompatDensity = density;
        noncompatDensityDpi = densityDpi;
        noncompatScaledDensity = scaledDensity;
        noncompatXdpi = xdpi;
        noncompatYdpi = ydpi;
    }
    
    android.util.DisplayMetrics#getDeviceDensity
        private static int getDeviceDensity() {
        // qemu.sf.lcd_density can be used to override ro.sf.lcd_density
        // when running in the emulator, allowing for dynamic configurations.
        // The reason for this is that ro.sf.lcd_density is write-once and is
        // set by the init process when it parses build.prop before anything else.
        return SystemProperties.getInt("qemu.sf.lcd_density",
                SystemProperties.getInt("ro.sf.lcd_density", DENSITY_DEFAULT));
    }
# 小米5
    5.15 英寸 1080*1920
    输出为 DisplayMetrics{density=3.0, width=1080, height=1920, scaledDensity=3.0, xdpi=428.625, ydpi=427.789}

    手动计算
    分辨率 1080 x 1920,207万像素

    根据尺寸计算宽高
    宽^2 +(1.7777777777777777*宽)^2=5.15^2
    宽为 2.524845384107679 inches，64.13107275633504 mm
    高为 4.488614016191429 inches,114.01079601126229 mm
    计算尺寸为 5.15 inch,2202.9071700822983 px

    计算 ppi(pixels per inch)
    以宽计算 427.7489650645239，以高计算 427.74896506452393，以对角线计算 427.74896506452393

    density 为 3.0,dpi 级别为 xxhdpi(480)