
# 片段分割
    List<?> 不分割
    List<? super Integer> 被分割了
在生成结果文件时下断

    org.omegat.filters2.ITranslateCallback#getTranslation(java.lang.String, java.lang.String, java.lang.String)
    org.omegat.core.segmentation.Segmenter#segment
    org.omegat.core.segmentation.Segmenter#breakParagraph
    
    private List<String> breakParagraph(Language lang, String paragraph, List<Rule> brules) {
        List<Rule> rules = srx.lookupRulesForLanguage(lang);

        // determining the applicable break positions
        Set<BreakPosition> dontbreakpositions = new TreeSet<BreakPosition>();
        Set<BreakPosition> breakpositions = new TreeSet<BreakPosition>();
        for (int i = rules.size() - 1; i >= 0; i--) {
            Rule rule = rules.get(i);
            List<BreakPosition> rulebreaks = getBreaks(paragraph, rule);
            if (rule.isBreakRule()) {
                //分割
                breakpositions.addAll(rulebreaks);
                dontbreakpositions.removeAll(rulebreaks);
            } else {
                //不分割
                dontbreakpositions.addAll(rulebreaks);
                breakpositions.removeAll(rulebreaks);
            }
        }
        breakpositions.removeAll(dontbreakpositions);
        ...
    }

    断点看到被以下规则分割
    Break Before: [\.\?\!]+After: \s
    也就是以 ? 开头，后跟空白。
    按理说这是表示疑问句结尾，分割是正常的。
    
    
    因此添加规则
    Exception Before: <\?After: \s
    即 <? 后跟空白 不分割
    
    因为 rules 是倒序遍历，只需将此规则添加到旧规则之前即可。
    旧规则位于 缺省 中，
    新建语言在缺省之前，添加规则，成功