# 是否支持文件
    isFileSupported:256, AbstractFilter (org.omegat.filters2)
    isFileSupported:276, AbstractFilter (org.omegat.filters2)
    lookupFilter:332, FilterMaster (org.omegat.filters2.master)
    loadFile:194, FilterMaster (org.omegat.filters2.master)
    loadSourceFiles:1150, RealProject (org.omegat.core.data)
    loadProject:369, RealProject (org.omegat.core.data)
    loadProject:72, ProjectFactory (org.omegat.core.data)

查找过滤器，判断是否支持。

回到 org.omegat.core.data.RealProject#loadSourceFiles
    
        for (String filepath : srcPathList) {
            ...
            IFilter filter = fm.loadFile(config.getSourceRoot() + filepath, new FilterContext(config),
                    loadFilesCallback);
            
            IFilter filter = fm.loadFile(config.getSourceRoot() + filepath, new FilterContext(config),
                    loadFilesCallback);

            loadFilesCallback.fileFinished();

            if (filter != null && !fi.entries.isEmpty()) {
                ...
            }
            ...
        }
        
    fi.entries 是如何赋值的
    addSegment:1735, RealProject$LoadFilesCallback (org.omegat.core.data)
    fileFinished:76, ParseEntry (org.omegat.core.data)
    fileFinished:1718, RealProject$LoadFilesCallback (org.omegat.core.data)
    loadSourceFiles:1153, RealProject (org.omegat.core.data)
    loadProject:369, RealProject (org.omegat.core.data)
    loadProject:72, ProjectFactory (org.omegat.core.data)