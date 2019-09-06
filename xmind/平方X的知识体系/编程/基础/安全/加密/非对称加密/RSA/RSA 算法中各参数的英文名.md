[RSA (cryptosystem)](https://en.wikipedia.org/wiki/RSA_(cryptosystem))

# Key generation
1. Choose two distinct prime numbers p and q.
2. Compute n = pq.
* n is used as the modulus for both the public and private keys. Its length, usually expressed in bits, is the key length.
3. Compute λ(n) = lcm(φ(p), φ(q)) = lcm(p − 1, q − 1), where λ is Carmichael's totient function. This value is kept private.
4. Choose an integer e such that 1 < e < λ(n) and gcd(e, λ(n)) = 1; i.e., e and λ(n) are coprime.
5. Determine d as d ≡ e−1 (mod λ(n)); i.e., d is the modular multiplicative inverse of e modulo λ(n).
* e is released as the public key exponent.
* d is kept as the private key exponent.

The public key consists of the modulus n and the public (or encryption) exponent e. The private key consists of the private (or decryption) exponent d, which must be kept secret. p, q, and λ(n) must also be kept secret because they can be used to calculate d.


# 结论
所以 (n,e) (n,d) 中  
* n 为 modulus (系数)
* e,d 为 exponent (指数)

为什么称为系数、指数，可能因为加解密过程为

    m^e ≡ c (mod n)
    
    c^d ≡ m (mod n)