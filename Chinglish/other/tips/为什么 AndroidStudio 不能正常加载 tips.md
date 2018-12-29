# 为什么 tips 的文字可图片可以在不同的 jar 中
## 查看加载过程
    //文字
    com.intellij.ide.util.TipUIUtil#getTipText
    
      URL url = ResourceUtil.getResource(tipLoader, "/tips/", tip.fileName);

      if (url == null) {
        return getCantReadText(tip);
      }

      StringBuffer text = new StringBuffer(ResourceUtil.loadText(url));
      
    //图片
    com.intellij.ide.util.TipUIUtil#updateImages
    
    URL url = ResourceUtil.getResource(tipLoader, "/tips/", path);
    
    看获取 url 的过程
    com.intellij.util.ResourceUtil#getResource(java.lang.ClassLoader, java.lang.String, java.lang.String)
    
      public static URL getResource(@NotNull ClassLoader loader, @NonNls @NotNull String basePath, @NonNls @NotNull String fileName) {
        String fixedPath = StringUtil.trimStart(StringUtil.trimEnd(basePath, "/"), "/");

        //计算 bundle 名字，获取出多个组合
        List<String> bundles = calculateBundleNames(fixedPath, Locale.getDefault());
        for (String bundle : bundles) {
          URL url = loader.getResource(bundle + "/" + fileName);
          if (url == null) continue;

          try {
            url.openConnection();
          }
          catch (IOException e) {
            continue;
          }

          return url;
        }

        return loader.getResource(fixedPath + "/" + fileName);
      }
# 为什么 AndroidStudio 不可以
查看加载过程我们知道，通 calculateBundleNames，会获取到多个可能的 bundle  
分别可能是

    baseName
    baseName_language
    baseName_language_country
    baseName_language_country_variant
然后遍历查找，所以可以在 tips_zh_CN/ 中找到文字，在 tips/ 中找到图片

## 调试 AndroidStudio
使用 IDEA 附加 AndroidStudio 调试  
使用 TipUIUtil.class.getClassLoader().getResource(TipUIUtil.class.getName().replace('.', '/').concat(".class")) 确定了 jar 包目录  
jar:file:/D:/xx/software/JetBrains/AndroidStudio/lib/platform-impl.jar!/com/intellij/ide/util/TipUIUtil.class

将 platform-impl.jar 复制到项目中，删除项目中的 TipUIUtil 类。  
在 jar 中打断点即可调试。

    com.intellij.ide.util.TipUIUtil#updateImages  
    看到 com.intellij.util.ResourceUtil#getResource(java.lang.ClassLoader, java.lang.String, java.lang.String)  
    实际返回图片的地址了
## 替换图片的过程
### AndroidStudio
    可以看到，只是把图片替换为了带宽高
    URL url = ResourceUtil.getResource(tipLoader, "/tips/", path);
    if (url != null) {
        String newImgTag = "<img src=\"" + path + "\" ";

        try {
            BufferedImage image = ImageIO.read(url.openStream());
            int w = image.getWidth();
            int h = image.getHeight();
            if (hidpi) {
                w /= 2;
                h /= 2;
            }

            w = (int)JBUI.scale((float)w);
            h = (int)JBUI.scale((float)h);
            newImgTag = newImgTag + "width=\"" + w + "\" height=\"" + h + "\"";
        } catch (Exception var18) {
            newImgTag = newImgTag + "width=\"400\" height=\"200\"";
        }

        newImgTag = newImgTag + "/>";
        text.replace(index, end + 1, newImgTag);
    }
### idea

        URL url = ResourceUtil.getResource(tipLoader, "/tips/", path);
        if (url != null) {
          path = url.toExternalForm();
        }
        int extPoint = path.lastIndexOf('.');
        String pathWithoutExtension = extPoint != -1 ? path.substring(0, extPoint) : path;
        String fileExtension = extPoint != -1 ? path.substring(extPoint) : "";
        if (!pathWithoutExtension.endsWith("_dark") && !pathWithoutExtension.endsWith("@2x")) {
          boolean hidpi =  JBUI.isPixHiDPI(component);
          path = pathWithoutExtension + (hidpi ? "@2x" : "") + (dark ? "_dark" : "") + fileExtension;
          if (url != null) {
            String newImgTag = "<img src=\""+url+"\" ";//stub
            ...
              if (Registry.is("ide.javafx.tips")) {
                newImgTag =
                  "<img src=\"data:image/" + trinity.first + ";base64," + Base64.getEncoder().encodeToString(trinity.third) + "\" ";
              } else {
                newImgTag = "<img src=\""+actualURL.toExternalForm()+"\" ";
              }
              ...
              newImgTag += "width=\"" + w + "\" height=\"" + h + "\"";
            } catch (Exception ignore) {
              newImgTag += "width=\"400\" height=\"200\"";
            }
            newImgTag += ">";
            text.replace(index, end + 1, newImgTag);
          }
        }
      }
      
    idea 拼上的是 url，区别于 AndroidStudio 只拼上 path
    <img src="file:/D:/workspace/github/intellij-community/out/production/platform-resources-en/tips/images/goto_class.png" width="449" height="111">
    
    
# AndroidStudio 的问题是什么时候修改
支持这种方式，idea 的提交是  
[Support FX Browser for tips of the day](https://github.com/JetBrains/intellij-community/commit/e2a5b470fb48e45016e8dad15f9f8d382098021e#diff-44c973d9774610ea44b7e80c8cd69d41)

Commits on Nov 3, 2017

而 AndroidStudio 3.2 
> The core Android Studio IDE has been updated with improvements from IntelliJ IDEA through the 2018.1.6 release.

而 2018.1.6 是 181.5540
按理说应该是合并的呀，但实际的 platform-impl.jar 并未更新。