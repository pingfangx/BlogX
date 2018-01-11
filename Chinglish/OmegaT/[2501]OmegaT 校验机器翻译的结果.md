# 0x01 java 中改写 python 中的正则
python 中的
```
        chinese_pattern = r'([\u4e00-\u9fa5])'
        need_space_pattern = r'([a-zA-Z]|{\d}+|\'.+?\'|\".+?\")'
        cn = re.sub(chinese_pattern + need_space_pattern, r'\1 \2', cn)
        cn = re.sub(need_space_pattern + chinese_pattern, r'\1 \2', cn)
```
变为了
```
    public static String formatTranslation(String en, String cn) {
        // \u 需要转义
        String chinesePattern = "([\\u4e00-\\u9fa5])";
        // { 需要转义，但 } 不需要
        String needSpacePattern = "([a-zA-Z]|\\{\\d}|'.+?'|\".+?\")";
        // 要使用 $ 不能使用 \
        cn = cn.replaceAll(chinesePattern + needSpacePattern, "$1 $2");
        cn = cn.replaceAll(needSpacePattern + chinesePattern, "$1 $2");
        return cn;
    }
```
> `Note that backslashes (\) and dollar signs ($) in the replacement string may cause the results to be different than if it were being treated as a literal replacement string. Dollar signs may be treated as references to captured subsequences as described above, and backslashes are used to escape literal characters in the replacement string.`


