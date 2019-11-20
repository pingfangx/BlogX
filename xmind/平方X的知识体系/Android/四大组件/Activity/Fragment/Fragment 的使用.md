[片段  |  Android Developers](https://developer.android.google.cn/guide/components/fragments)

* 可以在布局中创建
* 也可以用 FragmentManager 处理

示例

    val fragmentManager = supportFragmentManager
    val fragmentTransaction = fragmentManager.beginTransaction()

    val fragment = ExampleFragment()
    fragmentTransaction.add(R.id.fragment_container, fragment)
    fragmentTransaction.commit()