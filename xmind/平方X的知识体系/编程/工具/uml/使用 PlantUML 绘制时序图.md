[Plant-UML 时序图](http://plantuml.com/zh/sequence-diagram)

# 摘录自己绘制时会使用的

## 简单示例

## 给自己发消息

## 修改箭头颜色
Bob -[#red]> Alice : hello
Alice -[#0000FF]->Bob : ok

## 对消息序列编号
    autonumber
    autonumber 15
    
## 给消息添加注释
    note left
    end note
## 分隔符

## 生命线的激活与撤销

## 创建参与者
    participant 

## 进入和发出消息

## Return

## 组合消息
    alt
    else
    end

# 绘制时注意

表示一个方法时，PackageName.Class.Method(Anotation ParamClass paramName)

简单表示为 Class.Method(Anotation ParamClass) 即可，如果参数名可以帮助理解，也可以加上参数名

