package com.team.up.teamup.groupcall

import android.app.Application
import com.sendbird.calls.SendBirdCall
import com.team.up.teamup.groupcall.util.SharedPreferencesManager

class BaseApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        SendBirdCall.setLoggerLevel(SendBirdCall.LOGGER_INFO)
        SharedPreferencesManager.init(applicationContext)
        println("Successfully Initialized Base")
    }
}
