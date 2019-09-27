> 请注意，在此上下文中，extends 在一般意义上用于表示 "继承" (如在类中)或 "实现" (如在接口中)。

并且只能用 extends 不能用 implements

相同的语义在 proGuard 的混淆规则中也有，不过在混淆规则中两者都可以使用。
> The extends and implements specifications are typically used to restrict classes with wildcards. They are currently equivalent, specifying that only classes extending or implementing the given class (directly or indirectly) qualify. The given class itself is not included in this set. If required, it should be specified in a separate option.