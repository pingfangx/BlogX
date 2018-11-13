记得之前好像分析过了，但是找不到笔记了。
# 登录
[discuz登录流程解析(版本X3.2)](https://blog.csdn.net/phpbook/article/details/51693122)

    form post 到 action="member.php?mod=logging&action=login

    member.php
    source/module/member/member_logging.php
    
        $ctl_obj = new logging_ctl();
        $ctl_obj->setting = $_G['setting'];
        $method = 'on_'.$_GET['action'];
        $ctl_obj->template = 'member/login';
        $ctl_obj->$method();
        
    source/class/class_member.php
    \logging_ctl::on_login
            ...
            $result = userlogin($_GET['username'], $_GET['password'], $_GET['questionid'], $_GET['answer'], $this->setting['autoidselect'] ? 'auto' : $_GET['loginfield'], $_G['clientip']);
            $uid = $result['ucresult']['uid'];
            ...
            if($result['status'] > 0) {
                ...
                setloginstatus($result['member'], $_GET['cookietime'] ? 2592000 : 0);
不分析登录过程，查看如何记录 cookie

# 记录 cookie
    source/function/function_member.php
    \setloginstatus
        dsetcookie('auth', authcode("{$member['password']}\t{$member['uid']}", 'ENCODE'), $cookietime, 1, true);

    source/function/function_core.php
    \dsetcookie
    
    function dsetcookie($var, $value = '', $life = 0, $prefix = 1, $httponly = false) {

        global $_G;

        $config = $_G['config']['cookie'];

        $_G['cookie'][$var] = $value;
        $var = ($prefix ? $config['cookiepre'] : '') . $var;
        $_COOKIE[$var] = $value;

        if ($value == '' || $life < 0) {
            $value = '';
            $life = -1;
        }

        if (defined('IN_MOBILE')) {
            $httponly = false;
        }

        $life = $life > 0 ? getglobal('timestamp') + $life : ($life < 0 ? getglobal('timestamp') - 31536000 : 0);
        $path = $httponly && PHP_VERSION < '5.2.0' ? $config['cookiepath'] . '; HttpOnly' : $config['cookiepath'];

        $secure = $_SERVER['SERVER_PORT'] == 443 ? 1 : 0;
        if (PHP_VERSION < '5.2.0') {
            setcookie($var, $value, $life, $path, $config['cookiedomain'], $secure);
        } else {
            setcookie($var, $value, $life, $path, $config['cookiedomain'], $secure, $httponly);
        }
    }
    
    可以看到，cookie 使用了前缀
    $config['cookiepre']
    
    如果未勾选自动登录，
    expire 为 0
    If set to 0, or omitted, the cookie will expire at the end of the session (when the browser closes).

    如果勾选，cookietime 为 true，则传值 2592000
    2592000=60*60*24*30

# cookiepre
    cookiepre 位于，$_G['config']['cookie']['cookiepre']
    赋值过程位于
    source/class/discuz/discuz_application.php
    \discuz_application::_init_config
        //读取
        @include DISCUZ_ROOT.'./config/config_global.php';
        
        // cookiepath 拼上 | 拼上cookiedomiain，求 md5 ，取前 4 个字符，再拼上 _
        $this->var['config']['cookie']['cookiepre'] = $this->var['config']['cookie']['cookiepre'].substr(md5($this->var['config']['cookie']['cookiepath'].'|'.$this->var['config']['cookie']['cookiedomain']), 0, 4).'_';
    