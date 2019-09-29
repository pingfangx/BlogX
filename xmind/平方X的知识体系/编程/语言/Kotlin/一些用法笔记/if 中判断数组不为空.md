过程

        写为
        if (typeParameters != null && typeParameters.size > 0) {
        }
        会提示使用 isNotEmpty() 替换
    
        改为
        if (typeParameters?.isNotEmpty()) {
        }
        会报错类型不匹配
        Type mismatch. 
        Required:
        Boolean
        Found:
        Boolean?
        Type mismatch. 
        Required:
        Boolean
        Found:
        Boolean?
    
        改为
        
        if (typeParameters?.isNotEmpty()==true) {
        }