提到不会报错的一种情况

    @Test
    public void test() {
        int i, j = 0;
        boolean a, b = true;
        //Incompatible types.
        //Required:
        //boolean
        //Found:
        //int
        //if (i = j) {
        //    System.out.println("i=j");
        //}
        if (a = b) {
            System.out.println("a=b");
        }
    }
