The catch clause specifies the types of exceptions that the block can handle, and each exception type is separated with a vertical bar (|).

Note: If a catch block handles more than one exception type, then the catch parameter is implicitly final. In this example, the catch parameter ex is final and therefore you cannot assign any values to it within the catch block.

Bytecode generated by compiling a catch block that handles multiple exception types will be smaller (and thus superior) than compiling many catch blocks that handle only one exception type each. A catch block that handles multiple exception types creates no duplication in the bytecode generated by the compiler; the bytecode has no replication of exception handlers.

TODO 为什么必须是 final 呢？