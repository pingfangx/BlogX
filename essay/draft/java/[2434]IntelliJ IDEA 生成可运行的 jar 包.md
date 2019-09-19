转自[bglmmz.《IDEA如何打包可运行jar的一个问题。》](http://bglmmz.iteye.com/blog/2058785)

1. File → Project Structure → Artifacts → Add → JAR → From modules with dependencies
2. 配置 Module、Main Class、library jar、MANIFEST.MF
3. 可配置 Output Directory  
添加文件夹，将引用的 jar 包移到文件夹中  
选中生成的 jar ，修改 Class Path 指向 jar 包移到文件夹
4. Build → Build Artifacts

另见 [[2502]编写 OmegaT 插件的经验整理](http://blog.pingfangx.com/2502.html)

遇到的问题  
1. 创建一个 Artifacts 后，又删除再创建，导致没刷新还是什么，一直执行的是第一次的。  
将其删除、确认，或删除、应用，检查文件是否删掉，然后再重新创建。
2. 因为会打包编译结果，我将编译结果删掉了文件，导致生成的不正确，可以先 Build ，再Build Artifacts。
