package com.sakuya.godot

import android.util.Log
import com.zh.pocket.ads.reward_video.RewardVideoAD
import com.zh.pocket.ads.reward_video.RewardVideoADListener
import com.zh.pocket.error.ADError
import org.godotengine.godot.Godot
import org.godotengine.godot.plugin.GodotPlugin
import org.godotengine.godot.plugin.SignalInfo
import java.util.*


class GodotMain(godot: Godot) :GodotPlugin(godot) {

    private var mRewardVideoAD: RewardVideoAD? = null

    override fun getPluginName(): String {
        Log.e("GodotPlugin","init")
        return "GodotUtils"
    }

    override fun getPluginMethods(): MutableList<String> {
        return Arrays.asList("getSignString","showRewardVideoAD")
    }

    override fun getPluginSignals(): MutableSet<SignalInfo> {
        val signals: MutableSet<SignalInfo> = mutableSetOf()
        signals.add(SignalInfo("onSignStringResult", String::class.java))
        signals.add(SignalInfo("onAdResult", String::class.java))
        return signals
    }

    fun getSignString(){
        var sign :String = activity?.let { SignCheck.getSignString(it) } ?: ""
        emitSignal("onSignStringResult",sign)
    }

    private fun showRewardVideoAD() {
        mRewardVideoAD = RewardVideoAD(activity, "53451")
        mRewardVideoAD?.setRewardVideoADListener(object : RewardVideoADListener {
            override fun onADLoaded() {
                mRewardVideoAD?.showAD()
            }

            override fun onVideoCached() {}
            override fun onADShow() {
                emitSignal("onAdResult","Show")
            }
            override fun onADExposure() {}
            override fun onReward() {
                emitSignal("onAdResult","onReward")
            }
            override fun onADClicked() {}
            override fun onVideoComplete() {
                emitSignal("onAdResult","Success")
            }
            override fun onADClosed() {
                emitSignal("onAdResult","Closed")
            }
            override fun onSuccess() {}
            override fun onFailed(error: ADError) {
                emitSignal("onAdResult","Failed")
            }
            override fun onSkippedVideo() {}
        })
        mRewardVideoAD?.loadAD()
    }
}