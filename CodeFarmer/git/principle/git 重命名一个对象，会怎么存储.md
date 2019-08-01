根据原理，我们知道

blob 对象的头信息

"blob 16\u0000"

blob 加空格，加长度，加 \0

所以应该数据对象不变，树对象改变。

# 测试
    $ echo 'version 1' > test.txt
    $ git add .
    $ git commit -m 'test'
    只是有 3 个对象
    一个
    
    数据对象
    $ git cat-file -p 83baae61804e65cc73a7201a7252750c76066a30
    version 1

    树对象
    $ git cat-file -p d8329fc1cc938780ffdd9f94e0d364e0ea74f579
    100644 blob 83baae61804e65cc73a7201a7252750c76066a30    test.txt

    提交对象
    $ git cat-file -p d3baaead293e0e46c1cef2cb8fa31b9d3ea059a1
    tree d8329fc1cc938780ffdd9f94e0d364e0ea74f579
    author pingfangx <pingfangx@pingfangx.com> 1562983017 +0800
    committer pingfangx <pingfangx@pingfangx.com> 1562983017 +0800

    test

    查看索引为
    $ git ls-files -c
    test.txt

## 然后重命名
    $ mv test.txt test1.txt
    $ git add .
    $ git commit -m 'test1.txt'
    
    此时有 5 个对象，多了一个树对象，一个提交结象，但是数据对象不变
    
    树对象
    $ git cat-file -p 3ea4a2e8d72b89f2c2bb5c62b9e3d7fcc22f2869
    100644 blob 83baae61804e65cc73a7201a7252750c76066a30    test1.txt

    提交对象
    $ git cat-file -p affc75e2391814bec453d0dab1c5405df2e09dbd
    tree 3ea4a2e8d72b89f2c2bb5c62b9e3d7fcc22f2869
    parent d3baaead293e0e46c1cef2cb8fa31b9d3ea059a1
    author pingfangx <pingfangx@pingfangx.com> 1562983291 +0800
    committer pingfangx <pingfangx@pingfangx.com> 1562983291 +0800

    test1.txt
    
    此时查看索引为
    $ git ls-files -c
    test1.txt

# 总结
重命名文件并提交时，
不同的提交对象指向不同的树对象

不同的树对象指向的相同的数据对象

数据对象的命名取的是 类型+空格+长度+\0+内容，然后取 sha-1