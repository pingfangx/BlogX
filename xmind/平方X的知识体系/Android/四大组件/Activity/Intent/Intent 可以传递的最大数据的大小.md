[Activity间通过Intent传递数据的大小限制。 - pingfangx的博客 - CSDN博客](https://blog.csdn.net/pingfangx/article/details/52093225)

再次测试，还是一样的结论，最大 508 k
```
/**
 * 测试 Intent 可以传递的最大值
 *
 * 递增
 * 尝试传递 508 k 的数据
 * system_process W/ActivityManager: Exception thrown sending new intent to ActivityRecord{6742d35 u0 com.pingfangx.demo.androidx/.activity.android.content.IntentMaxSizeTestActivity t60}
 * android.os.TransactionTooLargeException: data parcel size 520804 bytes
 *
 * 递减
 * 尝试传递 1016 k 的数据
 * java.lang.RuntimeException: Failure from system
 *  Caused by: android.os.TransactionTooLargeException: data parcel size 1040896 bytes
 *
 * @author pingfangx
 * @date 2019/10/28
 */
class IntentMaxSizeTestActivity : BaseTipsActivity() {
    companion object {
        /**
         * 增加模式从 0 开始，看能增大到多少
         * 减小时从 1024 开始，看能减小到多少
         */
        var INCREASE_MODE = true
        const val INTENT_EXTRA_CONTENT = "content"
    }

    private val k: StringBuilder by lazy {
        val sb = StringBuilder()
        for (i in 0 until 1024 / 2) {
            sb.append('a')
        }
        sb
    }
    private val content: StringBuilder by lazy {
        val sb = StringBuilder()
        if (INCREASE_MODE) {
            for (i in 0..1024) {//多添加 1 k 首次减为 1024
                sb.append(k)
            }
        }
        sb
    }

    @SuppressLint("SetTextI18n")
    override fun initViews() {
        super.initViews()
        tv_tips.text = "开始${if (INCREASE_MODE) "从 1024 递减" else "从 0 递增"}测试"
        tv_tips.setOnClickListener { startActivityTest() }
    }

    private fun startActivityTest() {
        System.gc()
        if (INCREASE_MODE) {
            content.delete(content.length - k.length, content.length)
        } else {
            content.append(k)
        }
        setTextAndLog("尝试传递 ${content.length * 2 / 1024} k 的数据")
        val intent = Intent(this, this::class.java)
                .putExtra(INTENT_EXTRA_CONTENT, content.toString())
                .addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
        try {
            startActivity(intent)
        } catch (e: Exception) {
            e.printStackTrace()
            setTextAndLog("${tv_tips.text} \n启动异常\n $e")
            startActivityTest()//继续递减
        }
    }

    private fun setTextAndLog(text: String) {
        tv_tips.text = text
        text.xxlog()
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        val content = intent.getStringExtra(INTENT_EXTRA_CONTENT)
        setTextAndLog("传递数据成功 ${content.length * 2 / 1024}k")
        if (!INCREASE_MODE) {
            startActivityTest()//继续递增
        }
    }
}
```