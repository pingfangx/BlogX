[GET method doesn't support body payload · Issue #2136 · swagger-api/swagger-ui](https://github.com/swagger-api/swagger-ui/issues/2136#issuecomment-270791661)

[rest - HTTP GET with request body - Stack Overflow](https://stackoverflow.com/questions/978061/http-get-with-request-body)


根据相关的回答，找了相关 rfc 的原文。

[RFC 7230 3.3](https://tools.ietf.org/html/rfc7230#section-3.3)
> The presence of a message body in a request is signaled by a
   Content-Length or Transfer-Encoding header field.  Request message
   framing is independent of method semantics, even if the method does
   not define any use for a message body.

> 请求中存在消息主体由 Content-Length 或 Transfer-Encoding 首部字段指示。请求消息帧独立于方法语义，即使该方法没有为消息主体定义任何用途。

[RFC 7231 4.3.1](https://tools.ietf.org/html/rfc7231#section-4.3.1)
> A payload within a GET request message has no defined semantics;
   sending a payload body on a GET request might cause some existing
   implementations to reject the request.

> GET 请求消息中的有效载荷没有定义的语义；在 GET 请求上发送有效载荷主体可能会导致某些现有实现拒绝该请求。

以及旧版本的 2616 规定
[RFC 2616 4.3](https://tools.ietf.org/html/rfc2616#section-4.3)
> The presence of a message-body in a request is signaled by the
   inclusion of a Content-Length or Transfer-Encoding header field in
   the request's message-headers. A message-body MUST NOT be included in
   a request if the specification of the request method (section 5.1.1)
   does not allow sending an entity-body in requests. A server SHOULD
   read and forward a message-body on any request; if the request method
   does not include defined semantics for an entity-body, then the
   message-body SHOULD be ignored when handling the request.

> 在请求的消息首部中包含 Content-Length 或 Transfer-Encoding 首部字段，可以指示请求中存在消息主体。如果请求方法的规范(第 5.1.1 节)不允许在请求中发送实体主体，则消息主体不得包含在请求中。服务器应该在任何请求上读取和转发消息主体；如果请求方法不包含实体主体的定义语义，那么在处理请求时应该忽略消息主体。
# 总结
* 除了禁止发送消息主体的请求方法，都可以带 body
* 如果请求方法不包含消息主体的定义语义，服务器可能会忽略 body
* 如果请求方法的有效载荷没有定义的语义，可能会导致某些现有实现拒绝该请求。

有效荷载的定义参见 RFC 7231 3.3

那哪些请求方法不允许消息主体呢，参见 RFC 7231 4.3  
列出的方法可能不全，

方法|主体语义|备注
-|-|-
GET|-|
HEAD|-|
POST|√|
PUT|√|
DELETE|-|
CONNECT|-|
OPTIONS|√|暂未定义消息主体用途
TRACE|×|不得包含

整理了一下，只有 TRACE 明确说明了不得包含消息主体  
但这不是所有的 HTTP 方法，还有其他方法，参见《HTTP 的所有方法》