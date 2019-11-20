# 栈
    inflateFromTag:149, DrawableInflater (android.graphics.drawable)
    inflateFromXmlForDensity:137, DrawableInflater (android.graphics.drawable)
    createFromXmlInnerForDensity:1332, Drawable (android.graphics.drawable)
    createFromXmlForDensity:1291, Drawable (android.graphics.drawable)
    loadDrawableForCookie:833, ResourcesImpl (android.content.res)
    loadDrawable:631, ResourcesImpl (android.content.res)
    getDrawableForDensity:888, Resources (android.content.res)
    getDrawable:827, Resources (android.content.res)
    getDrawable:626, Context (android.content)
    getDrawable:454, ContextCompat (androidx.core.content)
    getDrawable:144, ResourceManagerInternal (androidx.appcompat.widget)
    getDrawable:132, ResourceManagerInternal (androidx.appcompat.widget)
    getDrawable:104, AppCompatResources (androidx.appcompat.content.res)
    setImageResource:86, AppCompatImageHelper (androidx.appcompat.widget)
    setImageResource:94, AppCompatImageView (androidx.appcompat.widget)

    android.graphics.drawable.DrawableInflater#inflateFromXmlForDensity
    
    @NonNull
    Drawable inflateFromXmlForDensity(@NonNull String name, @NonNull XmlPullParser parser,
            @NonNull AttributeSet attrs, int density, @Nullable Theme theme)
            throws XmlPullParserException, IOException {
        // Inner classes must be referenced as Outer$Inner, but XML tag names
        // can't contain $, so the <drawable> tag allows developers to specify
        // the class in an attribute. We'll still run it through inflateFromTag
        // to stay consistent with how LayoutInflater works.
        if (name.equals("drawable")) {
            name = attrs.getAttributeValue(null, "class");
            if (name == null) {
                throw new InflateException("<drawable> tag must specify class attribute");
            }
        }

        Drawable drawable = inflateFromTag(name);
        if (drawable == null) {
            drawable = inflateFromClass(name);
        }
        drawable.setSrcDensityOverride(density);
        drawable.inflate(mRes, parser, attrs, theme);
        return drawable;
    }
# 不同目录下加载的 BitmapDrawable 大小不一样
    android.graphics.drawable.DrawableInflater#inflateFromXmlForDensity
    android.graphics.drawable.BitmapDrawable#inflate
    android.graphics.drawable.BitmapDrawable#updateStateFromTypedArray
    
    /**
     * Updates the constant state from the values in the typed array.
     */
    private void updateStateFromTypedArray(TypedArray a, int srcDensityOverride)
            throws XmlPullParserException {
        final Resources r = a.getResources();
        final BitmapState state = mBitmapState;

        // Account for any configuration changes.
        state.mChangingConfigurations |= a.getChangingConfigurations();

        // Extract the theme attributes, if any.
        state.mThemeAttrs = a.extractThemeAttrs();

        state.mSrcDensityOverride = srcDensityOverride;

        state.mTargetDensity = Drawable.resolveDensity(r, 0);

        final int srcResId = a.getResourceId(R.styleable.BitmapDrawable_src, 0);
        if (srcResId != 0) {
            final TypedValue value = new TypedValue();
            r.getValueForDensity(srcResId, srcDensityOverride, value, true);

            // Pretend the requested density is actually the display density. If
            // the drawable returned is not the requested density, then force it
            // to be scaled later by dividing its density by the ratio of
            // requested density to actual device density. Drawables that have
            // undefined density or no density don't need to be handled here.
            if (srcDensityOverride > 0 && value.density > 0
                    && value.density != TypedValue.DENSITY_NONE) {
                if (value.density == srcDensityOverride) {
                    value.density = r.getDisplayMetrics().densityDpi;
                } else {
                    value.density =
                            (value.density * r.getDisplayMetrics().densityDpi) / srcDensityOverride;
                }
            }

            int density = Bitmap.DENSITY_NONE;
            if (value.density == TypedValue.DENSITY_DEFAULT) {
                density = DisplayMetrics.DENSITY_DEFAULT;
            } else if (value.density != TypedValue.DENSITY_NONE) {
                density = value.density;
            }

            Bitmap bitmap = null;
            try (InputStream is = r.openRawResource(srcResId, value)) {
                ImageDecoder.Source source = ImageDecoder.createSource(r, is, density);
                bitmap = ImageDecoder.decodeBitmap(source, (decoder, info, src) -> {
                    decoder.setAllocator(ImageDecoder.ALLOCATOR_SOFTWARE);
                });
            } catch (Exception e) {
                // Do nothing and pick up the error below.
            }

            if (bitmap == null) {
                throw new XmlPullParserException(a.getPositionDescription() +
                        ": <bitmap> requires a valid 'src' attribute");
            }

            state.mBitmap = bitmap;
        }
        ...