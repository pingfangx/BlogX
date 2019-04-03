我们一般配置

    sourceSets {
        main {
            jniLibs.srcDirs = ['libs']
        }   
    }
    
那么如何为 debug release 配置不同的 jniLibs.srcDirs 呢？

搜了一下，其实官方说的已经很清楚了

[创建源集](https://developer.android.com/studio/build/build-variants#sourcesets)

* 通过 gradle 的 sourceSets 任务，可以查看配置的 sourceSets
* 在 src 目录右键 > New > Folder > JNI Folder 创建时就可以选择 Target Source Set 为 debug  
可以看到新建的目录位于 src/debug/jni 这也就是默认的不同变体不同的目录  
同时如果勾选 Change Folder Location 也会自动配置 gradle

[更改默认源集配置](https://developer.android.com/studio/build/build-variants#configure-sourcesets)
我们可以配置

    
    sourceSets {
        release.jniLibs.srcDir 'release-libs'
        debug.jniLibs.srcDir 'debug-libs'
    }
    
    或者是
    sourceSets {
        release {
            jniLibs.srcDir 'release-libs'
        }
        debug {
            jniLibs.srcDir 'debug-libs'
        }
    }
    其实是一样的