package com.team.up.teamup

import android.content.Intent
import android.os.Bundle
import android.os.PersistableBundle
import android.widget.Toast
import androidx.annotation.NonNull
import com.sendbird.calls.SendBirdCall
import com.team.up.teamup.groupcall.signin.SignInActivity
import com.team.up.teamup.groupcall.util.SharedPreferencesManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "video_call_method_channel"

    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
        SendBirdCall.setLoggerLevel(SendBirdCall.LOGGER_INFO)
        SharedPreferencesManager.init(applicationContext)
        println("Successfully Initialized Main 2 argument")
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        SendBirdCall.setLoggerLevel(SendBirdCall.LOGGER_INFO)
        SharedPreferencesManager.init(applicationContext)
        println("Successfully Initialized Main 1 argument")
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            // This method is invoked on the main thread.
            println("Method Channel Invoked")
            if(call.method == "video_call_start_function"){
                println("Video Call message");
                Toast.makeText(this,"Start Video Call",Toast.LENGTH_SHORT).show();
                val intent = Intent(this, SignInActivity::class.java)
                startActivity(intent)
            }
        }
    }
}
