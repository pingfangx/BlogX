
添加 entry 如下

    addEntry:196, ParseEntry (org.omegat.core.data)
    processEntry:607, AbstractFilter (org.omegat.filters2)
    privateProcessEntry:204, HTMLFilter2 (org.omegat.filters2.html2)
    maybeTranslateAttribute:256, FilterVisitor (org.omegat.filters2.html2)
    visitTag:186, FilterVisitor (org.omegat.filters2.html2)
    
    org.omegat.filters2.html2.FilterVisitor#visitTag
            ...
            // Translate attributes of tags if they are not null.
            maybeTranslateAttribute(tag, "abbr");
            maybeTranslateAttribute(tag, "alt");
            if (options.getTranslateHref()) {
                maybeTranslateAttribute(tag, "href");
            }
            if (options.getTranslateHreflang()) {
                maybeTranslateAttribute(tag, "hreflang");
            }
            if (options.getTranslateLang()) {
                maybeTranslateAttribute(tag, "lang");
                maybeTranslateAttribute(tag, "xml:lang");
            }
            maybeTranslateAttribute(tag, "label");
            if ("IMG".equals(tag.getTagName()) && options.getTranslateSrc()) {
                maybeTranslateAttribute(tag, "src");
            }
            maybeTranslateAttribute(tag, "summary");
            maybeTranslateAttribute(tag, "title");
            
    可以看到有的受选项控制，有的则不受，alt 就不受。
    因为感觉 alt 实际没有翻译的必要，想要修改代码将其过滤，但是其实数量也不是很多，也就罢了。