> 当然，如果考虑到编程风格方面的原因，完全可以在 default 语句的末尾放置一个 break，尽管它并没有任何实际的用处。

这里涉及到一个问题，其实 default 语句并不必须放在最后。


    @Test
    public void test() {
        int i = (int) (Math.random() * 10);
        switch (i) {
            default:
                System.out.println(i);//可能输出 31
            case 1:
                System.out.println("1");
                break;
            case 2:
                System.out.println("2");
                break;
        }
    }
    
    如果 default 没有 break，执行 default 之后依然后执行 case 1
    因此建议 default 也要加 break