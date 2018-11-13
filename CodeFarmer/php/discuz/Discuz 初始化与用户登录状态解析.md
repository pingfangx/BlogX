# C::app()->init()
    一般都会引用
    require './source/class/class_core.php';
    然后初始化
    C::app()->init();
    
    source/class/class_core.php
        C::creatapp();
            self::$_app = discuz_application::instance();
    source/class/discuz/discuz_application.php
        \discuz_application::__construct
            public function __construct() {
                $this->_init_env();
                $this->_init_config();
                $this->_init_input();
                $this->_init_output();
            }

            public function init() {
                if(!$this->initated) {
                    $this->_init_db();
                    $this->_init_setting();
                    $this->_init_user();
                    $this->_init_session();
                    $this->_init_mobile();
                    $this->_init_cron();
                    $this->_init_misc();
                }
                $this->initated = true;
            }
# _init_user
    \discuz_application::_init_user
    
        if($this->init_user) {
            // 从 cookie 取出 auth
            if($auth = getglobal('auth', 'cookie')) {
                // auth 解密，得到帐号密码
                $auth = daddslashes(explode("\t", authcode($auth, 'DECODE')));
            }
            //获取 密码和 uid
            list($discuz_pw, $discuz_uid) = empty($auth) || count($auth) < 2 ? array('', '') : $auth;

            //根据 uid 获取用户
            if($discuz_uid) {
                $user = getuserbyuid($discuz_uid, 1);
            }

            //用户密码与取出的密码相同，视为登录成功
            if(!empty($user) && $user['password'] == $discuz_pw) {
                if(isset($user['_inarchive'])) {
                    C::t('common_member_archive')->move_to_master($discuz_uid);
                }
                $this->var['member'] = $user;
            } else {
                $user = array();
                $this->_init_guest();
            }
            ...
# $_G
    \discuz_application::_init_env
        global $_G;
        $_G = array(
            ...
        );
        $this->var = & $_G;
    \discuz_application::_init_config
        $_config = array();
        @include DISCUZ_ROOT.'./config/config_global.php';
        
        $this->config = & $_config;
        $this->var['config'] = & $_config;