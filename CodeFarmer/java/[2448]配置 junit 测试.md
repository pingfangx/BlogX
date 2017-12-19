转自[BenHeart《IDEA配置JUnit进行单元测试》](http://www.jianshu.com/p/c37753b6dbd6)

## 下载 jar 包
需要 junit.jar 和 hamcrest-core.jar  
[junit4](https://github.com/junit-team/junit4/wiki/Download-and-Install)
## 启用插件
JunitGenerator V2.0  
配置，修改 @author，修改 @since 中的 $date 为 $today

## 转为 gradle 项目
[Best way to add Gradle support to IntelliJ Project](https://stackoverflow.com/questions/26745541)  
提到删除 .iml ，新建 build.gradle ，然后重新打开，试了一下失败。

最后删除原项目，新建 gradle 项目，然后就不用配置测试了。