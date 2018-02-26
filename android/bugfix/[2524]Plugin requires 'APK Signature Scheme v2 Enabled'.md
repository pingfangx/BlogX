Error Plugin requires 'APK Signature Scheme v2 Enabled' for preDebug.

首先定位到是因为使用了美团的 walle  
[walle](https://github.com/Meituan-Dianping/walle)

报错地方位于 GradlePlugin.groovy
```
    void applyTask(Project project) {
        project.afterEvaluate {
            project.android.applicationVariants.all { BaseVariant variant ->
                def variantName = variant.name.capitalize();

                if (!isV2SignatureSchemeEnabled(variant)) {
                    throw new ProjectConfigurationException("Plugin requires 'APK Signature Scheme v2 Enabled' for ${variant.name}.", null);
                }

                ChannelMaker channelMaker = project.tasks.create("assemble${variantName}Channels", ChannelMaker);
                channelMaker.targetProject = project;
                channelMaker.variant = variant;
                channelMaker.setup();

                channelMaker.dependsOn variant.assemble;
            }
        }
    }

    SigningConfig getSigningConfig(BaseVariant variant) {
        return variant.buildType.signingConfig == null ? variant.mergedFlavor.signingConfig : variant.buildType.signingConfig;
    }

    boolean isV2SignatureSchemeEnabled(BaseVariant variant) throws GradleException {
        def signingConfig = getSigningConfig(variant);
        if (signingConfig == null || !signingConfig.isSigningReady()) {
            return false;
        }

        // check whether APK Signature Scheme v2 is enabled.
        if (signingConfig.hasProperty("v2SigningEnabled") &&
                signingConfig.v2SigningEnabled == true) {
            return true;
        }

        return false;
    }
```

在 issue 中找了一遍，知道是因为 isSigningReady 返回了 false ,所以报错。  
方法定义于 SigningConfig，实现于 DefaultSigningConfig
```
    @Override
    public boolean isSigningReady() {
        return mStoreFile != null &&
                mStorePassword != null &&
                mKeyAlias != null &&
                mKeyPassword != null;
    }
```

# 使用测试证书
[Sign Your App](https://developer.android.com/studio/publish/app-signing.html)  
调试证书位于 $HOME/.android/debug.keystore
可以使用 keytool 查看证书。  
查到密码为 android ，别名为 androiddebugkey 

于是可以使用代码
```
                storeFile file(System.getProperty("user.home")+"/.android/debug.keystore")
                storePassword "android"
                keyAlias "androiddebugkey"
                keyPassword "android"
```

# 配置不为空证书
后来进一步发现原因，walle 中使用的是 project.android.applicationVariants.all  
也就是要检查所有的 variant 中的 signingConfig 都必须是正确，或者说都必须经过 isSigningReady 检查  
那只需要不为空即可，而不会判断是否正确。


# 配置 signingConfig 为 debug
再进一步发现，如果 buildType 的 signingConfig 配置为 release 就会被检查失败，如果配置为 debug 则不会被检查。  
具体而言，buildType 分为 debug 和 release ，可以任意指定 signingConfig 为 signingConfig.debug 或 signingConfig.release  
如果指定为 signingConfig.release ，则该 buildType 会被检查失败。  
是否因为不同的 SigningConfig 的 isSigningReady 实现不一样呢？  
在源码中搜索了一下，找到 com.android.builder.signing.DefaultSigningConfig#initDebug
```
    public void initDebug() throws AndroidLocationException {
        mStoreFile = new File(KeystoreHelper.defaultDebugKeystoreLocation());
        mStorePassword = DEFAULT_PASSWORD;
        mKeyAlias = DEFAULT_ALIAS;
        mKeyPassword = DEFAULT_PASSWORD;
    }
```
找到几处使用，如  
com.android.build.gradle.LibraryExtension#LibraryExtension  
com.android.build.gradle.internal.dsl.SigningConfigDsl
```
public class SigningConfigDsl extends DefaultSigningConfig implements Serializable, Named {
    private static final long serialVersionUID = 1L;

    /**
     * Creates a SigningConfig with a given name.
     *
     * @param name the name of the signingConfig.
     *
     */
    public SigningConfigDsl(@NonNull String name) {
        super(name);

        if (BuilderConstants.DEBUG.equals(name)) {
            try {
                initDebug();
            } catch (AndroidLocation.AndroidLocationException e) {
                throw new BuildException("Failed to get default debug keystore location", e);
            }
        }
    }
```

推测 gradle 中使用的就是如此，如果是 debug 则初始化为 debug 证书。  
也就是说，只需将 signingConfig 指定为 debug 然后该 SigningConfig 就会有默认的证书文件，  
则 isSigningReady 就会返回 true .

最后选择了使用测试证书的方法，因为即然是 release 就应该要设置证书，如果没有读取到，则将其设置为调试证书（虽然最好是直接报错）。