tutorial/essential/io/fileOps.html

> The try-with-resources statement has the advantage that the compiler automatically generates the code to close the resource(s) when no longer required.

> try-with-resources 语句的优点是编译器会在不再需要时自动生成关闭资源的代码。

是自动生成的吗？
测试后发现，是的

    
    private void test2(FileReader fileReader) {
        try (BufferedReader br = new BufferedReader(fileReader)) {
            br.readLine();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    被自动编译为
    
    private void test2(FileReader fileReader) {
        try {
            BufferedReader br = new BufferedReader(fileReader);
            Throwable var3 = null;

            try {
                br.readLine();
            } catch (Throwable var13) {
                var3 = var13;
                throw var13;
            } finally {
                if (br != null) {
                    if (var3 != null) {
                        try {
                            br.close();
                        } catch (Throwable var12) {
                            var3.addSuppressed(var12);
                        }
                    } else {
                        br.close();
                    }
                }

            }
        } catch (IOException var15) {
            var15.printStackTrace();
        }

    }