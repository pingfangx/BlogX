[任务和返回栈  |  Android Developers](https://developer.android.google.cn/guide/components/tasks-and-back-stack.html)

[launchMode  |  Android Developers](https://developer.android.google.cn/guide/topics/manifest/activity-element.html#lmode)

# launchMode

launchMode|standard|singleTop|singleTask|singleInstance
-|-|-|-|-
简介|标准模式|如果在当前任务栈顶部，则不创建|单独的任务中|单独的任务中
|||默认会在相同的任务中，除非指定关联|
启动回调|新建|onNewIntent()|onNewIntent()|onNewIntent()
是否可以多次实例化|√|√|×|×
实例可以属于不同任务|√|√|×|×
一个任务可以有多个实例|√|√（只需要不在顶部）|×|×
startActivityForResult|新建|新建|新建|新建

# flag
launchMode|FLAG_ACTIVITY_NEW_TASK|FLAG_ACTIVITY_SINGLE_TOP|FLAG_ACTIVITY_CLEAR_TOP
-|-|-|-
简介|singleTask|singleTop|销毁任务顶部的所有 Activity
启动回调|onNewIntent()|onNewIntent()|新建或 onNewIntent()
|||standard 是新建，其他都是 onNewIntent()