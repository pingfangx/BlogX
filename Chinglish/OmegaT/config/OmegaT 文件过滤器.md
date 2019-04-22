项目属性 > 文件过滤器 > 设为项目专用 > HTML > 选项

## 新增或重写HTML和XHTML文件中的编码声明
从不

## 翻译下列属性
全部去掉


## 
org.omegat.filters2.html2.HTMLFilter2#privateProcessEntry
## 不翻译含下列属性键值对（逗号分隔）的标签内容
class=codeblock



## 不翻译元标签……的内容属性：下列元标签将不进行翻译。
> Do not translate the content attribute of meta-tags ... : The following meta-tags will not be translated.

    org.omegat.filters2.html2.FilterVisitor#visitTag
    
            if ("META".equals(tag.getTagName())) {
                Vector<?> tagAttributes = tag.getAttributesEx();
                Iterator<?> i = tagAttributes.iterator();
                boolean doSkipMetaTag = false;
                while (i.hasNext() && !doSkipMetaTag) {
                    Attribute attribute = (Attribute) i.next();
                    String name = attribute.getName();
                    String value = attribute.getValue();
                    if (name == null || value == null) {
                        continue;
                    }
                    doSkipMetaTag = this.filter.checkDoSkipMetaTag(name, value);
                }
                if (!doSkipMetaTag) {
                    maybeTranslateAttribute(tag, "content");
                }
            }
            
## 不翻译含下列属性键值对（逗号分隔）的标签内容：匹配列表中键值对的标签内容将被忽略。
> Do not translate the content of tags with the following attribute key-value pairs (separate with commas): a match in the list of key-value pairs will cause the content of tags to be ignored

    org.omegat.filters2.html2.FilterVisitor#visitTag
    
        boolean intactTag = isIntactTag(tag);

        if (!intactTag) { // If it's an intact tag, no reason to check
            // Decide whether this tag should be intact, based on the key-value pairs stored in the
            // configuration
            Vector<?> tagAttributes = tag.getAttributesEx();
            Iterator<?> i = tagAttributes.iterator();
            while (i.hasNext() && !intactTag) {
                Attribute attribute = (Attribute) i.next();
                String name = attribute.getName();
                String value = attribute.getValue();
                if (name == null || value == null) {
                    continue;
                }
                intactTag = this.filter.checkIgnoreTags(name, value);
            }
        }