# [裴蜀定理](https://zh.wikipedia.org/wiki/%E8%B2%9D%E7%A5%96%E7%AD%89%E5%BC%8F)

    ax+by=m
    有整数解时当且仅当 m 是 a 及 b 的最大公约数 d 的倍数。
    
    ax+by=1
    互质时有解
    
# [最大公约数](https://zh.wikipedia.org/wiki/%E6%9C%80%E5%A4%A7%E5%85%AC%E5%9B%A0%E6%95%B8)
gcd(a,b)*lcm(a,b)=|ab|
# [辗转相除法](https://zh.wikipedia.org/wiki/%E8%BC%BE%E8%BD%89%E7%9B%B8%E9%99%A4%E6%B3%95)

    gcd(a,b)=gcd(b,a mod b)
    
# [扩展欧几里得算法](https://zh.wikipedia.org/wiki/%E6%89%A9%E5%B1%95%E6%AC%A7%E5%87%A0%E9%87%8C%E5%BE%97%E7%AE%97%E6%B3%95)

    ax+by=1
    由于 a b 互质，那么对 a b 求最大公约数，最后肯定会求出结果为 1
    以 47x+30y=1 为例
    gcd(47,30)=1
    gcd(30,17)=1
    gcd(17,13)=1
    gcd(13,4)=1
    
    转换为方程
    4x+1y=1
        即 4*(-3)+1*13=1
    13x+4y=1
        13*(-1)+4*(-3)=1
    17x+13y=1
        17*(-3)+13*4=1
    30x+17y=1
        30*4+17*(-7)=1
    47x+30y=1
        47*(-7)+30*11=1
    
    
    比较发现，是关于最大公约数的方程。
    也就是说
    a*x1+b*y1=1
    b*x2+(a%b)y2=1
    
    基中 1= gcd(a,b)=gcd(b,a%b)
    只要解出 x1 与 x2 ，y1 与 y2 的关系，就可以递归。
    [拓展欧几里得小结（转载）](https://blog.csdn.net/weixin_39645344/article/details/83615901)
    
    a*x1+b*y1=b*x2+(a%b)*y2
    ∵ a%b=a-a/b
    ∴ a*x1+b*y1=b*x2+(a-a//b*b)*y2
    展开 a*x1+b*y1=b*x2+a*y2-a//b*b*y2
    合并系数
    a*x1+b*y1=a*y2+b*(x2-a//b*y2)
    
    于是有 x1=y2
           y1=x2-a//b*y2
           
    这里为什么有 x1=y2 我觉得不能易得，可能因为 a b 互质，没再具体看。
    
    有了这个关系
    就有了 python 中的实现
    
    x, y = y, (x - (a // b) * y)
    
# 怎么利用特解推出其他所有整数解？
[拓展欧几里得小结（转载）](https://blog.csdn.net/weixin_39645344/article/details/83615901)
> 对于关于x，y的方程a * x + b * y = g 来说，让x增加b/g，让y减少a/g，等式两边还相等。（注意一个增加一个减少）
为什么呢？
这个很容易得到，我们算一下即可。
让x增加b/g，对于a * x这一项来说，增加了a * b / g，可以看出这是a,b的最小公倍数
同样，对于b * y这一项来说，y 减少 a/b，这一项增加了a * b / g，同样是a,b的最小公倍数。
可以看出，这两项一项增加了一个最小公倍数，一项减少了一个最小公倍数，加起来的和仍然等于g。
这样我们就明白了，其实这种操作就是增加一个最小公倍数，减少一个最小公倍数，这样来改变x,y的值，来求出所有x,y的通解的。