[extensions](https://developer.chrome.com/extensions)

基本上读完一遍开始动手。

见 WorkspaceX\ChromeExtension\BlockWebsite

# 遇到的一些基础问题
## 如何拦截请求
    chrome.webRequest.onBeforeRequest.addListener(
        function(details) {
            //get and update
            chrome.storage.sync.get('rules', function (result) {
                rules = result.rules;
            });
            //check url
            let needBlock=block(rules, details.url);
            if(needBlock){
                console.log("block url:"+details.url);
            }
            return {cancel: needBlock};
        },
        {urls: ["<all_urls>"]},
        ["blocking"]
    );
    
    需要权限
      "permissions": [
        "webNavigation",
        "webRequest",
        "webRequestBlocking",
        "<all_urls>",
        "tabs",
        "storage"
      ],