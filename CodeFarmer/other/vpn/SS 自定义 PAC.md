[Shadowsocks 进阶之 PAC](https://www.zybuluo.com/yiranphp/note/632963)
> 这三个文件的关系就是： 
> 最终的pac 文件是根据 gfwlist.js 和 user-rule.txt 两个文件共同生成的 
> 如果用户想要添加某些网站进入 PAC，最好的方式是写入 user-rule.txt 这个文件，而不是修改 gfwlist.js 这个文件，因为gfwlist.js这个文件会时不时的和 github 上做同步，可能会造成已有的修改会被覆盖掉。

[ShadowSocks 自定义规则](https://honglu.me/2015/06/26/ShadowSocks%E8%87%AA%E5%AE%9A%E4%B9%89%E8%A7%84%E5%88%99/)

[SS自定义代理规则user-rule设置方法](SS自定义代理规则user-rule设置方法)
> 备注：每次编辑完user-rule.txt后，均需执行“从GFWList更新本地PAC”，使本次规则也生效。

实测只需要修改 user-rule.txt 即可.
