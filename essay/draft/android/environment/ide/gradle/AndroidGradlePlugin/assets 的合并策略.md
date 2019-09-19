如果主项目和库中都有 assets ，那么最后的结果会保留项目中的 assets  
忽略库的 assets ，实际是这样的吗，查看源码确认一下。

根据之前的博文调试 [调试 android.tools.build 源码]()


    com.android.build.gradle.tasks.MergeSourceSetFolders#doFullTaskAction
        //读取 assetSet 列表
        List<AssetSet> assetSets = computeAssetSetList();

        // create a new merger and populate it with the sets.
        AssetMerger merger = new AssetMerger();

        try {
            //添加为 dataSet
            for (AssetSet assetSet : assetSets) {
                // set needs to be loaded.
                assetSet.loadFromFiles(getILogger());
                merger.addDataSet(assetSet);
            }

            // get the merged set and write it down.
            MergedAssetWriter writer = new MergedAssetWriter(destinationDir, workerExecutor);

            //合并
            merger.mergeData(writer, false /*doCleanUp*/);
    
    先看读取 assetSet 列表的方法
    
    List<AssetSet> computeAssetSetList() {
        List<AssetSet> assetSetList;

        //①项目的 assets
        List<AssetSet> assetSets = assetSetSupplier.get();
        if (copyApk == null
                && shadersOutputDir == null
                && ignoreAssets == null
                && libraries == null) {
            assetSetList = assetSets;
        } else {
            int size = assetSets.size() + 3;
            if (libraries != null) {
                size += libraries.getArtifacts().size();
            }

            assetSetList = Lists.newArrayListWithExpectedSize(size);

            //②各库的 assets
            // get the dependency base assets sets.
            // add at the beginning since the libraries are less important than the folder based
            // asset sets.
            if (libraries != null) {
                // the order of the artifact is descending order, so we need to reverse it.
                Set<ResolvedArtifactResult> libArtifacts = libraries.getArtifacts();
                for (ResolvedArtifactResult artifact : libArtifacts) {
                    AssetSet assetSet = new AssetSet(MergeManifests.getArtifactName(artifact));
                    assetSet.addSource(artifact.getFile());

                    // add to 0 always, since we need to reverse the order.
                    assetSetList.add(0, assetSet);
                }
            }

            // add the generated folders to the first set of the folder-based sets.
            List<File> generatedAssetFolders = Lists.newArrayList();

            if (shadersOutputDir != null) {
                generatedAssetFolders.addAll(shadersOutputDir.getFiles());
            }

            if (copyApk != null) {
                generatedAssetFolders.addAll(copyApk.getFiles());
            }

            // add the generated files to the main set.
            final AssetSet mainAssetSet = assetSets.get(0);
            assert mainAssetSet.getConfigName().equals(BuilderConstants.MAIN);
            mainAssetSet.addSources(generatedAssetFolders);

            //③最后添加主项目的 assets，则主项目的将排在最后
            assetSetList.addAll(assetSets);
        }

        if (ignoreAssets != null) {
            for (AssetSet set : assetSetList) {
                set.setIgnoredPatterns(ignoreAssets);
            }
        }

        return assetSetList;
    }
    
    
    //合并方法
    com.android.ide.common.resources.DataMerger#mergeData
    
    public void mergeData(@NonNull MergeConsumer<I> consumer, boolean doCleanUp)
            throws MergingException {

        consumer.start(mFactory);

        try {
            // 获取到所有的 items key
            // get all the items keys.
            Set<String> dataItemKeys = new HashSet<>();

            for (S dataSet : mDataSets) {
                // quick check on duplicates in the resource set.
                dataSet.checkItems();
                ListMultimap<String, I> map = dataSet.getDataMap();
                dataItemKeys.addAll(map.keySet());
            }

            // loop on all the data items.
            for (String dataItemKey : dataItemKeys) {
                if (requiresMerge(dataItemKey)) {
                    // get all the available items, from the lower priority, to the higher
                    // priority
                    List<I> items = new ArrayList<>(mDataSets.size());
                    for (S dataSet : mDataSets) {

                        // look for the resource key in the set
                        ListMultimap<String, I> itemMap = dataSet.getDataMap();

                        if (itemMap.containsKey(dataItemKey)) {
                            List<I> setItems = itemMap.get(dataItemKey);
                            items.addAll(setItems);
                        }
                    }

                    mergeItems(dataItemKey, items, consumer);
                    continue;
                }

                // for each items, look in the data sets, starting from the end of the list.
                // 每个 item ，从 list 最后开始查找
                I previouslyWritten = null;
                I toWrite = null;

                /*
                 * We are looking for what to write/delete: the last non deleted item, and the
                 * previously written one.
                 */

                boolean foundIgnoredItem = false;

                setLoop: for (int i = mDataSets.size() - 1 ; i >= 0 ; i--) {
                    S dataSet = mDataSets.get(i);

                    // look for the resource key in the set
                    ListMultimap<String, I> itemMap = dataSet.getDataMap();

                    if (!itemMap.containsKey(dataItemKey)) {
                        continue;
                    }
                    List<I> items = itemMap.get(dataItemKey);
                    if (items.isEmpty()) {
                        continue;
                    }

                    // The list can contain at max 2 items. One touched and one deleted.
                    // More than one deleted means there was more than one which isn't possible
                    // More than one touched means there is more than one and this isn't possible.
                    for (int ii = items.size() - 1 ; ii >= 0 ; ii--) {
                        I item = items.get(ii);

                        if (consumer.ignoreItemInMerge(item)) {
                            foundIgnoredItem = true;
                            continue;
                        }

                        if (item.isWritten()) {
                            assert previouslyWritten == null;
                            previouslyWritten = item;
                        }
                        
                        //从后往前查找，如果找到，那么赋值，首次赋值后，就不会再继续赋值
                        if (toWrite == null && !item.isRemoved()) {
                            toWrite = item;
                        }

                        if (toWrite != null && previouslyWritten != null) {
                            break setLoop;
                        }
                    }
                }

                // done searching, we should at least have something, unless we only
                // found items that are not meant to be written (attr inside declare styleable)
                assert foundIgnoredItem || previouslyWritten != null || toWrite != null;

                if (toWrite != null && !filterAccept(toWrite)) {
                    toWrite = null;
                }


                //noinspection ConstantConditions
                if (previouslyWritten == null && toWrite == null) {
                    continue;
                }

                // now need to handle, the type of each (single res file, multi res file), whether
                // they are the same object or not, whether the previously written object was
                // deleted.

                if (toWrite == null) {
                    // nothing to write? delete only then.
                    assert previouslyWritten.isRemoved();

                    consumer.removeItem(previouslyWritten, null /*replacedBy*/);

                } else if (previouslyWritten == null || previouslyWritten == toWrite) {
                    // easy one: new or updated res
                    consumer.addItem(toWrite);
                } else {
                    // replacement of a resource by another.

                    // force write the new value
                    toWrite.setTouched();
                    consumer.addItem(toWrite);
                    // and remove the old one
                    consumer.removeItem(previouslyWritten, toWrite);
                }
            }
        } finally {
            consumer.end();
        }

        if (doCleanUp) {
            // reset all states. We can't just reset the toWrite and previouslyWritten objects
            // since overlayed items might have been touched as well.
            // Should also clean (remove) objects that are removed.
            postMergeCleanUp();
        }
    }
