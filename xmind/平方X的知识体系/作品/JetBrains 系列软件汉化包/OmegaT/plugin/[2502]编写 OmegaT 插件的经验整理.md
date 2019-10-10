# 设置 Artifacts
添加以后，可以配置
* 名称  
直接修改为插件的 jar 名
* 输出目录  
修改供调试时加载
* 输出内容  
jar 中需要的文件都加上


直接将其输出在
omegat/classes/artifacts/plugins

MANIFEST.MF 可以直接放在 java 中，这样会当作 module-output 直接添加。  
否则会以 directory 和 file-copy 的形式添加。  
如果只是给 OmegaT 的插件作 lib ，MANIFEST.MF 可以不填 Class-Path:

# 运行 test 的配置
对于一个 module ，为了运行 test  
main 所需的库，也要添加到 test 中  
同时为了测试联网 要
* 在 org.omegat.util.WikiGet 中 将 addProxyAuthentication 注释，这是为了运行时能正常加载。
* 加上 Gradle: commons-io:commons-io:2.5

# 直接运行 OmegaT
## 设置插件目录
org.omegat.util.StaticUtils#installDir
```
            if (file == null) {
                file = Paths.get(".").toFile();
            }
```
修改为 artifacts 的输出路径（不包括 plugins），OmegaT 会在 /plugins 中查找要加载的 jar 包。
```
            if (file == null) {
                file = Paths.get("classes/artifacts").toFile();
            }
```
插件引用的库，如 jython 的 jar 包，也要放在 plugins 目录中（可以再添加子目录）。
