测试代码

    /**
     * try
     * catch
     * finally
     * 结果是 finally
     * <p>
     * 警告
     * 'finally' block can not complete normally
     * 'return' inside 'finally' block
     */
    private String returnInClause2() {
        try {
            System.out.println("try");
            int i = 1 / 0;
            return "try";
        } catch (Exception e) {
            System.out.println("catch");
            return "catch";
        } finally {
            System.out.println("finally");
            return "finally";
        }
    }

try catch 中的代码可以正常执行，但是只会 return finally 中的结果