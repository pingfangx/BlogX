经常不写手生。


# Spider
    新建类
    class WeiboVideoSpider(scrapy.Spider)
    
    在 def start_requests(self): 中执行请求
    yield scrapy.Request(url=url)

## 解析
    在 def parse(self, response): 中解析结果
    可以使用 xpath 也可以使用 bs4
    解析后 yield item
    
# Item
    item 继承 BaseItem 就行了，
    添加要保存的字段
    scrapy.Field()
    
# Pipeline

    通过设置 spider 的 custom_settings 设置
    负责保存