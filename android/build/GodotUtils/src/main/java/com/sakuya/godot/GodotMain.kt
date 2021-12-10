package com.sakuya.godot

import android.util.Log
import org.godotengine.godot.Godot
import org.godotengine.godot.plugin.GodotPlugin
import org.godotengine.godot.plugin.SignalInfo
import java.util.*

class GodotMain(godot: Godot) :GodotPlugin(godot) {

    override fun getPluginName(): String {
        Log.e("GodotPlugin","init")
        return "GodotUtils"
    }

    override fun getPluginMethods(): MutableList<String> {
        return Arrays.asList("getSignString")
    }

    override fun getPluginSignals(): MutableSet<SignalInfo> {
        val signals: MutableSet<SignalInfo> = mutableSetOf()
        signals.add(SignalInfo("onSignStringResult", String::class.java))
        return signals
    }

    fun getSignString(){
        var sign :String = activity?.let { SignCheck.getSignString(it) } ?: ""
        emitSignal("onSignStringResult",sign)
    }

}