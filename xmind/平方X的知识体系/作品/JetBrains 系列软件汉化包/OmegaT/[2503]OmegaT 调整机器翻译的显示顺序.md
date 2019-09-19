因为同时有百度、谷歌翻译，有时候谷歌翻译在后面，而又想使用百度翻译。
```
找到类 org.omegat.gui.exttrans.MachineTranslateTextArea
查找使用，找到
org.omegat.core.Core#machineTranslatePane
org.omegat.core.Core#getMachineTranslatePane
查找使用，定位到
org.omegat.gui.main.MainWindowMenuHandler#editOverwriteMachineTranslationMenuItemActionPerformed
        String tr = Core.getMachineTranslatePane().getDisplayedTranslation();

org.omegat.gui.exttrans.MachineTranslateTextArea#getDisplayedTranslation
    public String getDisplayedTranslation() {
        return displayed;
    }
displayed 的赋值
    @Override
    public void clear() {
        super.clear();
        displayed = null;
    }
    @Override
    protected void setFoundResult(final SourceTextEntry se, final MachineTranslationInfo data) {
        UIThreadsUtil.mustBeSwingThread();

        if (data != null && data.result != null) {
            if (displayed == null) {
                displayed = data.result;
            }
            setText(getText() + data.result + "\n<" + data.translatorName + ">\n\n");
        }
    }
```
也就是说，会赋值第一个翻译结果。
```

    @Override
    protected void setFoundResult(final SourceTextEntry se, final MachineTranslationInfo data) {
        UIThreadsUtil.mustBeSwingThread();

        if (data != null && data.result != null) {
            if (data.translatorName.equals("谷歌翻译X")) {
                //提到最前,如果 getText()为空,会保留 2 个回车,如果不为空,也会包含其之前设置的 2 个回车
                setText(data.result + "\n<" + data.translatorName + ">\n\n" + getText());
                //显示的内容替换为谷歌翻译的结果,用来替换
                displayed = data.result;
                return;
            }
            if (displayed == null) {
                displayed = data.result;
            }
            setText(getText() + data.result + "\n<" + data.translatorName + ">\n\n");
        }
    }

```