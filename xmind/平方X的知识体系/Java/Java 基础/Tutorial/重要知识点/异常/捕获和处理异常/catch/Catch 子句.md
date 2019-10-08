Code

    public class CatchClauseTest {
        /**
         * Idea 可以识别 ignore 和 ignored
         * 推荐为 ignored
         */
        public void test_ignoredParamName() {
            try {
                int i = 0;
            } catch (NullPointerException e) {
                e = new NullPointerException(e.getLocalizedMessage());
            }
        }

        /**
         * 注意:如果 catch 块处理多个异常类型，则 catch 参数隐式 final。在此示例中，catch 参数 ex 是 final，因此你无法在 catch 块中为其指定任何值。
         */
        public void test_catchMultiException() {
            try {
                FileInputStream fileInputStream = new FileInputStream("");
            } catch (FileNotFoundException | SecurityException e) {
                //Cannot assign a value to final variable 'e'
                //e = new FileNotFoundException(e.getLocalizedMessage());
            }
        }
    }

