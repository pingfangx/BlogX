Q:
* 能否自动点击  

R:
* [Accessibility overview  |  Android Developers](https://developer.android.com/guide/topics/ui/accessibility)
* [android 辅助功能（无障碍） AccessibilityService 实战入门详解 - 王能的小屋 - CSDN博客](https://blog.csdn.net/weimingjue/article/details/82744146)



如果可以，那么写一个辅助将可以使用多种方式
* Python 写脚本，opencv 识图，adb 点击
* 使用测试框架
* 按键精灵 root 点击
* Accessibility


方式|实现|优点|缺点|需求|备注
-|-|-|-|-|-
Python|opencv+adb|写脚本方便||root+抓图+电脑|
测试框架||||电脑|没怎么学习
按键精灵||||root+抓图|写脚本麻烦
Accessibility|Android||Webview 无法操作||


# 基本使用
## Create your accessibility service
## Manifest declarations and permissions
* Accessibility service declaration
* Accessibility service configuration

设置时的 label 和 description 在无障碍设置时都会展示，所以需要填写供用户了解

## Accessibility service methods