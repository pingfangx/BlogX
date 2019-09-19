在 debug 启用了混淆，但是却没有生效。  
根据之前的分析  
在《Android Studio 插件的运用过程》中介绍了，混淆是 com.android.build.gradle.internal.transforms.ProGuardTransform

    查看混淆应用过程
    com.android.build.gradle.internal.transforms.ProGuardTransform#transform
    com.android.build.gradle.internal.transforms.ProGuardTransform#doMinification
    
            for (File configFile : getAllConfigurationFiles()) {
                LOG.info("Applying ProGuard configuration file {}", configFile);
                applyConfigurationFile(configFile);
            }
    com.android.build.gradle.internal.transforms.BaseProguardAction#runProguard
    
        public void runProguard() throws IOException {
            new ProGuard(configuration).execute();
            fileToFilter.clear();
        }
    
    发现是没有包含 configFile
    
    查看配置文件的赋值过程为
    
    gradle 中
        proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
    com.android.build.gradle.internal.dsl.BuildType#proguardFiles
    
    设置后，
    com.android.build.gradle.internal.TaskManager#applyProguardRules
    com.android.build.gradle.internal.TaskManager#applyProguardConfigForNonTest
        Callable<Collection<File>> proguardConfigFiles = scope::getProguardFiles;
        ...
        final ConfigurableFileCollection configurationFiles =...
        ...
        transform.setConfigurationFiles(configurationFiles);
        
    scope::getProguardFiles 的调用
    com.android.build.gradle.internal.scope.VariantScopeImpl#getExplicitProguardFiles
        return gatherProguardFiles(
                PostprocessingOptions::getProguardFiles, BaseConfig::getProguardFiles);
    
    
    BuildType extends DefaultBuildType，extends BaseConfigImpl，implements BaseConfig
    
                
    最后发现原因，debug 只复制了
    minifyEnabled true
    没有复制
    proguardFiles getDefaultProguardFile