[How To Build Executable RCP Product](https://github.com/xmindltd/xmind/wiki/How-To-Build-Executable-RCP-Product)


1.  Download and install [JDK v1.8 or higher](http://www.oracle.com/technetwork/java/javase/downloads/index.html).
1.  Download and install [Eclipse SDK v4.6 or higher](http://download.eclipse.org/eclipse/downloads/).
1.  Download and install [Maven v3.3 or higher](http://maven.apache.org/).
1.  Open Terminal on Mac/Linux (or cmd.exe on Windows), and execute these
    *magical* commands (you may have to replace some paths to meet your
    environment):
    
以下为脚本

    ```
    cd /the/path/to/github/xmind
    mvn clean verify
    /the/path/to/eclipse -nosplash -consoleLog \
        -application org.eclipse.equinox.p2.director \
        -repository file:/the/path/to/github/xmind/releng/org.xmind.product/target/repository/ \
        -installIU org.xmind.cathy.product \
        -profile XMindProfile \
        -roaming \
        -destination /the/path/to/target/xmind \
        -p2.os win32|macosx|linux \
        -p2.ws win32|cocoa|gtk \
        -p2.arch x86|x86_64
    ```


## [Non resolvable parent POM although relativePath set to existing parent pom.xml](https://stackoverflow.com/questions/41540074)

> Amid so many details to track I made the following mistake:

> The parent version was listed as 1.0 . The actual version in the parent pom.xml is 1.0.0.

> There was no conceptual misunderstanding on my part: just attention to detail.

经检查确实是，各 module 引用的都是 3.7.4-SNAPSHOT
结果根目录是 3.7.5-SNAPSHOT

## Missing requirement: org.xmind.core.tests 3.7.4.qualifier requires 'bundle org.eclipse.core.runtime 0.0.0' but it could not be found
这里卡住了，解决不了。  
按理说填的仓库地址应该是对的，Eclipse 可以直接运行的，这里可能是因为没有经常使用，少了什么基本东西不知道。   
伤心，一大早上也没有解决，以后只好从 Eclipse 运行了。
不过基本功能应该是通用的，可以使用正式的 XMind8 安装使用。
