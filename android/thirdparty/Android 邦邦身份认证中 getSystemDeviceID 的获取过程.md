Android 邦邦身份认证中 getSystemDeviceID 的获取过程

    public FIDOReInfo getSystemDeviceID(Activity var1) {
        FIDOReInfo var3;
        if ((var3 = this.getDeviceInfo(var1)).status != FidoStatus.SUCCESS) {
            return var3;
        } else {
            String var2 = k.a(var3.getDeviceInfo().toString());
            var3.setSystemDeviceId(var2);
            var3.setStatus(FidoStatus.SUCCESS);
            return var3;
        }
    }
    
    最后结果为 c9feb1375999e16342cb83dfa9728767
    
    其中 getDeviceInfo().toString() 返回
    {"osType":"android","deviceType":"Xiaomi","deviceName":"MI 5","deviceAliasName":"gemini","androidID":"46bd69e13bbc33cd","mac":""}
    
    k.a() 方法为 SHA265 加密取前 32 位
    加密结果为 c9feb1375999e16342cb83dfa9728767a2522e264e310c8d834e382c6a4328f8

可见 getSystemDeviceID 的唯一性由 androidID 确定  
和我们代码中当前使用的获取方法一致 a-46bd69e13bbc33cd  

但是我们的算法更严谨，我们先获取 imei，再获取 androidID ，判断是否有效，再获取 uuid

    邦邦的为
    
        String var4 = System.getString(var1.getContentResolver(), "android_id");
        var3.put("androidID", var4);
    
    我们的为
    
    /**
     * 获取有效的 Android id，如果无效则置空
     */
    private static String getValidAndroidIdOrEmpty(Context context) {
        String androidId = getAndroidId(context);
        if (!isValidAndroidId(androidId)) {
            //无效置为空
            androidId = "";
        }
        return androidId;
    }

    /**
     * 获取 Android id
     */
    @SuppressLint("HardwareIds")
    private static String getAndroidId(Context context) {
        String androidId = null;
        try {
            androidId = Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return androidId;
    }

    /**
     * 是否是效的 Android Id
     */
    private static boolean isValidAndroidId(String androidId) {
        if (isEmpty(androidId)) {
            return false;
        }
        List<String> invalidAndroidIdList = new ArrayList<>();
        invalidAndroidIdList.add("9774d56d682e549c");
        invalidAndroidIdList.add("0123456789abcdef");
        return !invalidAndroidIdList.contains(androidId.toLowerCase());
    }
