package com.cloudy.jun.module.start.util;

import android.view.animation.Animation;
import android.view.animation.AnimationSet;

/**
 * 以帧计算时间的工具
 * <p>
 * 以后出动画可能不是 60 fps 所以可供设置
 *
 * @author pingfangx
 * @date 2019/3/14
 */
class FrameAnimationUtils {
    /**
     * 默认 fps
     */
    private static final int DEFAULT_FPS = 60;
    /**
     * 用于 static 方法
     */
    private static FrameAnimationUtils sFrameAnimationUtils;
    /**
     * 每帧时间
     */
    private float mFrameTime;

    public FrameAnimationUtils() {
        this(DEFAULT_FPS);
    }

    public FrameAnimationUtils(int fps) {
        mFrameTime = 1000F / fps;
    }

    /**
     * 根据帧数，将动画添加到动画集
     *
     * @param animationSet 动画集
     * @param animation 动画
     * @param startFrame 开始帧
     * @param endFrame 结束帧
     */
    public void addAnimationToSetInner(AnimationSet animationSet, Animation animation, int startFrame, int endFrame) {
        animation.setStartOffset((long) (startFrame * mFrameTime));
        animation.setDuration((long) ((endFrame - startFrame) * mFrameTime));
        animationSet.addAnimation(animation);
    }

    public static void addAnimationToSet(AnimationSet animationSet, Animation animation, int startFrame, int endFrame) {
        if (sFrameAnimationUtils == null) {
            sFrameAnimationUtils = new FrameAnimationUtils();
        }
        sFrameAnimationUtils.addAnimationToSetInner(animationSet, animation, startFrame, endFrame);
    }
}
