# 目的
自带的是转到 https://translate.google.com/?source=gtx_c#auto/zh-CN/

被墙了，改为转到 https://translate.google.cn/#en/zh-CN/

# 学习
    根据 id 查看源码
    根据 manifest.json 了解权限
    "permissions": [ "activeTab", "contextMenus", "storage" ],
    
    因为要创建菜单，搜索 contextMenus 找到
    
    chrome.contextMenus.create({
        id: "translate", title: function (a) {
            a = chrome.i18n.getMessage(a);
            return chrome.i18n.getMessage(a)
        }("MSG_FOOTER_TRANSLATE"), contexts: ["selection"]
    });
    chrome.contextMenus.onClicked.addListener(function (a) {
        chrome.tabs.create({url: ea(Bb(), a.selectionText)})
    });
    
    可以看到字符串两层调用
    
       "MSG_FOOTER_TRANSLATE": {
          "message": "8969005060131950570"
       },
    
       "8969005060131950570": {
          "message": "Google 翻译"
       },
       
# 知识点
## 选中菜单
是 contextMenu 的一部分，在添加时指定 "contexts": ['all'], 即可

## 打开 tab
    chrome.tabs.create({
        'url':url
    })