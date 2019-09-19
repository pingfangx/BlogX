I got the same issue.
## The solution
Add the rule to your proguard rules file.

    -keepclassmembers class * extends org.jbox2d.dynamics.contacts.Contact{
        public <init>(...);
    }

It will keep constructors of any class wich extends org.jbox2d.dynamics.contacts.Contact.

## The reason
When use ProGuard
> The shrinking step detects and removes unused classes, fields, methods and attributes.

It will remove the constructor of org.jbox2d.dynamics.contacts.CircleContact.  
You can see it in usage.txt like

    org.jbox2d.dynamics.contacts.CircleContact:
        41:42:public CircleContact(org.jbox2d.pooling.IWorldPool)

## More details
The exception is thrown from 

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
    
    The c is null, the assignment of contactStacks:
    
    org.jbox2d.dynamics.World#World(org.jbox2d.common.Vec2, boolean, org.jbox2d.pooling.IWorldPool)
    org.jbox2d.dynamics.World#initializeRegisters
        this.addType(this.pool.getCircleContactStack(), ShapeType.CIRCLE, ShapeType.CIRCLE);
    org.jbox2d.dynamics.World#addType
        this.contactStacks[type1.intValue][type2.intValue] = register;
    
    
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
    
    In method extendStack,because constructor has removed by ProGuard, getConstructor will throw NoSuchMethodException.  
    Finally in method popContact,c will be null.