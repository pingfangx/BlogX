学习持久化的时候

XMLEncoder 类被分配用于写入输出文件，用于 Serializable 对象的文本表示。以下代码片段是以 XML 格式编写 Java bean 及其属性的示例：

    XMLEncoder encoder = new XMLEncoder(
               new BufferedOutputStream(
               new FileOutputStream("Beanarchive.xml")));

    encoder.writeObject(object);
    encoder.close(); 
XMLDecoder 类读取使用 XMLEncoder 创建的 XML 文档：

    XMLDecoder decoder = new XMLDecoder(
        new BufferedInputStream(
        new FileInputStream("Beanarchive.xml")));

    Object object = decoder.readObject();
    decoder.close();

这一部分其实是解释了自己的疑惑，在使用 OmegaT 时，segmentation.conf 就是这样保存的。