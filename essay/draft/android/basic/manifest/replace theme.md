模块中为 Activity 指定 android:theme  
如果主模块中想要修改 theme，可以再次指定 Activity，声明主题，但是此时会报合并出错

    Manifest merger failed : Attribute activity#...TestActivity@theme value=(@style/Theme.AppCompat.NoActionBar) from AndroidManifest.xml:23:13-63
        is also present at [:mylibrary] AndroidManifest.xml:15:13-57 value=(@style/Theme.AppCompat.Light).
        Suggestion: add 'tools:replace="android:theme"' to <activity> element at AndroidManifest.xml:21:9-24:20 to override.

于是在主模块的 manifest 中添加 `tools:replace="android:theme"`

如果在子模块中添加，则会提示

    @android:theme was tagged at AndroidManifest.xml:13 to replace other declarations but no other declaration present
