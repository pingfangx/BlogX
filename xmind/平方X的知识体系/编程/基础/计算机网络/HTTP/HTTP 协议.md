[RFC 2616](https://tools.ietf.org/html/rfc2616) 是真的长。  
但是内容都很详细，请求、响应、方法、错法码等都有明确说明。  
想到这是与自己每天打交道的协议，于是再难也要把它啃下来，加油。

翻译到状态码的时候，发现 2616 已废弃了，被 7230-7235 代替。  
不过也好，了解以前的，比较与新的规范的区别。

# 概述
根据目录，需要了解以下内容
* 基础知识
* 消息
* 请求
* 响应
* 实体
* 连接
* 方法
* 状态码

# 3 协议参数
## 传输统码与内容编码
在文中多次提到

## 3.5 内容编码
* 实体的属性
* 内容编码值指示已经或可以应用于实体的编码变换。
* 内容编码主要用于允许文档被压缩或以其他方式有用地转换而不会丢失其基础媒体类型的身份并且不会丢失信息。

## 3.6 传输编码
* 消息的属性  
* 传输编码必须用于指示应用程序应用的任何传输编码，以确保安全和正确地传输消息。

# 4 消息
## 4.3 消息主体
> The rules for when a message-body is allowed in a message differ for requests and responses.

> The presence of a message-body in a request is signaled by the inclusion of a Content-Length or Transfer-Encoding header field in the request's message-headers. A message-body MUST NOT be included in a request if the specification of the request method (section 5.1.1) does not allow sending an entity-body in requests. A server SHOULD read and forward a message-body on any request; if the request method does not include defined semantics for an entity-body, then the message-body SHOULD be ignored when handling the request.

> For response messages, whether or not a message-body is included with a message is dependent on both the request method and the response status code (section 6.1.1). All responses to the HEAD request method MUST NOT include a message-body, even though the presence of entity- header fields might lead one to believe they do. All 1xx (informational), 204 (no content), and 304 (not modified) responses MUST NOT include a message-body. All other responses do include a message-body, although it MAY be of zero length.

> 消息中允许消息主体的规则因请求和响应而异。

> 在请求的消息首部中包含 Content-Length 或 Transfer-Encoding 首部字段，可以指示请求中存在消息主体。如果请求方法的规范(第 5.1.1 节)不允许在请求中发送实体主体，则消息主体不得包含在请求中。服务器应该在任何请求上读取和转发消息主体；如果请求方法不包含实体主体的定义语义，那么在处理请求时应该忽略消息主体。

> 对于响应消息，消息主体是否包含在消息中取决于请求方法和响应状态代码(第 6.1.1 节)。对 HEAD 请求方法的所有响应都不得包含消息主体，即使实体首部字段的存在可能导致人们以为它们包含消息主体。所有 1xx(信息)，204(无内容)和 304(未修改)响应不得包含消息主体。所有其他响应都包含一个消息主体，尽管它的长度可能为零。