# 0x02 java 中运行 python--jython
[github/jython](https://github.com/jythontools/jython)
```
        PythonInterpreter interpreter = new PythonInterpreter();
        interpreter.execfile("lib/translation_inspection.py");
        PyFunction function = interpreter.get("inspect_space", PyFunction.class);
        PyObject result = function.__call__(new PyString(en), new PyString(cn));
```

## 2.1 声明编码
> SyntaxError: Non-ASCII character in file 'lib/translation_inspection.py', but no encoding declared; see http://www.python.org/peps/pep-0263.html for details

## 2.2 删除不需要的 import
ImportError: No module named

## 2.3 删除不能调用的方法
main 方法
StandardTranslation.inspect_translation

## 2.4 java.lang.IllegalArgumentException: Cannot create PyString with non-byte value
一开始用的
```
        PyFunction function = interpreter.get("inspect_space", PyFunction.class);
        PyObject result = function.__call__(new PyString(en), new PyString(cn));
```
然后报错
java.lang.IllegalArgumentException: Cannot create PyString with non-byte value

又更新了 2.7.1 （不过后来换为 2.7.0 还是不行），结果 function 找不到了（原本就应该找不到才对）  
于是改为
```
        PyClass pyClass = interpreter.get("TranslationInspection", PyClass.class);
        PyObject result = pyClass.invoke("inspect_space", new PyString(en), new PyString(cn));
```
还是报 java.lang.IllegalArgumentException: Cannot create PyString with non-byte value

又去翻了一下 issues ，
[90#](https://github.com/jythontools/jython/issues/90)
好像有一些修复，但是换为 Py.newStringOrUnicode() 就可以了。

## 2.5 正则替换方法不正确
之前的经验，应该是后向引用的 \ 不正确，试了一下，python 中也可以使用 $ 后向引用。  
于是用将 \\(?=\d) 替换为 \$  
但是发现无效，已经进行转义了。好像是对中文的解析不正确，也可能是位置计算有错。  
你好java语言 被处理为   
你好j av a语言  
测试发现匹配出的结果是 ja ，而正确的应该是 好j

再后来发现，
[渐行渐远silence《Python正则匹配中文与编码总结》](http://blog.csdn.net/silence2015/article/details/60321873)
>关于Python正则表达式匹配中文，其实只要同意编码就行，我电脑用的py2.7，所以字符串前加u，在正则表达式前也加u即可。

而
>Jython follows closely the Python language and its reference implementation CPython, as created by Guido van Rossum. Jython 2.7 corresponds to CPython 2.7.

于下修改为 u，测试成功。
```
替换
r(?=\'.+?\[\\u4e00-\\u9fa5])
为
u
```
(\'|\")[（）‘’“”]


### 中文的括号、引号不正确
(?<!u)(\'|\")([（）‘’“”])
换为 u$1$2

## 2.6 单例
测时发现 new 是一个耗时操作，约需要 2 点几秒。于是用单例保存了 function
```
PythonInterpreter interpreter = new PythonInterpreter();
```

测试发现，第一次两个插件都调用了该类，初始化只调用一次，但两次调用耗时都挺长。  
原因应该是等待单例构造完毕。

然后第二次调用就很快了。


# 0x03 资源的加载
要使用 .py 文件，和之前使用 .js 一样，要考虑如何加载的问题。  
放到目录中，或者压缩到 jar 包中，之前放到 jar 包中总是无法加载，这一次又学习了一下。
## 3.1 文件的引用
```
//路径，测试时是模块的根目录，运行项目时是项目的根目录
interpreter.execfile("lib/translation_inspection.py");
```
所以要使用文件的话，测试模块要在模块中新建目录存放，在运行项目时也要在项目中存放。

## 3.2 stream
之前使用过，
```
InputStream inputStream = GoogleTk.class.getResourceAsStream("resource/google_tk.js");
InputStream inputStream = ClassLoader.getSystemResourceAsStream("resource/google_tk.js");
```
当时使用前者不可以,使用后者是可以的，但是后者生成 jar 包后就无法加载了。  
(后面会介绍原因是 resolveName )  

### java.lang.ClassLoader#getSystemResourceAsStream
调用顺序为
```
java.lang.ClassLoader#getSystemResourceAsStream
java.lang.ClassLoader#getSystemResource
java.lang.ClassLoader#getResource
java.lang.ClassLoader#findResource
java.net.URLClassLoader#findResource
接下来调用
        URL url = AccessController.doPrivileged(
            new PrivilegedAction<URL>() {
                public URL run() {
                    return ucp.findResource(name, true);
                }
            }, acc);
这是是 native 方法，但是多次调用了下面的方法，
sun.misc.URLClassPath#findResource
它持有 loaders 字段
sun.misc.URLClassPath#loaders 中有多个 loader
```
发现 loaders 中只有 resources 、 classes 目录，并没有插件的 jar 包。

### java.lang.Class#getResourceAsStream
java.lang.Class#getResourceAsStream
```
     public InputStream getResourceAsStream(String name) {
        //被修改了名字
        name = resolveName(name);
        ClassLoader cl = getClassLoader0();
        if (cl==null) {
            // A system class.
            return ClassLoader.getSystemResourceAsStream(name);
        }
        return cl.getResourceAsStream(name);
    }
...
后面一样调用到
sun.misc.URLClassPath#findResource
```
但是此时比前面多了一个 URLClassPath
第一个包含 jdk/jre/lib/ext/ 中的一些 jar 包；  
第二个包含很多,应该是项目使用的, jdk 的,IDEA(用其运行)的 jar 包,以及输出 out/production/classes 和 resources  
第三个终于是 plugins 中的 jar 包了

发现是 java.lang.Class#resolveName 修改了名字，于是加上 / 就成功了。
```
    InputStream in = BaseTranslatorX.class.getResourceAsStream("/translation_inspection.py");
    private String resolveName(String name) {
        if (name == null) {
            return name;
        }
        if (!name.startsWith("/")) {
            Class<?> c = this;
            while (c.isArray()) {
                c = c.getComponentType();
            }
            String baseName = c.getName();
            int index = baseName.lastIndexOf('.');
            if (index != -1) {
                name = baseName.substring(0, index).replace('.', '/')
                    +"/"+name;
            }
        } else {
            name = name.substring(1);
        }
        return name;
    }
```

## test 和项目都能使用
运行项目可以从 jar 包中加载，可运行 test ，只有 out/production 和 out/test  
于是我就写了先看文件是否存在。
```

        //文件路径，不以 / 开头，测试时是模块的根目录，运行项目就是项目的根目录
        File file = new File("lib/translation_inspection.py");
        if (file.exists()) {
            try {
                interpreter.execfile(file.getAbsolutePath());
                System.out.println("load py from file");
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            //以 / 开头，不会被处理，最后从 jar 中加载到资源
            InputStream in = BaseTranslatorX.class.getResourceAsStream("/lib/translation_inspection.py");
            if (in != null) {
                try {
                    interpreter.execfile(in);
                    System.out.println("load py from input stream");
                    in.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } else {
                System.out.println("py input stream is null");
            }
        }
```
但是 out/production 中应该有 resources 目录的呀。  
后来看了一下，这个 resources 目录对应 main/resources 与 main/java 同一级。  
于是放进去就好了。