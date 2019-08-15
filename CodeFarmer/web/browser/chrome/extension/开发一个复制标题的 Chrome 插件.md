# 00 需求
写 markdown 的时候，经常要复制标题地址为

    [title](url)

的形式，而有的页面标题不在文章内，只在标题上展示，给复制带来了麻烦，写一个简单的小插件。

# 01 找轮子
[Copy URL + Title](https://chrome.google.com/webstore/detail/copy-url-%20-title/dgagjmdgbakclelfacghmmbadkdegjjh)

通过插件 id 定位到安装后位置

    C:\Users\Admin\AppData\Local\Google\Chrome\User Data\Default\Extensions\dgagjmdgbakclelfacghmmbadkdegjjh
## 学习轮子

# 开发
## 权限
      "permissions": [
        "contextMenus",//创建菜单
        "tabs",//获取标题和地址,否则为空
        "clipboardWrite"//由于实现原因,不需要也能写入,但是还是申请权限,为了以后修改实现
      ],
## 如何添加上下文菜单
## 如何获取页面信息