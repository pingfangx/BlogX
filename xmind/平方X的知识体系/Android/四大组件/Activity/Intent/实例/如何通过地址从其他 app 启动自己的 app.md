配置 intent-filter 即可
指定 action 为 android.intent.action.VIEW
指定 category 为 android.intent.category.DEFAULT 和 android.intent.category.BROWSABLE
最后配置 data，指定 scheme, host, port, path

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