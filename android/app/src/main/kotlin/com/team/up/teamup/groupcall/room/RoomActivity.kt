package com.team.up.teamup.groupcall.room

import android.os.Bundle
import com.team.up.teamup.R
import com.team.up.teamup.groupcall.util.BaseActivity
import com.team.up.teamup.groupcall.util.EXTRA_IS_NEWLY_CREATED
import com.team.up.teamup.groupcall.util.EXTRA_ROOM_ID

class RoomActivity : BaseActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_room)
    }

    fun getRoomId(): String {
        return intent.getStringExtra(EXTRA_ROOM_ID) ?: throw IllegalStateException()
    }

    fun isNewlyCreated(): Boolean {
        return intent.getBooleanExtra(EXTRA_IS_NEWLY_CREATED, false)
    }

    override fun onBackPressed() {
        val currentFragment = supportFragmentManager.findFragmentById(R.id.nav_host_room).let {
            it?.childFragmentManager?.fragments?.firstOrNull()
        }

        if (currentFragment is GroupCallFragment) {
            // ignore event
        } else {
            super.onBackPressed()
        }
    }
}