在 [大家都是怎样处理Gradle中的这个文件下载慢的问题的？](https://www.zhihu.com/question/37810416) 
中有很多答案，感谢大家的分享。整理在下方，重点介绍 2 点内容。  
* 如何手动下载 gradle
* gradle 目录的路径是如何计算的
# 0x00 手动下载 gradle 介绍
## 0.1 查看要下载的 gradle 版本
在顶目的 `/gradle/wrapper/gradle-wrapper.properties` 中  
可以看到 `distributionUrl=https\://services.gradle.org/distributions/gradle-3.3-all.zip`
也就是说我们要下载 gradle-3.3-all.zip  
有时候我也直接去 $HOME/.gradle/wrapper/dists/ 中查看当前正在下载哪个版本。

## 0.2 下载所需的 gradle
在 0.1 中我们看到了 distributionUrl，直接把“https://services.gradle.org/distributions/gradle-3.3-all.zip” 复制到迅雷中就可以下载了。  
注意去掉了转义的反斜杠 “\” 。  
也可以直接到 [http://services.gradle.org/distributions/](http://services.gradle.org/distributions/) 找到对应版本的 zip 包下载。  
要注意的是区分你要下载的是“all”、“src”还是“bin”包。

## 0.3 将下载好的 zip 包放到对应目录
在 $HOME/.gradle/wrapper/dists/ 目录中，找到版本号对应的文件夹，如 gradle-3.3-all  
进入后有一串编码命名的文件夹，如 55gk2rcmfc6p2dg9u9ohc3hw9 ，打开后将下载好的 zip 包放进去。  
然后重启 AndroidStudio 就好了，如果是在下载 gradle 过程中可能无法关闭，只好在任务管理器中直接关闭了。
## 0.4 gradle 目录的路径是如何计算的
来自下方 4 中的答案。[xiaoyur347《.gradle目录组织》](http://blog.csdn.net/xiaoyur347/article/details/53914072)  
用 distributionUrl 计算 base34
1. 获取 distributionUrl，如 https://services.gradle.org/distributions/gradle-3.3-all.zip
0. 对 distributionUrl 计算 md5 ，求得 57048f1d2bac5f6853fffaa94e56ad59
0. 利用 0x 57048f1d2bac5f6853fffaa94e56ad59 构造一个整数 115666507516428096568303393383998991705
0. 将整数利用base36得到base36的值（取小写） 55gk2rcmfc6p2dg9u9ohc3hw9

[python 实现代码](https://github.com/pingfangx/PythonX/blob/develop-toolsx/ToolsX/android/gradle_helper.py)  
TODO http://blog.csdn.net/tan6600/article/details/46382957

以下为回答中的整理，没有完全测试。
# 1 设置仓库地址
来自 [DIABLOHL](https://www.zhihu.com/question/37810416/answer/153168766)  
```
buildscript {
    repositories {
        maven{ url 'http://maven.aliyun.com/nexus/content/groups/public/'}
    }
}

allprojects {
    repositories {
        maven{ url 'http://maven.aliyun.com/nexus/content/groups/public/'}
    }
}
```

# 2 设置代理，这个我没试
来自 [波特](https://www.zhihu.com/question/37810416/answer/82464203)  
是因为 gradle 没有走代理。如果是 socks5 代理 ，如下这样设置其实并没有什么卵用
```
#systemProp.socks.proxyHost=127.0.0.1
#systemProp.socks.proxyPort=7077

#systemProp.https.proxyHost=127.0.0.1
#systemProp.https.proxyPort=7077

#systemProp.https.proxyHost=socks5://127.0.0.1
#systemProp.https.proxyPort=7077
```
正确设置方法应该是这样：
```
org.gradle.jvmargs=-DsocksProxyHost=127.0.0.1 -DsocksProxyPort=7077
```
修改 $HOME/.gradle/gradle.properties 文件,加入上面那句，这样就可以全局开启 gradle 代理

# 3 手动下载gradle 
我之前一直用这样的方法，在前面已经详细介绍。  
[杨跃](https://www.zhihu.com/question/37810416/answer/81965399)  

# 4 离线化 这个会有用
[fish](https://www.zhihu.com/question/37810416/answer/138131783)  
不太理解为啥很多人回答的都是怎么离线gradle-版本-all.zip，就算是离线gradle，除了大家提到的，如果你已经装好了android studio，去看一下安装目录里面的gradle目录，看清楚版本号，然后改一下gradle-wrapper的配置，就不需要去下载gradle，注意可能工程根目录下build.gradle中gradle版本也要跟着改。  
回到这问题，最近刚研究了一下.gradle的目录组织，可以看http://m.blog.csdn.net/article/details?id=53914072。可能我要解决的问题和题主有点差异，我是希望一个人把bintray的jar包下下来，其他项目组成员直接checkout我的.gradle目录实现离线化。经过我测试，需要离线化.gradle/caches/modules-2目录，即可。其中的files-2.1是从bintray上下载的pom和jar包，metadata-xx是gradle程序的数据组织，如果没metadata也是不行的。

该作者还提供了[http://m.blog.csdn.net/xiaoyur347/article/details/53914072](.gradle目录组织)  
```
其中base36的规则为：

从gradle/wrapper/gradle-wrapper.properties中得到distributionUrl，即https://services.gradle.org/distributions/gradle-2.14.1-all.zip，注意文件中的\不算。
对distributionUrl计算md5。例如printf “https://services.gradle.org/distributions/gradle-2.14.1-all.zip” | md5 
得到8c9a3200746e2de49722587c1108fe87。
利用0x8c9a3200746e2de49722587c1108fe87构造一个uint 128位整数。
将整数利用base36得到base36的值（取小写）。
java代码如下：

import java.math.BigInteger;
import java.security.MessageDigest;

public class Hash {

    public static void main(String[] args) {
        try {
            MessageDigest messageDigest = MessageDigest.getInstance("MD5");
            byte[] bytes = args[0].getBytes();
            messageDigest.update(bytes);
            String str = new BigInteger(1, messageDigest.digest()).toString(36);
            System.out.println(str);
        } catch (Exception e) {
            throw new RuntimeException("Could not hash input string.", e);
        }
    }
}
```
# 5 下载 这个方案如果可以的话也挺好，但是，找不到哪个lib
bin回答的我是直接去https://jcenter.bintray.com/把所需的jar下载下来，然后直接放到Gradle所在版本的lib文件夹里
# 6 
[fish.gradle下载加速](https://zhuanlan.zhihu.com/p/26019083)
```
很多人用Android Studio，最不爽的就是下载包依赖非常的缓慢。这是因为国内bintray网站访问速度很慢。谢谢阿里云，给我们提供了bintray jcenter mirror。如果想用阿里云的jcenter加速，请在用户目录/.gradle里放上下面的配置文件init.gradle，即可自动将依赖改为从阿里云下载。
gradle.projectsLoaded {
    rootProject.allprojects {
        buildscript {
            repositories {
                def REPOSITORY_URL = 'http://maven.aliyun.com/nexus/content/repositories/jcenter'
                all { ArtifactRepository repo ->
                    if (repo instanceof MavenArtifactRepository) {
                        def url = repo.url.toString()
                        if (url.startsWith('https://repo1.maven.org/maven2')
                            || url.startsWith('https://jcenter.bintray.com/')) {
                            project.logger.lifecycle "Repository ${repo.url} replaced by $REPOSITORY_URL."
                            println("buildscript ${repo.url} replaced by $REPOSITORY_URL.")
                            remove repo
                        }
                    }
                }
                jcenter {
                    url REPOSITORY_URL
                }
            }
        }
        repositories {
            def REPOSITORY_URL = 'http://maven.aliyun.com/nexus/content/repositories/jcenter'
            all { ArtifactRepository repo ->
                if (repo instanceof MavenArtifactRepository) {
                    def url = repo.url.toString()
                    if (url.startsWith('https://repo1.maven.org/maven2')
                        || url.startsWith('https://jcenter.bintray.com/')) {
                        project.logger.lifecycle "Repository ${repo.url} replaced by $REPOSITORY_URL."
                        println("allprojects ${repo.url} replaced by $REPOSITORY_URL.")
                        remove repo
                    }
                }
            }
            jcenter {
                url REPOSITORY_URL
            }
        }
    }
}
```