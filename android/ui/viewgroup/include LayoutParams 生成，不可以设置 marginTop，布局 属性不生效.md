include LayoutParams 生成，不可以设置 marginTop，布局 属性不生效


android.view.LayoutInflater#parseInclude

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