# java.io.Serializable
java 中的序列化

# android.os.Parcelable
Android 中的打包
## writeToParcel
    com.pingfangx.demo.androidx.activity.android.os.Person#writeToParcel
    
    writeToParcel:27, Person (com.pingfangx.demo.androidx.activity.android.os)
    writeParcelable:1675, Parcel (android.os)
    writeValue:1581, Parcel (android.os)
    writeArrayMapInternal:867, Parcel (android.os)
    writeToParcelInner:1579, BaseBundle (android.os)
    writeToParcel:1233, Bundle (android.os)
    writeBundle:907, Parcel (android.os)
    writeToParcel:9961, Intent (android.content)
    startActivity:3730, IActivityManager$Stub$Proxy (android.app)
    execStartActivity:1669, Instrumentation (android.app)
    startActivityForResult:4586, Activity (android.app)
    startActivityForResult:676, FragmentActivity (androidx.fragment.app)
    startActivityForResult:4544, Activity (android.app)
    startActivityForResult:663, FragmentActivity (androidx.fragment.app)
    startActivity:4905, Activity (android.app)
    startActivity:4873, Activity (android.app)
    
# CREATOR#createFromParcel
    <init>:22, Person (com.pingfangx.demo.androidx.activity.android.os)
    createFromParcel:34, Person$CREATOR (com.pingfangx.demo.androidx.activity.android.os)
    createFromParcel:33, Person$CREATOR (com.pingfangx.demo.androidx.activity.android.os)
    readParcelable:2766, Parcel (android.os)
    readValue:2660, Parcel (android.os)
    readArrayMapInternal:3029, Parcel (android.os)
    initializeFromParcelLocked:288, BaseBundle (android.os)
    unparcel:232, BaseBundle (android.os)
    getString:1155, BaseBundle (android.os)
    getStringExtra:7445, Intent (android.content)
    onCreate:20, VirtualActivity (com.pingfangx.demo.androidx.common)
    performCreate:7136, Activity (android.app)
    performCreate:7127, Activity (android.app)
    callActivityOnCreate:1271, Instrumentation (android.app)
    performLaunchActivity:2893, ActivityThread (android.app)
    handleLaunchActivity:3048, ActivityThread (android.app)
    execute:78, LaunchActivityItem (android.app.servertransaction)
    executeCallbacks:108, TransactionExecutor (android.app.servertransaction)
    execute:68, TransactionExecutor (android.app.servertransaction)
    handleMessage:1808, ActivityThread$H (android.app)
    dispatchMessage:106, Handler (android.os)
    loop:193, Looper (android.os)
    main:6669, ActivityThread (android.app)