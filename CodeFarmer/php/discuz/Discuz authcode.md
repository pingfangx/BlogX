
[Discuz!开发之核心加密解密函数authcode()介绍](https://blog.csdn.net/lih062624/article/details/70143986)

    // $string： 明文 或 密文  
    // $operation：DECODE表示解密,其它表示加密  
    // $key： 密匙  
    // $expiry：密文有效期  
    function authcode($string, $operation = 'DECODE', $key = '', $expiry = 0) {
        // 动态密匙长度，相同的明文会生成不同密文就是依靠动态密匙 
        $ckey_length = 4;
        // 密匙
        $key = md5($key != '' ? $key : getglobal('authkey'));
        // 密匙a会参与加解密  
        $keya = md5(substr($key, 0, 16));
        // 密匙b会用来做数据完整性验证  
        $keyb = md5(substr($key, 16, 16));
        // 密匙c用于变化生成的密文  
        $keyc = $ckey_length ? ($operation == 'DECODE' ? substr($string, 0, $ckey_length): substr(md5(microtime()), -$ckey_length)) : '';
        // 参与运算的密匙 
        $cryptkey = $keya.md5($keya.$keyc);
        $key_length = strlen($cryptkey);
        // 明文，前10位用来保存时间戳，解密时验证数据有效性，10到26位用来保存$keyb(密匙b)，解密时会通过这个密匙验证数据完整性  
        // 如果是解码的话，会从第$ckey_length位开始，因为密文前$ckey_length位保存 动态密匙，以保证解密正确  
        $string = $operation == 'DECODE' ? base64_decode(substr($string, $ckey_length)) : sprintf('%010d', $expiry ? $expiry + time() : 0).substr(md5($string.$keyb), 0, 16).$string;
        $string_length = strlen($string);
     
     
        $result = '';
        $box = range(0, 255);
     
     
        $rndkey = array();
        // 产生密匙簿  
        for($i = 0; $i <= 255; $i++) {
            $rndkey[$i] = ord($cryptkey[$i % $key_length]);
        }
        // 用固定的算法，打乱密匙簿，增加随机性，好像很复杂，实际上对并不会增加密文的强度  
        for($j = $i = 0; $i < 256; $i++) {
            $j = ($j + $box[$i] + $rndkey[$i]) % 256;
            $tmp = $box[$i];
            $box[$i] = $box[$j];
            $box[$j] = $tmp;
        }
        // 核心加解密部分  
        for($a = $j = $i = 0; $i < $string_length; $i++) {
            $a = ($a + 1) % 256;
            $j = ($j + $box[$a]) % 256;
            $tmp = $box[$a];
            $box[$a] = $box[$j];
            $box[$j] = $tmp;
            // 从密匙簿得出密匙进行异或，再转成字符  
            $result .= chr(ord($string[$i]) ^ ($box[($box[$a] + $box[$j]) % 256]));
        }
        if($operation == 'DECODE') {
            // substr($result, 0, 10) == 0 验证数据有效性  
            // substr($result, 0, 10) - time() > 0 验证数据有效性  
            // substr($result, 10, 16) == substr(md5(substr($result, 26).$keyb), 0, 16) 验证数据完整性  
            // 验证数据有效性，请看未加密明文的格式 	
            if((substr($result, 0, 10) == 0 || substr($result, 0, 10) - time() > 0) && substr($result, 10, 16) == substr(md5(substr($result, 26).$keyb), 0, 16)) {
                return substr($result, 26);
            } else {
                return '';
            }
        } else {
            // 把动态密匙保存在密文里，这也是为什么同样的明文，生产不同密文后能解密的原因  
            // 因为加密后的密文可能是一些特殊字符，复制过程可能会丢失，所以用base64编码  	
            return $keyc.str_replace('=', '', base64_encode($result));
        }
    }
    
# authkey
    \discuz_application::_init_config
        ...
        if(empty($_config['security']['authkey'])) {
            $_config['security']['authkey'] = md5($_config['cookie']['cookiepre'].$_config['db'][1]['dbname']);
        }
        ...
        // cookiepath 拼上 | 拼上cookiedomiain，求 md5 ，取前 4 个字符，再拼上 _
        $this->var['config']['cookie']['cookiepre'] = $this->var['config']['cookie']['cookiepre'].substr(md5($this->var['config']['cookie']['cookiepath'].'|'.$this->var['config']['cookie']['cookiedomain']), 0, 4).'_';

    \discuz_application::_init_input
        //从 cookie 中取值，取出 saltkey
        $prelength = strlen($this->config['cookie']['cookiepre']);
        foreach($_COOKIE as $key => $val) {
            if(substr($key, 0, $prelength) == $this->config['cookie']['cookiepre']) {
                $this->var['cookie'][substr($key, $prelength)] = $val;
            }
        }
        ...
        if(empty($this->var['cookie']['saltkey'])) {
            $this->var['cookie']['saltkey'] = random(8);
            dsetcookie('saltkey', $this->var['cookie']['saltkey'], 86400 * 30, 1, 1);
        }
        ...
        // config.security.authkey 加上 cookie.saltkey 取 md5
        $this->var['authkey'] = md5($this->var['config']['security']['authkey'].$this->var['cookie']['saltkey']);
        
        
可以看到，加密依赖 authkey，authkey 的生成依赖 saltkey  
saltkey 随机生成，保存在 cookie 中
取出 saltkey 依赖 cookiepre，cookiepre 依赖 cookiepath 和 cookiedomain



# python 实现
tool.blogx.discuz.descuz_source.DiscuzSource

        将 php 翻译为 python，增强理解
        key 取的 authkey ，authkey 由配置的 authkey 和 saltkey 生成，每个人随机的 saltkey 不一致，保存在 cookie 中
        用 key 生成 crypkey 和 kaya,keyb
        keyc 用来加上时间，使得相同 key 的加密结果也不一致，但是为了解密，keyc 需要拼接在结果上
        时间拼在 0-10 用来记录时间，keyb 处理后拼在 10-16 用来校验完整性
        crypkey 生成密匙簿
        根据密匙簿进行异或处理，得出加密后的数据
        最后 base64.encode 并在前面拼上 keyc
        
