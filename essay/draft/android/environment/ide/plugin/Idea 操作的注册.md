首先我们以文件为例，查找到  
group.FileMenu.text

然后在 com.intellij.BundleBase#messageOrDefault 中下断

    1 = {StackTraceElement@7060} "com.intellij.BundleBase.messageOrDefault(BundleBase.java:42)"
    2 = {StackTraceElement@7061} "com.intellij.CommonBundle.messageOrDefault(CommonBundle.java:50)"
    3 = {StackTraceElement@7062} "com.intellij.openapi.actionSystem.impl.ActionManagerImpl.loadTextForElement(ActionManagerImpl.java:283)"
    4 = {StackTraceElement@7063} "com.intellij.openapi.actionSystem.impl.ActionManagerImpl.processGroupElement(ActionManagerImpl.java:703)"
    5 = {StackTraceElement@7064} "com.intellij.openapi.actionSystem.impl.ActionManagerImpl.processGroupElement(ActionManagerImpl.java:737)"
    6 = {StackTraceElement@7065} "com.intellij.openapi.actionSystem.impl.ActionManagerImpl.processActionsChildElement(ActionManagerImpl.java:969)"
    7 = {StackTraceElement@7066} "com.intellij.openapi.actionSystem.impl.ActionManagerImpl.registerPluginActions(ActionManagerImpl.java:468)"
    8 = {StackTraceElement@7067} "com.intellij.openapi.actionSystem.impl.ActionManagerImpl.<init>(ActionManagerImpl.java:144)"
    9 = {StackTraceElement@7068} "sun.reflect.NativeConstructorAccessorImpl.newInstance0(Native Method)"
    10 = {StackTraceElement@7069} "sun.reflect.NativeConstructorAccessorImpl.newInstance(NativeConstructorAccessorImpl.java:62)"
    11 = {StackTraceElement@7070} "sun.reflect.DelegatingConstructorAccessorImpl.newInstance(DelegatingConstructorAccessorImpl.java:45)"
    12 = {StackTraceElement@7071} "java.lang.reflect.Constructor.newInstance(Constructor.java:423)"
    13 = {StackTraceElement@7072} "org.picocontainer.defaults.InstantiatingComponentAdapter.newInstance(InstantiatingComponentAdapter.java:193)"
    14 = {StackTraceElement@7073} "com.intellij.util.pico.CachingConstructorInjectionComponentAdapter.doGetComponentInstance(CachingConstructorInjectionComponentAdapter.java:103)"
    15 = {StackTraceElement@7074} "com.intellij.util.pico.CachingConstructorInjectionComponentAdapter.instantiateGuarded(CachingConstructorInjectionComponentAdapter.java:80)"
    16 = {StackTraceElement@7075} "com.intellij.util.pico.CachingConstructorInjectionComponentAdapter.getComponentInstance(CachingConstructorInjectionComponentAdapter.java:63)"
    17 = {StackTraceElement@7076} "com.intellij.openapi.components.impl.ComponentManagerImpl$ComponentConfigComponentAdapter.getComponentInstance(ComponentManagerImpl.java:474)"
    18 = {StackTraceElement@7077} "com.intellij.util.pico.DefaultPicoContainer.getLocalInstance(DefaultPicoContainer.java:240)"
    19 = {StackTraceElement@7078} "com.intellij.util.pico.DefaultPicoContainer.getComponentInstance(DefaultPicoContainer.java:207)"
    20 = {StackTraceElement@7079} "org.picocontainer.defaults.BasicComponentParameter.resolveInstance(BasicComponentParameter.java:77)"
    21 = {StackTraceElement@7080} "org.picocontainer.defaults.ComponentParameter.resolveInstance(ComponentParameter.java:114)"
    22 = {StackTraceElement@7081} "com.intellij.util.pico.CachingConstructorInjectionComponentAdapter.getConstructorArguments(CachingConstructorInjectionComponentAdapter.java:129)"
    23 = {StackTraceElement@7082} "com.intellij.util.pico.CachingConstructorInjectionComponentAdapter.doGetComponentInstance(CachingConstructorInjectionComponentAdapter.java:100)"
    24 = {StackTraceElement@7083} "com.intellij.util.pico.CachingConstructorInjectionComponentAdapter.instantiateGuarded(CachingConstructorInjectionComponentAdapter.java:80)"
    25 = {StackTraceElement@7084} "com.intellij.util.pico.CachingConstructorInjectionComponentAdapter.getComponentInstance(CachingConstructorInjectionComponentAdapter.java:63)"
    26 = {StackTraceElement@7085} "com.intellij.openapi.components.impl.ServiceManagerImpl$MyComponentAdapter.getComponentInstance(ServiceManagerImpl.java:220)"
    27 = {StackTraceElement@7086} "com.intellij.util.pico.DefaultPicoContainer.getLocalInstance(DefaultPicoContainer.java:240)"
    28 = {StackTraceElement@7087} "com.intellij.util.pico.DefaultPicoContainer.getComponentInstance(DefaultPicoContainer.java:207)"
    29 = {StackTraceElement@7088} "org.picocontainer.defaults.BasicComponentParameter.resolveInstance(BasicComponentParameter.java:77)"
    30 = {StackTraceElement@7089} "org.picocontainer.defaults.ComponentParameter.resolveInstance(ComponentParameter.java:114)"
    31 = {StackTraceElement@7090} "com.intellij.util.pico.CachingConstructorInjectionComponentAdapter.getConstructorArguments(CachingConstructorInjectionComponentAdapter.java:129)"
    32 = {StackTraceElement@7091} "com.intellij.util.pico.CachingConstructorInjectionComponentAdapter.doGetComponentInstance(CachingConstructorInjectionComponentAdapter.java:100)"
    33 = {StackTraceElement@7092} "com.intellij.util.pico.CachingConstructorInjectionComponentAdapter.instantiateGuarded(CachingConstructorInjectionComponentAdapter.java:80)"
    34 = {StackTraceElement@7093} "com.intellij.util.pico.CachingConstructorInjectionComponentAdapter.getComponentInstance(CachingConstructorInjectionComponentAdapter.java:63)"
    35 = {StackTraceElement@7094} "com.intellij.openapi.components.impl.ComponentManagerImpl$ComponentConfigComponentAdapter.getComponentInstance(ComponentManagerImpl.java:474)"
    36 = {StackTraceElement@7095} "com.intellij.openapi.components.impl.ComponentManagerImpl.createComponents(ComponentManagerImpl.java:119)"
    37 = {StackTraceElement@7096} "com.intellij.openapi.application.impl.ApplicationImpl.lambda$createComponents$9(ApplicationImpl.java:448)"
    38 = {StackTraceElement@7097} "com.intellij.openapi.progress.impl.CoreProgressManager.lambda$runProcess$1(CoreProgressManager.java:157)"
    39 = {StackTraceElement@7098} "com.intellij.openapi.progress.impl.CoreProgressManager.registerIndicatorAndRun(CoreProgressManager.java:580)"
    40 = {StackTraceElement@7099} "com.intellij.openapi.progress.impl.CoreProgressManager.executeProcessUnderProgress(CoreProgressManager.java:525)"
    41 = {StackTraceElement@7100} "com.intellij.openapi.progress.impl.ProgressManagerImpl.executeProcessUnderProgress(ProgressManagerImpl.java:98)"
    42 = {StackTraceElement@7101} "com.intellij.openapi.progress.impl.CoreProgressManager.runProcess(CoreProgressManager.java:144)"
    43 = {StackTraceElement@7102} "com.intellij.openapi.application.impl.ApplicationImpl.createComponents(ApplicationImpl.java:455)"
    44 = {StackTraceElement@7103} "com.intellij.openapi.components.impl.ComponentManagerImpl.init(ComponentManagerImpl.java:103)"
    45 = {StackTraceElement@7104} "com.intellij.openapi.application.impl.ApplicationImpl.load(ApplicationImpl.java:407)"
    46 = {StackTraceElement@7105} "com.intellij.openapi.application.impl.ApplicationImpl.load(ApplicationImpl.java:393)"
    47 = {StackTraceElement@7106} "com.intellij.idea.IdeaApplication.run(IdeaApplication.java:209)"
    48 = {StackTraceElement@7107} "com.intellij.idea.MainImpl$1.lambda$null$0(MainImpl.java:49)"
    
    
    
