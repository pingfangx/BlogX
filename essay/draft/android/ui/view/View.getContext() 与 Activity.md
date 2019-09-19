# View.getContext() 与 Activity

    public static Activity getActivity(Context context) {
        while (context instanceof ContextWrapper) {
            if (context instanceof Activity) {
                return (Activity) context;
            }
            context = ((ContextWrapper) context).getBaseContext();
        }
        return null;
    }
    
但是要注意的是， view 不能使用 activity.getWindow().getDecorView() 获取  
因为 decorView 的 getContext() 返回的是 DecorContext，无法从 DecorContext 中获取 Activity