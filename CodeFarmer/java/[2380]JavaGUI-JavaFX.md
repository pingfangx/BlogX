[md]

>本文由平方X发表于平方X网，转载请注明出处。[http://blog.pingfangx.com/2380.html](http://blog.pingfangx.com/2380.html)

根据[知乎.《Java写GUI用swing还是JavaFX呢？》](https://www.zhihu.com/question/37236236)  
选择JavaFX，因为喜欢用新的。^_^

搜到[JavaFX教程](http://www.yiibai.com/javafx/)

# 安装 e(fx)clipse
按照官网的安装。  
[Efxclipse/Tutorials/AddingE(fx)clipse to eclipse](https://wiki.eclipse.org/Efxclipse/Tutorials/AddingE(fx)clipse_to_eclipse)
* 帮助→安装新软件→选择全部可用
* 去除勾选 Group items by category 
* 选择 e(fx)clipse - IDE 

# 安装 JavaFX Scene Builder
[JavaFX Scene Builder Archive](http://www.oracle.com/technetwork/java/javase/downloads/javafxscenebuilder-1x-archive-2199384.html)  
安装后在窗口→首选项→ JavaFX 中配置 SceneBuilder executable

# HelloWorld
根据[初生不惑.《JavaFX快速入门》](http://www.yiibai.com/javafx/javafx-tutorial-for-beginners.html#)
1. 新建 JavaFX 项目  
文件→新建→项目→JavaFX，这样会自动添加JavaFX SDK的库，如果手动加应该需要配置一下。
0. 新建 New FXML Document  
文件→新建→其他→JavaFX→New FXML Document
0. Open with SceneBuilder  
注意先要选中AnchorPane，拖动大小  
id与fx:id不同，fx:id才能在controller中绑定控件，在Code属性中设置fx:id
0. 生成和添加fx:controller  
生成时要选择一个包，生成后要添加进布局文件
0. 编写加载布局的代码  
路径要以“/”开头，我只写一个文件名报错了

```
    @Override
    public void start(Stage primaryStage) {
        try {

            Parent root = FXMLLoader.load(getClass().getResource("/MainScene.fxml"));
            Scene scene = new Scene(root);
            primaryStage.setScene(scene);
            primaryStage.show();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
```

传递[Al_assad.《JavaFX：Main,Controller，FXML之间的参数传递》](http://blog.csdn.net/al_assad/article/details/54664840)  

# Talk is cheap
[相关源码](https://github.com/pingfangx/JavaX/tree/develop-tools/AndroidStudioTranslatorX)

[/md]