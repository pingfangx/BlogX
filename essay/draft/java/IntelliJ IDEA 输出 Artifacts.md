1. File → Project Structure → Artifacts → Add → JAR → From modules with dependencies
2. 配置 Module、Main Class、library jar、MANIFEST.MF
3. 可配置 Output Directory  
添加文件夹，将引用的 jar 包移到文件夹中  
选中生成的 jar ，修改 Class Path 指向 jar 包移到文件夹
4. Build → Build Artifacts

在 Output Layout 中可以配置很多
* 添加目录 lib 将 jar 包要引用的库拖进目录
* 配置 jar 的名称
* 配置 jar 中的目录，可以添加文件