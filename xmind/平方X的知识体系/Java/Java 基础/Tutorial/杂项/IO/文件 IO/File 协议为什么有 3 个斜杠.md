根据 rfc 3986，URI 由 Scheme、Authority、Path、Query、Fragment 等组成

考虑 file 协议是与最终用户的本地上下文相关的 URI

于是 Authority 为空，但是
> 权限组件前面有一个双斜杠(“//”)，并由下一个斜杠(“/”)，问号(“?”)或数字符号(“#”)字符终止，或者由 URI 的结束终止。

因此将其理解为前两个 // 是 Scheme 的结尾，第三个 / 是 Authority 的结尾

暂时没有查到相关介绍，仅是个人为了理解记忆的猜想。

# 补充
在 java.net.URI#URI(java.lang.String) 的文档中有介绍，佐证了上面的猜测。