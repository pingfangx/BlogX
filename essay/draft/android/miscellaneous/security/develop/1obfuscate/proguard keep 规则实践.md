修建项目，配置


    buildTypes {
        debug {
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
    
然后运行 transformClassesAndResourcesWithProguardForDebug

查看结果

# 不配置
各类都未使用，位于 usage.txt 中

参照之前的笔记
   
    # 实测
    minifyEnabled 设为 ture 后，Entry Point 不可达的类被删除，添加引用后才会被包括并混淆。

    # 保留类名
    # -keep class **ProGuardTest

    # 保留类和成员
    #-keep class **ProGuardTest{*;}

    # 未找到成员，仍保留类
    #-keep class **ProGuardTest{
    #    *** no();
    #}

    # 保留 keep() 方法及其类
    #-keep class * {
    #    *** keep();
    #}

    # 仅保留 keep() 方法，不保留类
    #-keepclassmembers class *{
    #    *** keep();
    #}



    # 找到成员，保留成员及类
    #-keepclasseswithmembers class *{
    #    *** keep();
    #}

    # 未找到成员，不保留类
    #-keepclasseswithmembers class *{
    #    *** no();
    #}


测试结果

    -keep class * extends android.support.v7.widget.RecyclerView$ViewHolder
    保留类，不保留成员
    
    -keep class * extends android.support.v7.widget.RecyclerView$ViewHolder{*;}
    保留类和成员
    
    -keepclasseswithmembers class * extends android.support.v7.widget.RecyclerView$ViewHolder{
        public <init>(...);
    }
    保留类及构造函数
    
    
    -keepclassmembers class * extends android.support.v7.widget.RecyclerView$ViewHolder{
        public <init>(...);
    }