# OmegaT 会自动将标签缩短
    org.omegat.filters2.html2.FilterVisitor#endup
        // expands tag shortcuts into full-blown tags
        translation = unshorcutize(translation);
        
    根据 unshorcutize 找到 org.omegat.filters2.html2.FilterVisitor#shortcut 方法
    
    /**
     * Creates and stores a shortcut for the tag.
     */
    private void shortcut(Tag tag, StringBuilder paragraph) {
        StringBuilder result = new StringBuilder();
        //① <
        result.append('<');
        int n = -1;
        if (tag.isEndTag()) {
            result.append('/');
            // trying to lookup for appropriate starting tag
            int recursion = 1;
            for (int i = sTags.size() - 1; i >= 0; i--) {
                Tag othertag = sTags.get(i);
                if (othertag.getTagName().equals(tag.getTagName())) {
                    if (othertag.isEndTag()) {
                        recursion++;
                    } else {
                        recursion--;
                        if (recursion == 0) {
                            // we've found a starting tag for this ending one
                            // !!!
                            n = sTagNumbers.get(i);
                            break;
                        }
                    }
                }
            }
            if (n < 0) {
                // ending tag without a starting one
                n = sNumShortcuts;
                sNumShortcuts++;
            }
        } else {
            //①获取 n
            n = sNumShortcuts;
            sNumShortcuts++;
        }

        // special handling for BR tag, as it's given a two-char shortcut
        // to allow for its segmentation in sentence-segmentation mode
        // idea by Jean-Christophe Helary
        if ("BR".equals(tag.getTagName())) {
            result.append("br");
        } else {
            // ②添加小写的第一个代码点
            result.appendCodePoint(Character.toLowerCase(tag.getTagName().codePointAt(0)));
        }
        // ③添加序号
        result.append(n);
        if (tag.isEmptyXmlTag()) { // This only detects tags that already have a
                                   // slash in the source,
            result.append('/'); // but ignores HTML 4.x style <br>, <img>, and
                                // similar tags without one
                                // The code below would fix that, but breaks
                                // backwards compatibility
                                // with previously translated HTML files
        }
        // if (tag.isEmptyXmlTag() || tag.getTagName().equals("BR") ||
        // tag.getTagName().equals("IMG"))
        // result.append('/');
        // ④添加 >
        result.append('>');

        String shortcut = result.toString();
        sTags.add(tag);
        sTagNumbers.add(n);
        sShortcuts.add(shortcut);
        paragraph.append(shortcut);
    }
    
# 处理
所以只是转为小写，没有特殊的处理规则，直接用 Python 脚本处理