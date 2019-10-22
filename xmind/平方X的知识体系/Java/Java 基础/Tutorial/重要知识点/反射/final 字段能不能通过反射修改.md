[Change private static final field using Java reflection - Stack Overflow](https://stackoverflow.com/questions/3301635/change-private-static-final-field-using-java-reflection)

部分博客提供了方法，但是实际测试时还是不能修改。
测试代码如下

    public class FinalFieldTest {
        class A {
            private final int type = 1;
        }

        @Test
        public void test() {
            A a = new A();
            Assert.assertEquals(1, a.type);
            Class<A> clazz = A.class;
            try {
                Field field = clazz.getDeclaredField("type");
                Assert.assertFalse(field.isAccessible());
                field.setAccessible(true);
                Assert.assertTrue(field.isAccessible());
                field.setInt(a, 2);
                //修改失败，不相等
                Assert.assertNotEquals(2, a.type);

                Field modifiersField = Field.class.getDeclaredField("modifiers");
                Assert.assertFalse(modifiersField.isAccessible());
                modifiersField.setAccessible(true);
                Assert.assertTrue(modifiersField.isAccessible());
                Assert.assertTrue(Modifier.isFinal(field.getModifiers()));
                modifiersField.setInt(field, field.getModifiers() & ~Modifier.FINAL);
                Assert.assertFalse(Modifier.isFinal(field.getModifiers()));
                field.setInt(a, 2);
                //还是失败
                Assert.assertEquals(2, a.type);
            } catch (NoSuchFieldException | IllegalAccessException e) {
                e.printStackTrace();
            }
        }
    }
    
后来在 stackoverflow 中看到了解释，修改如下，成功
    
    class A {
        private final int type;

        A() {
            type = 1;
        }
    }

# Thinking in Java 中也有介绍
> However, final fields are actually safe from change. The runtime system accepts any attempts at change without complaint, but nothing actually happens.  

