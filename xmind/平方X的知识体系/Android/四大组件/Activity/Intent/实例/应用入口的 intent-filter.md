# MainActivity
        <activity android:name=".MainActivity">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />

                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
            <intent-filter android:label="@string/app_name">
                <action android:name="android.intent.action.VIEW" />

                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />

                <data
                    android:host="www.pingfangx.com"
                    android:scheme="xx" />
            </intent-filter>
        </activity>
# MAIN
action.MAIN 配合 category.LAUNCHER

# VIEW
action.VIEW 配合 category.DEFAULT 和 category.BROWSABLE