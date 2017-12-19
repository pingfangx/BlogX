使用第 2 级别的 tmx 格式交互。  
下列为 Passolo → OmegaT
# 导出
源文件，英文  
目标语言选“中文（简体/中国）”，它对应“_zh_CN”，如果选“中文”只对应“_zh”

然后主页→扫描目标文件（校准），扫描后打开目标，右键，打开全部，在所有字串中全选，已翻译并验证。
已可以在扫描时设置验证，必须验证的翻译才能导出，已翻译并供复审的翻译不会导出。

项目→导出→TMX  
这里也可以导出为 csv 等别的格式，我为了在 OmegaT 中使用，就导出为 tmx 了。

# 导入
删除以下部分，因为“]]>”导致解析出错。
```
<tu tuid="71" segtype="phrase">
<tuv
xml:lang="en-US"
creationid="PASSOLO"
>
<seg>Character sequence ']]>' must not appear in content unless used to mark the end of a CDATA section</seg>
</tuv>
<tuv
xml:lang="zh-CN"
creationid="PASSOLO"
>
<seg>字符序列 ']]>' 不能出现在内容中，除非用于标记 CDATA 部分的结尾</seg>
</tuv>
</tu>
```

然后放到 tmx/auto 中，OmegaT 就可以读取并生成格式化好的 project_save.tmx