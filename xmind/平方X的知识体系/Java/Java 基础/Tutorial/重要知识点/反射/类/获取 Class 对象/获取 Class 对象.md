Tutorial 总结了获取 Class 对象的 5 类方法

这里 Class 表明是 Class 类型的对象，因此不翻译为类。

1. Object.getClass()  
能访问实例就可以调用此方法

0. .class 语法  
如果类型可用而实例不可用  
比如获取基本类型的 Class

0. Class.forName()  
使用字符串表示的类完全限定名称

0. 基本类型包装器的 TYPE 字段

0. 反射 API 中返回 Class 的方法

示例代码

    package com.pingfangx.study.tutorial.reflect.class_object;

    import org.junit.Assert;
    import org.junit.Test;

    import java.io.Serializable;
    import java.util.HashSet;
    import java.util.List;
    import java.util.Set;

    /**
     * @author pingfangx
     * @date 2019/5/30
     */
    public class ClassObjectTest {

        /**
         * 方法 1
         */
        @Test
        public void test_getClass() {
            assertClass("String", "foo".getClass());
            assertClass("PrintStream", System.out.getClass());
            //枚举类
            assertClass("ClassObjectTest$E", E.A.getClass());
            byte[] bytes = new byte[1024];
            //数组用 [ 表示
            assertClass("[B", bytes.getClass());
            Set<String> set = new HashSet<>();
            //返回的是具体对象类
            assertClass("HashSet", set.getClass());
            Object o = new HashSet<String>();
            assertClass("HashSet", o.getClass());
        }

        /**
         * 方法 2
         */
        @Test
        public void test_dot_class() {
            assertClass("byte", byte.class);
            assertClass("short", short.class);
            assertClass("int", int.class);
            assertClass("long", long.class);
            assertClass("float", float.class);
            assertClass("double", double.class);
            assertClass("boolean", boolean.class);
            assertClass("char", char.class);

            //数组
            assertClass("[B", byte[].class);
            assertClass("[S", short[].class);
            assertClass("[I", int[].class);
            assertClass("[J", long[].class);
            assertClass("[F", float[].class);
            assertClass("[D", double[].class);
            assertClass("[Z", boolean[].class);
            assertClass("[C", char[].class);

            //多维数组
            assertClass("[[[I", int[][][].class);
            //对象数组，注意 L 和 ;
            assertClass("[Ljava.util.List;", List[].class);
            //接口
            assertClass("Serializable", Serializable.class);

            // void 不是基本类型，主要用反射中作为方法的返回类型
            assertClass("void", void.class);
        }

        /**
         * 方法 3
         */
        @Test
        public void test_forName() throws ClassNotFoundException {
            //注意没有 L 和 ; 返回的类 getName() 也是 java.lang.String，只是由 assertClass 判断时处理了
            assertClass("String", Class.forName("java.lang.String"));
            assertClass("[[Ljava.lang.String;", Class.forName("[[Ljava.lang.String;"));
        }

        /**
         * 方法 4
         */
        @Test
        public void test_wrapper_TYPE() {
            //public static final Class<Byte>     TYPE = (Class<Byte>) Class.getPrimitiveClass("byte");
            //搜索 java.lang.Class.getPrimitiveClass 有且仅有此 8+1 处用法
            assertClass("byte", Byte.TYPE);
            assertClass("short", Short.TYPE);
            assertClass("int", Integer.TYPE);
            assertClass("long", Long.TYPE);
            assertClass("float", Float.TYPE);
            assertClass("double", Double.TYPE);
            assertClass("boolean", Boolean.TYPE);
            assertClass("char", Character.TYPE);

            assertClass("void", Void.TYPE);
        }


        /**
         * 方法 5
         */
        @Test
        public void test_returnClassMethod() {
            System.out.println("\n Class.getSuperclass()");
            assertClass("Object", String.class.getSuperclass());
            //Object类、接口、void、基本类型的超类为 null
            assertClass(null, Object.class.getSuperclass());
            assertClass(null, Serializable.class.getSuperclass());
            assertClass(null, void.class.getSuperclass());
            assertClass(null, int.class.getSuperclass());

            System.out.println("\n Class.getClasses()");
            printClass(Character.class.getClasses());

            //This includes public class and interface members inherited from superclasses and public class and interface members declared by the class.
            System.out.println();
            System.out.println("A.class.getClasses()");
            printClass(A.class.getClasses());
            System.out.println("B.class.getClasses()");
            printClass(B.class.getClasses());


            //This includes public, protected, default (package) access, and private classes and interfaces declared by the class, but excludes inherited classes and interfaces.
            System.out.println();
            System.out.println("getDeclaredClasses()");
            printClass(Character.class.getDeclaredClasses());
            System.out.println("A.class.getDeclaredClasses()");
            printClass(A.class.getDeclaredClasses());
            System.out.println("B.class.getDeclaredClasses()");
            printClass(B.class.getDeclaredClasses());
        }

        private void assertClass(String className, Class clazz) {
            if (clazz == null) {
                Assert.assertNull(className);
                return;
            }
            System.out.printf("class:%s, simpleName:%s %n", clazz, clazz.getSimpleName());
            String name = clazz.getName();
            if (!name.startsWith("[")) {
                int lastIndex = name.lastIndexOf('.');
                if (lastIndex >= 0) {
                    name = name.substring(lastIndex + 1);
                }
            }
            Assert.assertEquals(className, name);
        }

        enum E {A, B}

        private class A {
            public class APublic {
            }

            private class AInner {
            }
        }

        private class B extends A {
            public class BPublic {
            }

            private class BInner {
            }
        }

        static class StaticNestedClass {
        }

        class InnerClass {
            private void test() {
                class LocalClass {
                }
                Object anonymousObject = new Object() {
                    public void m() {
                    }
                };
            }
        }

        /**
         * <pre>
         *     根据 嵌套类 一节，分为
         *     类
         *          嵌套类
         *              静态嵌套类
         *              内部类
         *                 局部类
         *                 匿名类
         * </pre>
         */
        @Test
        public void testNestedClass() {
            printNestedClass(StaticNestedClass.class);
            printNestedClass(InnerClass.class);
            //局部类，没有声明类
            class LocalClass {
            }
            printNestedClass(LocalClass.class);
            //匿名类，没有名字和声明类
            Object o = new Object() {
            };
            printNestedClass(o.getClass());
        }

        private void printNestedClass(Class clazz) {
            System.out.println();
            System.out.println("getSimpleName()");
            System.out.println(clazz.getSimpleName());
            System.out.println("toString()");
            printClass(clazz);
            System.out.println("getDeclaringClass()");
            printClass(clazz.getDeclaringClass());
            System.out.println("getEnclosingClass()");
            printClass(clazz.getEnclosingClass());
        }

        private void printClass(Class[] classes) {
            for (Class clazz : classes) {
                printClass(clazz);
            }
        }

        private void printClass(Class clazz) {
            System.out.println(clazz);
        }
    }
