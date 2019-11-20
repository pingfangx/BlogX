
    @Override
    public Instance[] getDefaultInstances() {
        return new Instance[]{
                new Instance("*.java", null, "UTF-8"),
        };
    }
    
但是要注意，OmegaT 会缓存过滤器，如果有修改，可能需要删除过滤文件重试。

    org.omegat.util.Preferences#initFilters
