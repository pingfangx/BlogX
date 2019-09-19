[How to convert between Android DP and CSS px?](https://graphicdesign.stackexchange.com/questions/36482/)


了解完之后，我们知道了，在 CSS 中，1px =1/96 in  
1in=96css-px

但是在 Android 的定义中，在 160dpi 的设备中，1dp=1px  
那么 1in=160dp

这两者为什么不一致呢。

根据 [CSS Values and Units Module Level 3](https://www.w3.org/TR/css3-values/#absolute-lengths)


>All of the absolute length units are compatible, and px is their canonical unit.

>For a CSS device, these dimensions are anchored either

>* by relating the physical units to their physical measurements, or
>* by relating the pixel unit to the reference pixel.

>For print media at typical viewing distances, the anchor unit should be one of the standard physical units (inches, centimeters, etc). For screen media (including high-resolution devices), low-resolution devices, and devices with unusual viewing distances, it is recommended instead that the anchor unit be the pixel unit. For such devices it is recommended that the pixel unit refer to the whole number of device pixels that best approximates the reference pixel.

>Note: If the anchor unit is the pixel unit, the physical units might not match their physical measurements. Alternatively if the anchor unit is a physical unit, the pixel unit might not map to a whole number of device pixels.

>Note: This definition of the pixel unit and the physical units differs from previous versions of CSS. In particular, in previous versions of CSS the pixel unit and the physical units were not related by a fixed ratio: the physical units were always tied to their physical measurements while the pixel unit would vary to most closely match the reference pixel. (This change was made because too much existing content relies on the assumption of 96dpi, and breaking that assumption broke the content.)

>Note: Values are case-insensitive and serialize as lower case, for example 1Q serializes as 1q.

>The reference pixel is the visual angle of one pixel on a device with a pixel density of 96dpi and a distance from the reader of an arm’s length. For a nominal arm’s length of 28 inches, the visual angle is therefore about 0.0213 degrees. For reading at arm’s length, 1px thus corresponds to about 0.26 mm (1/96 inch).

>The image below illustrates the effect of viewing distance on the size of a reference pixel: a reading distance of 71 cm (28 inches) results in a reference pixel of 0.26 mm, while a reading distance of 3.5 m (12 feet) results in a reference pixel of 1.3 mm.

其中的 **reference pixel** 概念可以解释 px。  
参考像素是一个可视角，其值为 96dpi 的设备在一手臂长看到一个像素的角度。  
一手臂长 28 inch(710.20mm)，一像素 1/96≈0.010 inch(0.26mm)，角度约 0.0213 度。

根据等比关系，28/(1/96)=2688

138 inches(3505.2 mm) 看到的一像素 约为 0.051 inch(1.30mm)

那么，操作手机时离我们较近，1像素对应的距离也就会变小（可以看得更清）。  
因此我们以 Android 定义的 160dpi 为准，1px为 1/160=0.00625 inch  
可以推算出，距离为 2688*1/160=16.8 inch=426mm

也就是说 Android 中的 1dp=CSS 中的 1px