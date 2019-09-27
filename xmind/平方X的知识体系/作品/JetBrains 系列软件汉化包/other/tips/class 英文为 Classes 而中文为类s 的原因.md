在双击 Shift 页面，汉化包显示为“类s”  
查找定位到 IdeBundle.properties
    
    go.to.class.kind.text=class

原资源展示为 Classes，但是如果汉化为“类”，则会展示为“类s”  
在源码中搜索并调试，有两什地方调用

    getElementKind:46, GotoClassContributor (com.intellij.navigation)
    getActionTitle:34, GotoClassPresentationUpdater$Companion (com.intellij.ide.actions)
    getActionTitle:-1, GotoClassPresentationUpdater (com.intellij.ide.actions)
    getFullGroupName:54, ClassSearchEverywhereContributor (com.intellij.ide.actions.searcheverywhere)
    lambda$new$1:122, SearchEverywhereUI (com.intellij.ide.actions.searcheverywhere)
    fun:-1, 1572971240 (com.intellij.ide.actions.searcheverywhere.SearchEverywhereUI$$Lambda$1637)
    map2Map:982, ContainerUtil (com.intellij.util.containers)
    <init>:122, SearchEverywhereUI (com.intellij.ide.actions.searcheverywhere)
    createView:211, SearchEverywhereManagerImpl (com.intellij.ide.actions.searcheverywhere)
    show:73, SearchEverywhereManagerImpl (com.intellij.ide.actions.searcheverywhere)
    actionPerformed:592, SearchEverywhereAction (com.intellij.ide.actions)
    actionPerformed:567, SearchEverywhereAction (com.intellij.ide.actions)
    
    com.intellij.ide.actions.searcheverywhere.ClassSearchEverywhereContributor#getFullGroupName
        
      public String getFullGroupName() {
        String[] split = GotoClassPresentationUpdater.getActionTitle().split("/");
        return Arrays.stream(split)
          .map(StringUtil::pluralize)
          .collect(Collectors.joining("/"));
      }

    getElementKind:46, GotoClassContributor (com.intellij.navigation)
    getActionTitle:34, GotoClassPresentationUpdater$Companion (com.intellij.ide.actions)
    getTabTitle:24, GotoClassPresentationUpdater$Companion (com.intellij.ide.actions)
    getTabTitle:-1, GotoClassPresentationUpdater (com.intellij.ide.actions)
    getGroupName:48, ClassSearchEverywhereContributor (com.intellij.ide.actions.searcheverywhere)
    <init>:446, SearchEverywhereUI$SETab (com.intellij.ide.actions.searcheverywhere)
    lambda$createTopLeftPanel$14:432, SearchEverywhereUI (com.intellij.ide.actions.searcheverywhere)
    
    com.intellij.ide.actions.GotoClassPresentationUpdater.Companion#getTabTitle
    
    fun getTabTitle(pluralize: Boolean): String {
      val split = getActionTitle().split("/".toRegex()).take(2).toTypedArray()
      return if (pluralize) StringUtil.pluralize(split[0]) else split[0] + if (split.size > 1) " +" else ""
    }
    
    可以看到，分别由 getFullGroupName 和 getTabTitle 调用了 getActionTitle
    com.intellij.ide.actions.GotoClassPresentationUpdater.Companion#getActionTitle
    
    fun getActionTitle(): String {
      val primaryIdeLanguages = IdeLanguageCustomization.getInstance().primaryIdeLanguages
      val mainContributor = ChooseByNameRegistry.getInstance().classModelContributors
                              .filterIsInstance(GotoClassContributor::class.java)
                              .firstOrNull { it.elementLanguage in primaryIdeLanguages }
      val text = mainContributor?.elementKind ?: IdeBundle.message("go.to.class.kind.text")
      return StringUtil.capitalizeWords(text, " /", true, true)
    }
    
    完成了首字母大写和转为复数的工作，因此加了 s
    
    com.intellij.openapi.util.text.StringUtil#pluralize(java.lang.String)
    
      public static String pluralize(@NotNull String word) {
        String plural = Pluralizer.PLURALIZER.plural(word);
        if (plural != null) return plural;
        if (word.endsWith("s")) return Pluralizer.restoreCase(word, word + "es");
        return Pluralizer.restoreCase(word, word + "s");
      }