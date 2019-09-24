# 隐私权限变更
## 分区存储变更
临时采用 requestLegacyExternalStorage

后期适配时需要完全改用 MediaStore，需要修改选择图片、拍照、加载（Glide 已做处理，但是要注意不要再添加 file:///）、上传等。

## 后台 Activity 的启动

## 获以设备信息
相关信息包括 IMEI、IMSI、序列号等，项目中获取 IMSI 的方法需要 try catch

https://developer.android.com/about/versions/10/privacy/changes#non-resettable-device-ids


# API 变更
## android.util.SparseArray#setValueAt
之前项目中使用不当，需要修改

/**
 * Given an index in the range <code>0...size()-1</code>, sets a new
 * value for the <code>index</code>th key-value mapping that this
 * SparseArray stores.
 *
 * <p>For indices outside of the range <code>0...size()-1</code>, the behavior is undefined for
 * apps targeting {@link android.os.Build.VERSION_CODES#P} and earlier, and an
 * {@link ArrayIndexOutOfBoundsException} is thrown for apps targeting
 * {@link android.os.Build.VERSION_CODES#Q} and later.</p>
 */
 
## String path = cursor.getString(1);
使用不当，修改为

    String path = cursor.getString(cursor.getColumnIndex(MediaStore.Images.Media.DATA));