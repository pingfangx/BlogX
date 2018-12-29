[当Activity跳转偶遇单身多年的老汉](https://www.jianshu.com/p/579f1f118161)  
[AOP实现防止连续点击](https://blog.csdn.net/vonnie_jade/article/details/69050066)  

# 方法
## 拦截判断时间间隔
* AOP
* startActivity 拦截
* 基类 OnClickListener  
除了防双击，还可以加入其他逻辑，但这样还是觉得 AOP 好
## 启动模式 singleTop
## RxJava 的 throttleFirst()