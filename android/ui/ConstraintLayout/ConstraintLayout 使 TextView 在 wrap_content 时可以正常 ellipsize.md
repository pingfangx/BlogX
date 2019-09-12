# 需求
TextView1 TextView2  
tv1 固定，tv2 靠右展示，文字少时 wrap_content，文字多时省略

靠右只需要 app:layout_constraintHorizontal_bias="1" 即可，但是省略却有麻烦

## 使用 wrap_content
文字少时可以正常，文字多时约束无效，会覆盖左边的 tv1

## 使用 0dp
由于左右都有约束，即使文字少的时候，tv2 也会被拉伸

# 解决
[android - ConstraintLayout Chains and Text Ellipsis + Image on the Right - Stack Overflow](https://stackoverflow.com/questions/40410786/constraintlayout-chains-and-text-ellipsis-image-on-the-right)

* 最原始的就是套一层。
* 0dp + app:layout_constraintWidth_default="wrap"  
使得约束默认是 wrap 而不是 spread
* wrap_content + app:layout_constrainedWidth="true"  
使得 wrap_content 生效