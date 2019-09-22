TODO 查看是否与机器相关
int 在 32 与 64 位电脑是否不同
> This data type represents one bit of information, but its "size" isn't something that's precisely defined.

https://stackoverflow.com/questions/1907318

需要再学习

> Short answer: yes, boolean values are manipulated as 32-bit entities, but arrays of booleans use 1 byte per element.

> Longer answer: the JVM uses a 32-bit stack cell, used to hold local variables, method arguments, and expression values. Primitives that are smaller than 1 cell are padded out, primitives larger than 32 bits (long and double) take 2 cells. This technique minimizes the number of opcodes, but does have some peculiar side-effects (such as the need to mask bytes).

> Primitives stored in arrays may use less than 32 bits, and there are different opcodes to load and store primitive values from an array. Boolean and byte values both use the baload and bastore opcodes, which implies that boolean arrays take 1 byte per element.

> As far as in-memory object layout goes, this is covered under the "private implementation" rules, it can be 1 bit, 1 byte, or as another poster noted, aligned to a 64-bit double-word boundary. Most likely, it takes the basic word size of the underlying hardware (32 or 64 bits).

> As far as minimizing the amount of space that booleans use: it really isn't an issue for most applications. Stack frames (holding local variables and method arguments) aren't very large, and in the big scheme a discrete boolean in an object isn't that large either. If you have lots of objects with lots of booleans, then you can use bit-fields that are managed via your getters and setters. However, you'll pay a penalty in CPU time that is probably bigger than the penalty in memory.