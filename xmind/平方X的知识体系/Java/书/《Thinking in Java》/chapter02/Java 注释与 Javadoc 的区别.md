# 问题
如果使用 /** 给局部变量作注释，就会产生警告
> Dangling Javadoc comment Alt+Shift+Enter Alt+Enter

这就带来了 Java 注释与 Javadoc 注释的区别

    /**
    *
    ...
    */
    以 /两个 ** 开头的是 Javadoc 专用的注释。
    
    /*
    *
    ...
    */
    以 /一下 * 开头的是 Java 普通的注释。
    
    在 IDEA 中，输入 /* 回车会呈现
    
    /*
    
     */
     
     而输入 /** 回车则是
     
    /**
     * 
     */