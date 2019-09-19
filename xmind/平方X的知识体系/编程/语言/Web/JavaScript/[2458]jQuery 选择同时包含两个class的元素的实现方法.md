转自[Mr_Treasure《jQuery 选择同时包含两个class的元素的实现方法》](https://www.cnblogs.com/louby/p/6092821.html)

抓网页时经常用到，记录如下
```
Jquery选择器 多个 class属性参照以下案例 

 <element class="a b good list card">

1. 交集选择： $(".a.b") --选择同时包含a和b的元素。

2. 并集选择：$(".a, .b") --选择包含a或者包含b的元素。


3. 依次过滤  $(“.good”).filter(“.list”).filter(“.Card”)


4. 属性选择   $(“[class='good list card']“);此处 顺序必须一致才行
上去就是干用  $(“.good.list.card”)
```