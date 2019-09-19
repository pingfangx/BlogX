以神策为例，想知道源码

# 定位源码
在项目的 gradle 中
    
    classpath 'com.sensorsdata.analytics.android:android-gradle-plugin2:2.0.5'
在模块的 gradle 中
    
    apply plugin: 'com.sensorsdata.analytics.android'
一个引入依赖，一个应用插件，
插件的注册在 jar!/META-INF/gradle-plugins

于是全局搜索 com.sensorsdata.analytics.android，找到

    \.gradle\caches\modules-2\files-2.1\com.sensorsdata.analytics.android\android-gradle-plugin2\2.0.5
    
    
打开 jar，在 jar!/META-INF/gradle-plugins 中找到 .properties 文件

    implementation-class=com.sensorsdata.analytics.android.plugin.SensorsAnalyticsPlugin
    
接下来可以直接查看 jar 包的源码，也可以在项目中依赖，依赖后即可方便查看源码。

# SensorsAnalyticsPlugin
    class SensorsAnalyticsPlugin implements Plugin<Project> {

        @Override
        void apply(Project project) {
            project.extensions.create("sensorsAnalytics", SensorsAnalyticsExtension)

            AppExtension appExtension = project.extensions.findByType(AppExtension.class)
            appExtension.registerTransform(new SensorsAnalyticsTransform(project))

            project.afterEvaluate {
                Logger.setDebug(project.sensorsAnalytics.debug)
            }
        }
    }

    com.sensorsdata.analytics.android.plugin.SensorsAnalyticsTransform
    