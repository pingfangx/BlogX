
符号|名称|译名|原文
-|-|-|-
!|Logical complement|逻辑非|Logical complement operator; inverts the value of a boolean
&&|Conditional-AND|条件与|The && and \|\| operators perform Conditional-AND and Conditional-OR operations on two boolean expressions.
\|\||Conditional-OR|条件或|These operators exhibit "short-circuiting" behavior, which means that the second operand is evaluated only if needed.
~|Unary bitwise complement|反码|The unary bitwise complement operator "~" inverts a bit pattern;
&|Bitwise AND|按位与|The bitwise & operator performs a bitwise AND operation.
^|Bitwise exclusive OR|按位异或|The bitwise ^ operator performs a bitwise exclusive OR operation.
\||Bitwise inclusive OR|按位或|The bitwise \| operator performs a bitwise inclusive OR operation.
|||

# complement
补充的意思，根据具体情况翻译为补码、反码

# ~
名称为 Unary bitwise complement  
根据之前的学习，我们知道

反码（one's complement）

补码（two's complement）

因此这里的一元按位反码，就翻译成反码

# !
Logical complement  
逻辑反码，翻译为逻辑非

# ^ 和 |
bitwise exclusive OR

bitwise inclusive OR

为什么命名为 exclusive 和 inclusive

[xml - What is the difference between Inclusive and Exclusive OR? - Stack Overflow](https://stackoverflow.com/questions/3246249/what-is-the-difference-between-inclusive-and-exclusive-or)

https://stackoverflow.com/a/3246264
> Inclusive or: A or B or both.  
> Exclusive or: Either A or B but not both.

https://stackoverflow.com/a/26059311
> Considering the value for the statement "A OR B":

> Inclusive OR allows both possibilities as well as either of them. So, if either A or B is True, or if both are True, then the statement value is True.

> Whereas Exclusive OR only allows one possibility. So if either A or B is true, then and only then is the value True. If both A and B are True, even then the statement's value will be False.

> Example for Exclusive OR: At a restaurant, you are offered a coupon which entitles you to eat either a Sandwich OR a Burger. This is an exclusive OR statement in English language. You can choose either one of them, but not both.


考虑 inclusive 的包含的意思，表示包含两者
> from A to B (inclusive)

考虑 exclusive 的互斥的意思，表示只能选一个
> choose A or B (exclusive)