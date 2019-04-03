# calculateBundleNames
    com.intellij.util.ResourceUtil#calculateBundleNames
    
      private static List<String> calculateBundleNames(@NotNull String baseName, @NotNull Locale locale) {
        final List<String> result = new ArrayList<>(3);

        result.add(0, baseName);

        final String language = locale.getLanguage();
        final int languageLength = language.length();
        final String country = locale.getCountry();
        final int countryLength = country.length();
        final String variant = locale.getVariant();
        final int variantLength = variant.length();
        ...
      }
      
    可以看到主要来自 locale
    
    
    List<String> bundles = calculateBundleNames(fixedPath, Locale.getDefault());
    
    java.util.Locale#getDefault()
    public static Locale getDefault() {
        // do not synchronize this method - see 4071298
        return defaultLocale;
    }
    
    private volatile static Locale defaultLocale = initDefault();
    
    private static Locale initDefault() {
        String language, region, script, country, variant;
        language = AccessController.doPrivileged(
            new GetPropertyAction("user.language", "en"));
        // for compatibility, check for old user.region property
        region = AccessController.doPrivileged(
            new GetPropertyAction("user.region"));
        if (region != null) {
            // region can be of form country, country_variant, or _variant
            int i = region.indexOf('_');
            if (i >= 0) {
                country = region.substring(0, i);
                variant = region.substring(i + 1);
            } else {
                country = region;
                variant = "";
            }
            script = "";
        } else {
            script = AccessController.doPrivileged(
                new GetPropertyAction("user.script", ""));
            country = AccessController.doPrivileged(
                new GetPropertyAction("user.country", ""));
            variant = AccessController.doPrivileged(
                new GetPropertyAction("user.variant", ""));
        }

        return getInstance(language, script, country, variant, null);
    }
    
    通过 《配置 vmoptions 中的相关参数》中的介绍，
    配合此方法可知配置
    
    -Duser.language=zh
    -Duser.region=CN
    
    即可修改