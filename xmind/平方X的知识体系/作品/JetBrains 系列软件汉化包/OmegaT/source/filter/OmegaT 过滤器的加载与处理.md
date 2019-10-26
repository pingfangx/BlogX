# 加载
    搜索 PLUGIN_LOAD_OK 下断
    loadClassOld:354, PluginUtils (org.omegat.filters2.master)
    loadFromProperties:282, PluginUtils (org.omegat.filters2.master)
    loadPlugins:128, PluginUtils (org.omegat.filters2.master)
    main:174, Main (org.omegat)
    
# 处理
《OmegaT 翻译流程及输出文件》
## 解析文件
    在 processFile 中调用 processEntry
    internalAddSegment:234, ParseEntry (org.omegat.core.data)
    addEntryWithProperties:172, ParseEntry (org.omegat.core.data)
    addEntry:196, ParseEntry (org.omegat.core.data)
    processEntry:607, AbstractFilter (org.omegat.filters2)
    processEntry:591, AbstractFilter (org.omegat.filters2)
    processSegEmptyLines:222, TextFilter (org.omegat.filters2.text)
    processFile:150, TextFilter (org.omegat.filters2.text)
    processFile:450, AbstractFilter (org.omegat.filters2)
    parseFile:508, AbstractFilter (org.omegat.filters2)
    loadFile:204, FilterMaster (org.omegat.filters2.master)
    loadSourceFiles:1150, RealProject (org.omegat.core.data)
    loadProject:369, RealProject (org.omegat.core.data)
    loadProject:72, ProjectFactory (org.omegat.core.data)
    
## 获取翻译
    还是调用 processEntry
    getTranslation:196, TranslateEntry (org.omegat.core.data)
    processEntry:610, AbstractFilter (org.omegat.filters2)
    processEntry:591, AbstractFilter (org.omegat.filters2)
    processSegEmptyLines:222, TextFilter (org.omegat.filters2.text)
    processFile:150, TextFilter (org.omegat.filters2.text)
    processFile:450, AbstractFilter (org.omegat.filters2)
    translateFile:567, AbstractFilter (org.omegat.filters2)
    translateFile:253, FilterMaster (org.omegat.filters2.master)
    compileProjectAndCommit:653, RealProject (org.omegat.core.data)
    compileProject:579, RealProject (org.omegat.core.data)
    compileProject:565, RealProject (org.omegat.core.data)
    
## 最后输出
基本流程是一样的，只是 out 不一样，所以输出不一样。