include LayoutParams 生成，不可以设置 marginTop，布局 属性不生效


android.view.LayoutInflater#parseInclude

                        // We try to load the layout params set in the <include /> tag.
                        // If the parent can't generate layout params (ex. missing width
                        // or height for the framework ViewGroups, though this is not
                        // necessarily true of all ViewGroups) then we expect it to throw
                        // a runtime exception.
                        // We catch this exception and set localParams accordingly: true
                        // means we successfully loaded layout params from the <include>
                        // tag, false means we need to rely on the included layout params.
                        ViewGroup.LayoutParams params = null;
                        try {
                            params = group.generateLayoutParams(attrs);
                        } catch (RuntimeException e) {
                            // Ignore, just fail over to child attrs.
                        }
                        if (params == null) {
                            params = group.generateLayoutParams(childAttrs);
                        }
                        view.setLayoutParams(params);
    
    
如果不设置宽高，会抛出

    java.lang.UnsupportedOperationException: Binary XML file line #21: You must supply a layout_width attribute.

因此在 include 标签下，不设置宽高无法设置 marginTop 等属性。  
但是设置以后，就不会再使用 childAttrs 生成 params 因此，include 所指向的布局设置的属性失败。


# 使用 include 时 app:layout_behavior 失效
可能也是因为 include 为了设置 marginTop 而设置了宽高