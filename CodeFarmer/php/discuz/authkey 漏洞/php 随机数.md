[php的随机数的安全性分析](http://wonderkun.cc/index.html/?p=585)

    <?php
    mt_srand(1234);
    echo "mt_rand 函数在种子是1234时产生的随机数序列:<br/>";
    for ($i = 1; $i < 10; $i++) {
        echo mt_rand() . "<br/>";
    }

不管运行几次，结果都是一样的。

    mt_rand 函数在种子是1234时产生的随机数序列:
    411284887
    1068724585
    1335968403
    1756294682
    940013158
    1314500282
    1686544716
    1656482812
    1674985287

# 当随机数种子相同的时候,无论运行多少次,产生的随机数序列都是一样的

# [php_mt_seed - PHP mt_rand() seed cracker](https://www.openwall.com/php_mt_seed/)
下载后，看 Makefile，需要 [GCC](https://zh.wikipedia.org/wiki/GCC)

下载 Cygwin，下载 gcc，编译后得 php_mt_seed.exe

    $ ./php_mt_seed.exe 411284887
    Pattern: EXACT
    Version: 3.0.7 to 5.2.0
    Found 0, trying 0x20000000 - 0x23ffffff, speed 114.3 Mseeds/s
    seed = 0x236c4c32 = 594299954 (PHP 3.0.7 to 5.2.0)
    seed = 0x236c4c33 = 594299955 (PHP 3.0.7 to 5.2.0)
    Found 2, trying 0x68000000 - 0x6bffffff, speed 114.8 Mseeds/s
    seed = 0x6bad43fc = 1806517244 (PHP 3.0.7 to 5.2.0)
    seed = 0x6bad43fd = 1806517245 (PHP 3.0.7 to 5.2.0)
    Found 4, trying 0xfc000000 - 0xffffffff, speed 115.2 Mseeds/s
    Version: 5.2.1+
    Found 4, trying 0x00000000 - 0x01ffffff, speed 0.0 Mseeds/s
    seed = 0x000004d2 = 1234 (PHP 7.1.0+)
    Found 5, trying 0x02000000 - 0x03ffffff, speed 0.9 Mseeds/s

php_mt_seed 的文档位于 README
> php_mt_seed expects 1, 2, 4, or more numbers on its command line. The numbers specify constraints on mt_rand() outputs.

> When invoked with only 1 number, that's the first mt_rand() output to find seeds for.

> When invoked with 2 numbers, those are the bounds (minimum and maximum, in that order) that the first mt_rand() output should fall within.

> When invoked with 4 numbers, the first 2 give the bounds for the first mt_rand() output and the second 2 give the range passed into mt_rand().

> When invoked with 5 or more numbers, each group of 4 and then the last group of 1, 2, or (usually) 4 are processed as above, where each group refers to a corresponding mt_rand() output.
也就是 4 个一组，前 2 个给出输出结果的范围，后 2 个给传递给 mt_rand 的参数。