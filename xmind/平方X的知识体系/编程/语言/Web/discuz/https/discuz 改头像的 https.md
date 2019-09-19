发现请求的是 http

找到模板是 wwwroot/template/default/common/header_userstatus.htm

    
	<div class="avt y"><!--{avatar(0,small)}--></div>
    
这是如何被解析的呢，搜索 avatar 很多结果，定位到了

    class_template.php:294, template->avatartags()
        $this->replacecode['replace'][$i] = "<?php echo avatar($parameter);?>";
    class_template.php:148, template->parse_template_callback_avatartags_1()
    class_template.php:59, preg_replace_callback()
        $template = preg_replace_callback("/[\n\r\t]*\{avatar\((.+?)\)\}[\n\r\t]*/i", array($this, 'parse_template_callback_avatartags_1'), $template);
    class_template.php:59, template->parse_template()
    function_core.php:500, checktplrefresh()
    function_core.php:645, template()
    3_diy_xx_header.tpl.php:121, include()
    xxindex.php:19, require()
    index.php:39, {main}()
    
    输出为
    <?php echo avatar($_G[uid],small);?>
    所以查看 avatar 函数
    wwwroot/source/function/function_core.php
    
        $ucenterurl = empty($ucenterurl) ? $_G['setting']['ucenterurl'] : $ucenterurl;
        
    所以是地址没取对
    
    wwwroot/source/function/cache/cache_setting.php
	require_once DISCUZ_ROOT.'./config/config_ucenter.php';
	$data['ucenterurl'] = UC_API;
    
    发现是没改全

## 修改头像的 https
    搜索
    define('UC_API'
    
    wwwroot/uc_server/admin.php
    wwwroot/uc_server/avatar.php
    wwwroot/uc_server/index.php
    
    最后修改配置文件
    wwwroot/config/config_ucenter.php
    
    然后清除模板缓存