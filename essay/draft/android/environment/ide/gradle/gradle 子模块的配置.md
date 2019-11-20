要将子模块组织到文件夹中。


[Settings - Gradle DSL Version 5.4.1](https://docs.gradle.org/5.4.1/dsl/org.gradle.api.initialization.Settings.html#org.gradle.api.initialization.Settings:include)

    // include two projects, 'foo' and 'foo:bar'
    // directories are inferred by replacing ':' with '/'
    include 'foo:bar'

    // include one project whose project dir does not match the logical project path
    include 'baz'
    project(':baz').projectDir = file('foo/baz')

    // include many projects whose project dirs do not match the logical project paths
    file('subprojects').eachDir { dir ->
      include dir.name
      project(":${dir.name}").projectDir = dir
    }
    
# 直接 include ':foo:bar'
这个应该和 'foo:bar' 一样吧，会导致 foo 也被认为是模块，于是导入

# 导入后再指定目录
include 'baz'
project(':baz').projectDir = file('foo/baz')

# 导入目录中的所有项目
    file('subprojects').eachDir { dir ->
      include dir.name
      project(":${dir.name}").projectDir = dir
    }
    
# 导入多个目录
    ['foo', 'bar'].each { dir ->
        file(dir).eachDir { subDir ->
            def name = subDir.name
            include name
            project(":$name").projectDir = subDir
        }
    }