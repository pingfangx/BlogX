只能为相同的类型，并且只需要一个类型符

示例

    @Test
    public void test() {
        for (int i = 0; i < 10; i++) {
        }
        for (char i = 0, j = 1; i < 10; i++) {
        }
        //错误,不能
        //for (int i = 0,int j=1; i < 10; i++) {
        //}
        //错误
        //for (int i = 0,char j=1; i < 10; i++) {
        //}
    }
