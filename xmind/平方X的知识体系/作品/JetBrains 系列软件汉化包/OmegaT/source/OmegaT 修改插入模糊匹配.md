# 如果设置了自动插入模糊匹配
    org.omegat.gui.matches.MatchesTextArea#checkForReplaceTranslation

    执行插入，看 log，editOverwriteTranslationMenuItem
    org.omegat.gui.main.MainWindowMenuHandler#editOverwriteTranslationMenuItemActionPerformed
    org.omegat.gui.main.MainWindow#doRecycleTrans
    
    想要两个都修改，就直接使用替换数字的功能了
    
    
            if (Preferences.isPreference(Preferences.CONVERT_NUMBERS)) {
                translation =
                    substituteNumbers(currentEntry.getSrcText(), thebest.source, thebest.translation);
            }
            ...
            if (Preferences.isPreference(Preferences.CONVERT_NUMBERS)) {
                translation = Core.getMatcher().substituteNumbers(Core.getEditor().getCurrentEntry().getSrcText(),
                        near.source, near.translation);
            }
            
于是添加 org.omegat.gui.matches.MatchesTextArea#substituteTags 方法