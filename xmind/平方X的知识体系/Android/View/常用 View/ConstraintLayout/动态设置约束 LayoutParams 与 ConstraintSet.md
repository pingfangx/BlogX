# 示例
                    val constraintSet = ConstraintSet()
                    constraintSet.clone(constraintLayout)
                    if (layoutParams.rightToRight == ConstraintLayout.LayoutParams.PARENT_ID) {
                        constraintSet.connect(v.id, ConstraintSet.RIGHT, ConstraintSet.UNSET, ConstraintSet.RIGHT)
                    } else {
                        constraintSet.connect(v.id, ConstraintSet.RIGHT, ConstraintSet.PARENT_ID, ConstraintSet.RIGHT)
                    }
                    constraintSet.applyTo(constraintLayout)
applyTo 方法，也是遍历 child，如果约束中存在，则调用 public void applyTo(ConstraintLayout.LayoutParams param)

实际就是将约束复制到 LayoutParams 上。