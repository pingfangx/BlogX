启用 shrink 之后，报错

    java.lang.NullPointerException: Attempt to invoke virtual method 'void org.jbox2d.dynamics.contacts.Contact.init(org.jbox2d.dynamics.Fixture, org.jbox2d.dynamics.Fixture)' on a null object reference

考虑到是方法被删除的问题，是哪个方法呢

[Bubble-Picker issues](https://github.com/igalata/Bubble-Picker/issues/18#issuecomment-419866774)

>Just add, in your proguard file:  
>-keep class com.igalata.bubblepicker{ * ;}  
>-keep class org.jbox2d.**{ * ;}  


太宽泛了，自己查看一下。


    org.jbox2d.dynamics.World#popContact

    public Contact popContact(Fixture fixtureA, Fixture fixtureB) {
        ShapeType type1 = fixtureA.getType();
        ShapeType type2 = fixtureB.getType();
        ContactRegister reg = this.contactStacks[type1.intValue][type2.intValue];
        IDynamicStack<Contact> creator = reg.creator;
        if (creator != null) {
            Contact c;
            if (reg.primary) {
                c = (Contact)creator.pop();
                c.init(fixtureA, fixtureB);
                return c;
            } else {
                c = (Contact)creator.pop();
                c.init(fixtureB, fixtureA);
                return c;
            }
        } else {
            return null;
        }
    }
    pop() 出来的为空
    
    看 contactStacks 是如何赋值的
    org.jbox2d.dynamics.World#World(org.jbox2d.common.Vec2, boolean, org.jbox2d.pooling.IWorldPool)
    org.jbox2d.dynamics.World#initializeRegisters
        this.addType(this.pool.getCircleContactStack(), ShapeType.CIRCLE, ShapeType.CIRCLE);
    org.jbox2d.dynamics.World#addType
    
    看 getCircleContactStack 的实现
    org.jbox2d.pooling.normal.DefaultWorldPool#getCircleContactStack
    
    public final IDynamicStack<Contact> getCircleContactStack() {
        return this.ccstack;
    }
    
    org.jbox2d.pooling.normal.DefaultWorldPool#DefaultWorldPool
        this.ccstack = new MutableStack(CircleContact.class, 10, this.classes, this.args);
        
    org.jbox2d.pooling.normal.MutableStack#MutableStack(java.lang.Class<T>, int, java.lang.Class<?>[], java.lang.Object[])
    org.jbox2d.pooling.normal.MutableStack#extendStack
    
    private void extendStack(int argSize) {
        T[] newStack = (Object[])((Object[])Array.newInstance(this.sClass, argSize));
        if (this.stack != null) {
            System.arraycopy(this.stack, 0, newStack, 0, this.size);
        }

        for(int i = 0; i < newStack.length; ++i) {
            try {
                if (this.params != null) {
                    newStack[i] = this.sClass.getConstructor(this.params).newInstance(this.args);
                } else {
                    newStack[i] = this.sClass.newInstance();
                }
            } catch (InstantiationException var5) {
                log.error("Error creating pooled object " + this.sClass.getSimpleName(), var5);

                assert false : "Error creating pooled object " + this.sClass.getCanonicalName();
            } catch (IllegalAccessException var6) {
                log.error("Error creating pooled object " + this.sClass.getSimpleName(), var6);

                assert false : "Error creating pooled object " + this.sClass.getCanonicalName();
            } catch (IllegalArgumentException var7) {
                log.error("Error creating pooled object " + this.sClass.getSimpleName(), var7);

                assert false : "Error creating pooled object " + this.sClass.getCanonicalName();
            } catch (SecurityException var8) {
                log.error("Error creating pooled object " + this.sClass.getSimpleName(), var8);

                assert false : "Error creating pooled object " + this.sClass.getCanonicalName();
            } catch (InvocationTargetException var9) {
                log.error("Error creating pooled object " + this.sClass.getSimpleName(), var9);

                assert false : "Error creating pooled object " + this.sClass.getCanonicalName();
            } catch (NoSuchMethodException var10) {
                log.error("Error creating pooled object " + this.sClass.getSimpleName(), var10);

                assert false : "Error creating pooled object " + this.sClass.getCanonicalName();
            }
        }

        this.stack = newStack;
        this.size = newStack.length;
    }
    
    
    class org.jbox2d.dynamics.contacts.CircleContact
    可以看到是反射使用的构造函数，于是添加混淆规则
    
    -keepclassmembers class * extends org.jbox2d.dynamics.contacts.Contact{
        public <init>(...);
    }
    