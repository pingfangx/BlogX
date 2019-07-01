一开始想尝试导入 IDEA 发现需要 Launch an Eclipse application 失败  
所以还是用 Eclipse 吧。

[xmindltd/xmind](https://github.com/xmindltd/xmind)
# 1 [运行](https://github.com/xmindltd/xmind/blob/master/README.md)
确实很简单，直接按照说明运行就行

How To Run/Debug
----------------

1.  Download and install [JDK v1.8 or higher](http://www.oracle.com/technetwork/java/javase/downloads/index.html).  
Java 环境
1.  Download and install [Eclipse SDK v4.6 or higher](http://download.eclipse.org/eclipse/downloads/).  
Eclipse
1.  Make a clean workspace.
1.  Import all bundles, features and releng projects into the workspace.  
选择根目录就可把所有的都导入了
1.  Open `org.xmind.cathy.target/cathy.target` with the default *Target Editor*
    and click on 'Set as Target Platform' in the top-right corner of the opened
    editor (you may have to wait for Eclipse to download all necessary
    dependencies).  
    点了之后确实下载了一段时间
1.  Open `org.xmind.cathy.product/cathy.product` with the default *Product
    Configuration Editor* and, in the first 'Overview' tab, click on 'Launch an
    Eclipse application' or 'Launch an Eclipse application in Debug mode'.

## [java.lang.ClassNotFoundException: org.eclipse.swt.SWTError](https://www.eclipse.org/forums/index.php/t/488516/)

    Caused by: java.lang.ClassNotFoundException: org.eclipse.swt.SWTError cannot be found by org.eclipse.ui.workbench_3.108.0.v20160602-1232
    
> Hi, 

> We finally figured out the problem. I believe it is caused from the fact that Linux has different SWT plug-ins than Windows (totally understandable) and these SWT plug-ins need to be re-selected on the Linux installation (I don't know why).

> Here is a more detailed explanation:


> java.lang.NoClassDefFoundError: org/eclipse/swt/widgets/Display is caused by Java being unable to find required classes at runtime. Therefore, to fix this you need to make sure your Run Configurations are set up correctly. To do this, go to Run > Run Configurations.... Once there, find the failing Run Configuration in the menu on the left. Choose the Plug-ins tab just below the box to enter the run configuration's name. In the text box which says "type filter text", type swt and check any unchecked boxes
> (on my computer this was org.eclipse.swt.gtk.linux.x86, but that will vary), then click Run.

也就是在 Run > Run Configurations 中找到运行配置，这里是 cathy.product  
在 Plug-ins 中搜索 swt 勾上没勾的就可以了。  
这里没勾的是 win32 的

# 2 [XMindFileFormat](https://github.com/xmindltd/xmind/wiki/XMindFileFormat)

# 3 main 方法
[深入浅出Eclipse RCP（1）：Hello RCP](https://www.cnblogs.com/kirinboy/archive/2009/05/25/HeadFirstEclipseRcp1.html)
> 在普通的Java程序中，总有一个main()方法作为应用程序的入口点。而RCP程序的入口点则是Application类。打开Application.java文件，可以看到该类实现了IPlatformRunnable接口，入口方法如下所示：

搜索 IPlatformRunnable

找到

    org.eclipse.ui.internal.Workbench.getApplication(String[])
					if (runnable instanceof IPlatformRunnable || runnable instanceof IApplication)
						return runnable;
                        
于是搜索 IApplicationContext  
定位成功

    org.xmind.cathy.internal.CathyApplication.start(IApplicationContext)
    
    
# 4 构建可运行程序