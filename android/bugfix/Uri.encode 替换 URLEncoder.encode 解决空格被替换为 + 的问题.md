[URLEncoder not able to translate space character](https://stackoverflow.com/questions/4737841)

# java.net.URLEncoder#encode(java.lang.String, java.lang.String)
    
        ...
        for (int i = 0; i < s.length();) {
            int c = (int) s.charAt(i);
            //System.out.println("Examining character: " + c);
            if (dontNeedEncoding.get(c)) {
                if (c == ' ') {
                    c = '+';
                    needToChange = true;
                }
                //System.out.println("Storing: " + c);
                out.append((char)c);
                i++;
            }
            ...
        同时有
        dontNeedEncoding.set(' '); /* encoding a space to a + is done
                                    * in the encode() method */
                                    
因此只需要将 *转换后* 的 + 替换为 %20 即可。  
如果原始内容中有 + 是会被替换为 %2B 的。

# android.net.Uri#encode(java.lang.String, java.lang.String)
[Chrispix 的回答](https://stackoverflow.com/a/46164889)

    Uri.encode(js, " ") 即可
    