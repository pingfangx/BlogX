前面得到了公钥、私钥

    n,e 与 n,d
    (3233,17) (3233,2753)
    
# 加密
    假设加密 m ，即求出下式的 c

    m^e ≡ c (mod n)
    e 为 17，n 为 3233，假设 m 为 65，即求出 m 的加密结果 c
    65^17 ≡ c (mod 3233)
    于是 c = 2790
    
# 解密
    c^d ≡ m (mod n)
    2790^2753 ≡ m (mod 3233)
    求得 m
    
# 证明
    c^d ≡ m (mod n)
    
    ∵ m^e ≡ c (mod n)
    c 为余数
    ∴ c=m^e - kn
    c 代入
    (m^e - kn)^d ≡ m (mod n)
    它等同于求证
    m^(ed) ≡ m (mod n)
    这一步等同于是如何来的
    将(m^e - kn)^d 展开合并，第一项为 m^(ed)，后面的每一项都包含 kn 
    
    d 是模反元素
    ed ≡ 1(mod φ(n))
    所以 ed=h(φ(n))+1 
    代入得
    m^(h(φ(n))+1) ≡ m (mod n)
    
    证明该式
    一，如果 m 与 n 互质
    有 m^φ(n) ≡ 1 (mod n)
    所以
    m^(h(φ(n))+1)
    =m^(h(φ(n)))× m
    =m^(φ(n))^h × m
    所以余数为 m
    
    二，如果 m 与 n 不互质
    此时，由于n等于质数p和q的乘积，所以m必然等于kp或kq。
    因为这样，m 与 n 才会有公因子 p 或 q。
    
    以 m = kp为例，考虑到这时k与q必然互质
    必然互质，是因为 q 已经是质数了，而 
    qp = n
    kp = m
    因为 m < n，所以 k < q
    q 是质数，所以小于 q 的 k 必然与 q 互质
    
    m 与 q 互质，根据欧拉定理
    m^(q-1) ≡ 1 (mod q)
    (kp)^(q-1) ≡ 1 (mod q)
    
    得到
    [(kp)^(q-1)]^(h(p-1)) × kp ≡ kp (mod q)
    这一步是因为，余数为 1，则取 h(p-1) 余数仍为 1，再× kp 余数为 kp
    
    接下来
    (kp)^[(q-1)×h×(p-1)+1] ≡ kp (mod q)
    因为 (q-1)×(p-1) 得 φ(n)
    面 h(φ(n))+1 得 ed
    所以
    (kp)^ed ≡ kp (mod q)
    
    即余数为 kp，那么可以改写为
    (kp)^(ed) = tq + kp
    
    这时t必然能被p整除，即 t=t'p
    为什么必然，这里也卡了我很长时间，脑子有点笨。
    因为前面是 (kp)^(ed) ，后面是 1 个 kp，都是 kp 的倍数
    所以，tq=(kp)^(ed)-kp
    =(kp)^(ed-1)×(kp)-kp
    =kp×((kp)^(ed-1)-1)
    所以必然能被 p 整除
    
    
    (kp)^ed = t'pq + kp
    
    因为 m=kp，n=pq，所以
    所以 m^(ed)=t'n+m
    即 　m^(ed) ≡ m (mod n)
    得证