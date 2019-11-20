# 用于 animated vector drawable
> 这两条路径对于变形必须是兼容的：它们必须具有相同数量的命令，且每个命令的参数数量相同。

# 坐标系
[Coordinate Systems, Transformations and Units — SVG 2](https://www.w3.org/TR/SVG/coords.html#InitialCoordinateSystem)

左上角为 (0,0)，x 向右，y 向下

> In stand-alone SVG documents and in SVG document fragments embedded (by reference or inline) within parent documents where the parent's layout is determined by CSS [CSS2], the initial viewport coordinate system (and therefore the initial user coordinate system) must have its origin at the top/left of the viewport, with the positive x-axis pointing towards the right, the positive y-axis pointing down, and text rendered with an "upright" orientation, which means glyphs are oriented such that Roman characters and full-size ideographic characters for Asian scripts have the top edge of the corresponding glyphs oriented upwards and the right edge of the corresponding glyphs oriented to the right.

# pathData 语法
[Paths — SVG 2](https://www.w3.org/TR/SVG/paths.html#PathData)
* All instructions are expressed as one character (e.g., a moveto is expressed as an M).
* Superfluous white space and separators (such as commas) may be eliminated; for instance, the following contains unnecessary spaces:
* A command letter may be eliminated if an identical command letter would otherwise precede it; for instance, the following contains an unnecessary second "L" command:
* For most commands there are absolute and relative versions available (uppercase means absolute coordinates, lowercase means relative coordinates).  
大写表示绝对，小写表示相对
* Alternate forms of lineto are available to optimize the special cases of horizontal and vertical lines (absolute and relative).
* Alternate forms of curve are available to optimize the special cases where some of the control points on the current segment can be determined automatically from the control points on the previous segment.

Alternate forms of curve are available to optimize the special cases where some of the control points on the current segment can be determined automatically from the control points on the previous segment.

# 命令表
[9.3.9. The grammar for path data](https://www.w3.org/TR/SVG/paths.html#PathDataBNF)

命令|名称|介绍|备注
-|-|-|-
M|moveto||
Z|closepath||
L|lineto||
H|horizontal_lineto||
V|vertical_lineto||
C|curveto||
S|smooth_curveto||
Q|quadratic_bezier_curveto||
T|smooth_quadratic_bezier_curveto||
A|elliptical_arc||