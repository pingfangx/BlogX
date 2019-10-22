如果使用 String，那么编译器只会在每层循环中新建 StringBuilder

所以需要自己手动再循环外创建 StringBuilder，而不要依赖于编译器的优化。
