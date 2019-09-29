赋值不是表达式（是赋值语句），只允许表达式

    var line: String?
    while ((line = input.readLine()) != null) {
    }
    
    应该改为
    
    var line: String? = input.readLine()
    while (line != null) {
        line = input.readLine()
    }