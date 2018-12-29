[库模块可能包含自己的 ProGuard 配置文件](https://developer.android.com/studio/projects/android-library)

    android {
        defaultConfig {
            consumerProguardFiles 'lib-proguard-rules.txt'
        }
        ...
    }
