package com.team.up.teamup

import android.content.Intent
import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log
import android.widget.Toast
import androidx.annotation.NonNull
import com.sendbird.calls.SendBirdCall
import com.sendbird.calls.SendBirdError
import com.team.up.teamup.groupcall.main.DashboardViewModel
import com.team.up.teamup.groupcall.preview.PreviewActivity
import com.team.up.teamup.groupcall.room.RoomActivity
import com.team.up.teamup.groupcall.signin.AuthenticateViewModel
import com.team.up.teamup.groupcall.signin.SignInActivity
import com.team.up.teamup.groupcall.util.EXTRA_ENTER_ERROR_CODE
import com.team.up.teamup.groupcall.util.EXTRA_ENTER_ERROR_MESSAGE
import com.team.up.teamup.groupcall.util.EXTRA_IS_NEWLY_CREATED
import com.team.up.teamup.groupcall.util.EXTRA_ROOM_ID
import com.team.up.teamup.groupcall.util.REQUEST_CODE_PREVIEW
import com.team.up.teamup.groupcall.util.RESULT_ENTER_FAIL
import com.team.up.teamup.groupcall.util.SharedPreferencesManager
import com.team.up.teamup.groupcall.util.Status
import com.team.up.teamup.groupcall.util.UNKNOWN_SENDBIRD_ERROR
import com.team.up.teamup.groupcall.util.showAlertDialog
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "video_call_method_channel"
    private val viewModel: AuthenticateViewModel = AuthenticateViewModel()

    private val dashboardViewModel: DashboardViewModel = DashboardViewModel()

    var binaryMessenger: BinaryMessenger? = null

    var isJoinTheRoom = false;
    var toJoinRoomId = "";

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
        observeViewModel();
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            binaryMessenger = flutterEngine.dartExecutor.binaryMessenger;

            // This method is invoked on the main thread.
            println("Method Channel Invoked")
            if (call.method == "video_call_start_function") {
                var userId = call.argument<String>("userId") ?: ""
                var sendBirdID = call.argument<String>("appId") ?: ""
                Toast.makeText(this, "Start Video Call $userId $sendBirdID, ", Toast.LENGTH_SHORT)
                    .show();
                /*val intent = Intent(this, SignInActivity::class.java)
                startActivity(intent)*/
                SendBirdCall.init(applicationContext, sendBirdID)
                //val userId = binding.editTextUserId.text.toString()
                viewModel.authenticate(userId, null)
                isJoinTheRoom = false;
                toJoinRoomId = "";
            }else if (call.method == "video_call_join_function"){
                var userId = call.argument<String>("userId") ?: ""
                var roomId = call.argument<String>("roomId") ?: ""
                var sendBirdID = call.argument<String>("appId") ?: ""
                SendBirdCall.init(applicationContext, sendBirdID)
                viewModel.authenticate(userId, null)
                isJoinTheRoom = true;
                toJoinRoomId = roomId;
            }
        }
    }

    private fun observeViewModel() {
        viewModel.authenticationLiveData.observe(this) { resource ->
            Log.d("MAF Sign in", "observe() resource: $resource")
            when (resource.status) {
                Status.LOADING -> {
                    println("SendBird Authenticate Loading")
                    binaryMessenger?.let {
                        MethodChannel(it, CHANNEL).invokeMethod(
                            "show_progress",
                            ""
                        )
                    }
                }

                Status.SUCCESS -> {
                    println("SendBird Authenticate Success")
                    binaryMessenger?.let {
                        MethodChannel(it, CHANNEL).invokeMethod(
                            "hide_progress",
                            ""
                        )
                    }
                    if(isJoinTheRoom){
                        dashboardViewModel.fetchRoomById(toJoinRoomId);
                    }else{
                        dashboardViewModel.createAndEnterRoom();
                    }
                }

                Status.ERROR -> {
                    Toast.makeText(this, resource.message, Toast.LENGTH_SHORT).show()
                    println("SendBird Authenticate Error")
                    binaryMessenger?.let {
                        MethodChannel(it, CHANNEL).invokeMethod(
                            "hide_progress",
                            ""
                        )
                    }
                }
            }
        }

        dashboardViewModel.createdRoomId.observe(this) { resource ->
            Log.d("MAF Create Room", "observe() resource: $resource")
            when (resource.status) {
                Status.LOADING -> {
                    binaryMessenger?.let {
                        MethodChannel(it, CHANNEL).invokeMethod(
                            "show_progress",
                            ""
                        )
                    }
                }

                Status.SUCCESS -> {
                    binaryMessenger?.let {
                        MethodChannel(it, CHANNEL).invokeMethod(
                            "hide_progress",
                            ""
                        )
                    }
                    resource.data?.let { it1 ->
                        var roomSendArgument = mapOf("roomId" to it1)
                        println("Room ID is $it1")
                        binaryMessenger?.let {
                            MethodChannel(it, CHANNEL).invokeMethod("createdRoomID",
                                roomSendArgument)
                        }
                        goToRoomActivity(it1)
                    }
                }

                Status.ERROR -> {
                    binaryMessenger?.let {
                        MethodChannel(it, CHANNEL).invokeMethod(
                            "hide_progress",
                            ""
                        )
                    }
                    val message = if (resource?.errorCode == SendBirdError.ERR_INVALID_PARAMS) {
                        getString(R.string.dashboard_invalid_room_params)
                    } else {
                        resource?.message
                    }
                    activity?.showAlertDialog(
                        getString(R.string.dashboard_can_not_create_room),
                        message ?: UNKNOWN_SENDBIRD_ERROR
                    )
                }
            }
        }

        dashboardViewModel.fetchedRoomId.observe(this) { resource ->
            Log.d("MAF Fetch Room", "observe() resource: $resource")
            when (resource.status) {
                Status.LOADING -> {
                    binaryMessenger?.let {
                        MethodChannel(it, CHANNEL).invokeMethod(
                            "show_progress",
                            ""
                        )
                    }
                }
                Status.SUCCESS -> {
                    binaryMessenger?.let {
                        MethodChannel(it, CHANNEL).invokeMethod(
                            "hide_progress",
                            ""
                        )
                    }
                    resource.data?.let { goToPreviewActivity(it) }
                }
                Status.ERROR -> {
                    binaryMessenger?.let {
                        MethodChannel(it, CHANNEL).invokeMethod(
                            "hide_progress",
                            ""
                        )
                    }
                    activity?.showAlertDialog(
                        getString(R.string.dashboard_incorrect_room_id),
                        if (resource?.errorCode == 400200) {
                            getString(R.string.dashboard_incorrect_room_id_body)
                        } else {
                            resource?.message ?: UNKNOWN_SENDBIRD_ERROR
                        }
                    )
                }
            }
        }

    }

    private fun goToRoomActivity(roomId: String) {
        val intent = Intent(context, RoomActivity::class.java).apply {
            putExtra(EXTRA_ROOM_ID, roomId)
            putExtra(EXTRA_IS_NEWLY_CREATED, true)
        }

        startActivity(intent)
    }

    private fun goToPreviewActivity(roomId: String) {
        val intent = Intent(context, PreviewActivity::class.java).apply {
            putExtra(EXTRA_ROOM_ID, roomId)
        }

        startActivityForResult(intent, REQUEST_CODE_PREVIEW)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == REQUEST_CODE_PREVIEW && resultCode == RESULT_ENTER_FAIL) {
            val errorCode = data?.getIntExtra(EXTRA_ENTER_ERROR_CODE, -1)
            val errorMessage = if (errorCode == SendBirdError.ERR_PARTICIPANTS_LIMIT_EXCEEDED_IN_ROOM) {
                getString(R.string.dashboard_can_not_enter_room_max_participants_count_exceeded)
            } else {
                data?.getStringExtra(EXTRA_ENTER_ERROR_MESSAGE)
            } ?: UNKNOWN_SENDBIRD_ERROR

            activity?.showAlertDialog(
                getString(R.string.dashboard_can_not_enter_room),
                errorMessage
            )
        }
    }
}
