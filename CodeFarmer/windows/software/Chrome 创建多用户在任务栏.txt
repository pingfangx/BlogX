添加了多用户后，发现在任务栏会有混乱。  
打开主用户的图标，实际却是小号。  

根据[Google Chrome 浏览器创建多用户快捷方式](https://blog.csdn.net/pansing/article/details/37575039)  
# 创建主用户的用户图标。

    目标，修改--profile-directory
    "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --profile-directory="Default"
    图标，选择 Default
    %USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default\Google Profile.ico
    
# 锁定到任务栏
* 右击快捷方式，将主用户锁定到任务栏  
这个时候发现，两个用户的快捷方式，右击都显示“从任务栏脱离”
* 从任务栏的开 Chrome  
偶然发现的
* 在右击快捷方式
这个时候，两个快捷方式，都显示“锁定到任务栏”了。