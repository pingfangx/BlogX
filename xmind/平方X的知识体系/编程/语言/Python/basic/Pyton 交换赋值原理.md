[Python连续赋值的内部原理](https://imliyan.com/blogs/article/Python%E8%BF%9E%E7%BB%AD%E8%B5%8B%E5%80%BC%E7%9A%84%E5%86%85%E9%83%A8%E5%8E%9F%E7%90%86/)

[dis — Disassembler for Python bytecode](https://docs.python.org/3/library/dis.html)

[python两个数值互换（浅析a,b=b,a原理）](https://blog.csdn.net/qq_33414271/article/details/78522235)

    TARGET(ROT_TWO) {           
        PyObject *top = TOP();          
        PyObject *second = SECOND();       
        SET_TOP(second);          
        SET_SECOND(top);         
        FAST_DISPATCH();       
    }        
    TARGET(ROT_THREE) {            
        PyObject *top = TOP();            
        PyObject *third = THIRD();            
        SET_SECOND(third);            
        FAST_DISPATCH();        
    }
