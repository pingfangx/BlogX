# 0x00 前言
之前使用 HtmlUnit 实现，但比较笨，后来还失效了。[让OmegaT支持百度翻译和谷歌翻译](http://blog.pingfangx.com/2359.html)  
于是这一次重写插件，  
[[2487]OmegaT 谷歌翻译插件开发记录](http://blog.pingfangx.com/2487.html)  
[[2488]OmegaT 百度翻译插件开发记录](http://blog.pingfangx.com/2488.html)  

# 0x01 appId 和 securityKey
>若当月翻译字符数≤2百万，当月免费；若超过2百万字符，按照49元/百万字符支付当月全部翻译字符数费用

可以免费使用，配置 appId 和 securityKey 即可。

# 0x02 保存
以前是在 OmegaT.l4J.ini 中设置，发现改了。查看其他机器翻译，
## 获取
```
        String appId = getCredential(PROPERTY_BAIDU_APP_ID);
        if (appId == null || appId.isEmpty()) {
            return "need config " + PROPERTY_BAIDU_APP_ID;
        }
        String securityKey = getCredential(PROPERTY_BAIDU_SECURITY_KEY);
        if (securityKey == null || securityKey.isEmpty()) {
            return "need config " + PROPERTY_BAIDU_SECURITY_KEY;
        }
```
## 写入
```
    @Override
    public boolean isConfigurable() {
        return true;
    }

    @Override
    public void showConfigurationUI(Window parent) {
        MTConfigDialog dialog = new MTConfigDialog(parent, getName()) {
            @Override
            protected void onConfirm() {
                boolean temporary = panel.temporaryCheckBox.isSelected();
                String appId = panel.valueField1.getText().trim();
                setCredential(PROPERTY_BAIDU_APP_ID, appId, temporary);
                String securityKey = panel.valueField2.getText().trim();
                setCredential(PROPERTY_BAIDU_SECURITY_KEY, securityKey, temporary);
            }
        };
        dialog.panel.valueLabel1.setText(PROPERTY_BAIDU_APP_ID);
        dialog.panel.valueField1.setText(getCredential(PROPERTY_BAIDU_APP_ID));
        dialog.panel.valueLabel2.setText(PROPERTY_BAIDU_SECURITY_KEY);
        dialog.panel.valueField2.setText(getCredential(PROPERTY_BAIDU_SECURITY_KEY));
        dialog.panel.temporaryCheckBox.setSelected(isCredentialStoredTemporarily(PROPERTY_BAIDU_APP_ID));
        dialog.show();
    }
```