可以看到，其过程为

    ActionManagerImpl 初始化时加载调用 registerPluginActions
    注册各个插件的操作
    注册核心时
    PluginDescriptor[name='IDEA CORE', classpath='D:\workspace\github\intellij-community\out\production\adt-branding']
    
    private static String loadTextForElement(final Element element, final ResourceBundle bundle, final String id, String elementType) {
        //取 name 为默认值
        final String value = element.getAttributeValue(TEXT_ATTR_NAME);
        return CommonBundle.messageOrDefault(bundle, elementType + "." + id + "." + TEXT_ATTR_NAME, value == null ? "" : value);
    }
    
    操作的解析位于
    com.intellij.ide.plugins.IdeaPluginDescriptorImpl#readExternal(org.jdom.Element)
    其文件为
    file:/D:/workspace/github/intellij-community/out/production/adt-branding/META-INF/AndroidStudioPlugin.xml
    
    
    1 = {StackTraceElement@4892} "com.intellij.ide.plugins.IdeaPluginDescriptorImpl.readExternal(IdeaPluginDescriptorImpl.java:293)"
    2 = {StackTraceElement@4893} "com.intellij.ide.plugins.IdeaPluginDescriptorImpl.readExternal(IdeaPluginDescriptorImpl.java:169)"
    3 = {StackTraceElement@4894} "com.intellij.ide.plugins.IdeaPluginDescriptorImpl.readExternal(IdeaPluginDescriptorImpl.java:162)"
    4 = {StackTraceElement@4895} "com.intellij.ide.plugins.IdeaPluginDescriptorImpl.readExternal(IdeaPluginDescriptorImpl.java:175)"
    5 = {StackTraceElement@4896} "com.intellij.ide.plugins.PluginManagerCore.loadDescriptorFromDir(PluginManagerCore.java:654)"
    6 = {StackTraceElement@4897} "com.intellij.ide.plugins.PluginManagerCore.loadDescriptor(PluginManagerCore.java:739)"
    7 = {StackTraceElement@4898} "com.intellij.ide.plugins.PluginManagerCore.loadDescriptor(PluginManagerCore.java:713)"
    8 = {StackTraceElement@4899} "com.intellij.ide.plugins.PluginManagerCore.loadDescriptorFromResource(PluginManagerCore.java:1048)"
    9 = {StackTraceElement@4900} "com.intellij.ide.plugins.PluginManagerCore.loadDescriptorsFromClassPath(PluginManagerCore.java:1029)"
    10 = {StackTraceElement@4901} "com.intellij.ide.plugins.PluginManagerCore.loadDescriptors(PluginManagerCore.java:1110)"
    11 = {StackTraceElement@4902} "com.intellij.ide.plugins.PluginManagerCore.initializePlugins(PluginManagerCore.java:1299)"
    12 = {StackTraceElement@4903} "com.intellij.ide.plugins.PluginManagerCore.initPlugins(PluginManagerCore.java:1475)"
    13 = {StackTraceElement@4904} "com.intellij.ide.plugins.PluginManagerCore.getPlugins(PluginManagerCore.java:130)"
    14 = {StackTraceElement@4905} "com.intellij.openapi.components.impl.ComponentManagerImpl.getComponentConfigs(ComponentManagerImpl.java:305)"
    15 = {StackTraceElement@4906} "com.intellij.openapi.components.impl.ComponentManagerImpl.init(ComponentManagerImpl.java:94)"
    16 = {StackTraceElement@4907} "com.intellij.openapi.application.impl.ApplicationImpl.load(ApplicationImpl.java:407)"
    17 = {StackTraceElement@4908} "com.intellij.openapi.application.impl.ApplicationImpl.load(ApplicationImpl.java:393)"
    18 = {StackTraceElement@4909} "com.intellij.idea.IdeaApplication.run(IdeaApplication.java:209)"
    19 = {StackTraceElement@4910} "com.intellij.idea.MainImpl$1.lambda$null$0(MainImpl.java:49)"