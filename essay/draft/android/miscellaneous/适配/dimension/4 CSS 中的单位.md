[CSS Units](https://www.w3schools.com/cssref/css_units.asp)

[CSS 单位](https://www.w3cschool.cn/cssref/css-units.html)

[units.en.html](https://www.w3.org/Style/Examples/007/units.en.html)

[units.zh_CN.html](https://www.w3.org/Style/Examples/007/units.zh_CN.html)

[Understanding pixels and other CSS units](https://webplatform.github.io/docs/tutorials/understanding-css-units/#On-CSS-pixels,-physical-units-and-scalability)

给出了链接  
[CSS Values and Units Module Level 3](https://www.w3.org/TR/css3-values/#absolute-lengths)

# 相对长度
单位|描述
-|-
em|它是描述相对于应用在当前元素的字体尺寸，所以它也是相对长度单位。一般浏览器字体大小默认为16px，则2em == 32px；
ex|依赖于英文子母小 x 的高度
ch|数字 0 的宽度| 
rem|根元素（html）的 font-size| 
vw|viewpoint width，视窗宽度，1vw=视窗宽度的1%
vh|viewpoint height，视窗高度，1vh=视窗高度的1%
vmin|vw和vh中较小的那个。
vmax|vw和vh中较大的那个。
%|相对父元素

# 绝对长度
单位|描述
-|-
cm|厘米
mm|毫米
in|英寸 (1in = 96px = 2.54cm)
px *|像素 (1px = 1/96th of 1in)
pt|point，大约1/72英寸； (1pt = 1/72 in)
pc|pica，大约6pt，1/6英寸； (1pc = 12 pt)

# 有关 px 的解释
> Pixels (px) are relative to the viewing device. For low-dpi devices, 1px is one device pixel (dot) of the display. For printers and high resolution screens 1px implies multiple device pixels.

# [CSS Values and Units Module Level 3](https://www.w3.org/TR/css3-values/#absolute-lengths)
unit|name|equivalence
-|-|-
cm|centimeters|1cm = 96px/2.54
mm|millimeters|1mm = 1/10th of 1cm
Q|quarter-millimeters|1Q = 1/40th of 1cm
in|inches|1in = 2.54cm = 96px
pc|picas|1pc = 1/6th of 1in
pt|points|1pt = 1/72th of 1in
px|pixels|1px = 1/96th of 1in