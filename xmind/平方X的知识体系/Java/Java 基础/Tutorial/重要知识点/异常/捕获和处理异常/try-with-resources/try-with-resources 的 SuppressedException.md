在 Tutorial 中有这样的描述
> 但是，在此示例中，如果方法 readLine 和 close 都抛出异常，则方法 readFirstLineFromFileWithFinallyBlock 将从 finally 块抛出异常;从 try 块抛出的异常被抑制。相反，在示例 readFirstLineFromFile 中，如果从 try 块和 try-with-resources 语句抛出异常，则该方法 readFirstLineFromFile 抛出 try 块引发的异常;从 try-with-resources 块抛出的异常被抑制。在 Java SE 7 及更高版本中，你可以获取抑制的异常;有关详细信息，请参阅 Suppressed Exceptions 部分。

> 可以从与 try-with-resources 语句关联的代码块中抛出异常。在示例 writeToFileZipFileContents 中，可以从 try 块中抛出异常，并且可以从 try-with-resources 语句中抛出最多两个异常 - 当它尝试关闭 ZipFile 和 BufferedWriter 对象时。如果从 try 块抛出异常并且从 try-with-resources 语句抛出一个或多个异常，那么从 try-with-resources 语句抛出的异常被抑制，块抛出的异常是 writeToFileZipFileContents 方法抛出的异常。你可以通过从 try 块抛出的异常中调用 Throwable.getSuppressed 方法来获取这些抑制的异常。

在以下示例中，直接抛出了 FileNotFoundException
    
    private void suppressedException() throws Exception {
        try (BufferedReader br = new BufferedReader(new FileReader(""))) {
            System.out.println(br.readLine());
            int i = 1 / 0;
        }
    }
    
结合上下文的“如果方法 readLine 和 close 都抛出异常”、“并且可以从 try-with-resources 语句中抛出最多两个异常 - 当它尝试关闭 ZipFile 和 BufferedWriter 对象时。”

可以更解为所述的抑制，是指执行 close 时抛出异常，而不是在声明资源抛出的异常。

声明资源时抛出的异常仍然会在 try 块执行前抛出

# 测试代码

    class TestResource implements AutoCloseable {
        private boolean isOpen;

        public void open() {
            isOpen = true;
        }

        @Override
        public void close() throws IllegalStateException {
            System.out.println("close,isOpen=" + isOpen);
            if (isOpen) {
                isOpen = false;
            } else {
                throw new IllegalStateException("文件已关闭");
            }
        }
    }

    /**
     * close in try
     * close,isOpen=true
     * try finish
     * close,isOpen=false
     * 拦截到异常:文件已关闭
     * finally
     */
    private void suppressedException2() {
        try (TestResource resource = new TestResource()) {
            resource.open();
            System.out.println("close in try");
            resource.close();
            System.out.println("try finish");
        } catch (IllegalStateException e) {
            System.out.println("拦截到异常:" + e.getLocalizedMessage());
        } finally {
            //错误，引用不到 resource
            //resource.close();
            System.out.println("finally");
        }
    }

    /**
     * close in try
     * close,isOpen=true
     * try finish
     * close,isOpen=false
     * finally
     * 外部拦截到异常:/ by zero
     * 抑制的异常:[java.lang.IllegalStateException: 文件已关闭]
     */
    private void suppressedException3() {
        try (TestResource resource = new TestResource()) {
            resource.open();
            System.out.println("close in try");
            resource.close();
            System.out.println("try finish");
            int i = 1 / 0;
        } catch (IllegalStateException e) {
            System.out.println("拦截到异常:" + e.getLocalizedMessage());
        } finally {
            //错误，引用不到 resource
            //resource.close();
            System.out.println("finally");
        }
    }

    /**
     * 测试抑制的异常
     */
    @Test
    public void test_suppressedException2() {
        try {
            suppressedException3();
        } catch (Exception e) {
            System.out.println("外部拦截到异常:" + e.getLocalizedMessage());
            System.out.println("抑制的异常:" + Arrays.toString(e.getSuppressed()));
        }
    }