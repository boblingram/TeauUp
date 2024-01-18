package com.team.up.teamup.groupcall.splash

import android.content.Intent
import android.os.Bundle
import com.team.up.teamup.R
import com.team.up.teamup.groupcall.signin.SignInActivity
import com.team.up.teamup.groupcall.util.BaseActivity
import java.util.*

class SplashActivity : BaseActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_splash)

        Timer().schedule(object : TimerTask() {
            override fun run() {
                val intent = Intent(this@SplashActivity, SignInActivity::class.java)
                startActivity(intent)
                finish()
            }
        }, SPLASH_INTERVAL)
    }

    companion object {
        const val SPLASH_INTERVAL = 2000L
    }
}
