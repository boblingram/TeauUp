import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';
import 'package:teamup/utils/Constants.dart';

import '../utils/app_strings.dart';

class ConnectController extends GetxController{

  //final String testingUserId2 = "Akash-7f2aba83-c210-4bfe-8763-edbd6323a8a3";
  GroupChannel? groupChannel;

  List<BaseMessage> messages = [];
  String localSendBirdUserId = "";

  @override
  void onInit() {
    super.onInit();
    initiateConnectionWithSendBird();
  }

  void initiateConnectionWithSendBird() async{
    print("Connection Initiated for Connect with Send Bird");
    //In Format of name-userid
    var userId = GetStorage().read(AppStrings.localClientIdValue) ??
        AppStrings.defaultUserId;
    var userName = GetStorage().read(AppStrings.localClientNameValue) ?? "";
    print("Required format is ${userId}-${userName}");
    if(Constants.isConnectLocalTesting){
      userId = "${userName}-${userId}";
    }else{
      userId = Constants.loginSendBirdUserId;
    }
    localSendBirdUserId = userId;
    try {
      final sendbird = SendbirdSdk(appId: Constants.SENDBIRDAPPID);
      final user = await sendbird.connect(userId);

    } catch (e) {
      print('login_view: connect: ERROR: $e');
      rethrow;
    }
    activateTheListeners();
  }

  void activateTheListeners(){
    _channel.setMethodCallHandler((call) async{
      print("Method is called");
      switch(call.method){
        case "show_progress":
          print("Show Progress Bar");
          showPLoader();
          break;
        case "hide_progress":
          print("Hid Progress Bar");
          Get.back();
          break;
        case "createdRoomID":
          log("Created Room ID ${call.arguments.toString()}");
          //TODO Send this data in chat and push notification Group Channel, Room ID,
          //Created Room ID {roomId: 0d9b18d0-b377-49c2-9ac7-dccebf03e80d}
          try{
            var roomId = call.arguments["roomId"];
            sendVideoCallMessage(roomId);
          }catch(onError,stacktrace){
            print("Failed to parse the roomId");
          }
          break;
        default:
      }

    });
  }

  //Communication from Flutter to kotlin
  final MethodChannel _channel = MethodChannel(Constants.VIDEOCALLMETHODCHANNEL);

  Future<void> _requestMultiplePermissions(List<Permission> permissions) async {
    Map<Permission, PermissionStatus> statuses = await permissions.request();

    statuses.forEach((permission, status) {
      if (status.isGranted) {
        print('${permission.toString()} permission granted');
      } else {
        print('${permission.toString()} permission denied');
      }
    });
  }

  void startVideoCall() async {
    print("Video Call Tapped");
    //Request the permission of Camera, Microphone, Bluetooth
    await _requestMultiplePermissions([
      Permission.camera,
      Permission.microphone,
      Permission.bluetooth,
      Permission.bluetoothConnect
    ]);
    //Returns the future
    if(localSendBirdUserId.isEmpty){
      localSendBirdUserId = Constants.loginSendBirdUserId;
    }
    try{
      _channel.invokeMethod(Constants.VIDEOCALLSTARTFUNC,{'userId':localSendBirdUserId,"appId":Constants.SENDBIRDAPPID});
    }catch(onError, stacktrace){
      print("Video Call start failed some error $onError \n Stacktrace is $stacktrace");
    }
  }

  void joinTheVideoCall(String roomID)async {
    //TODO Bluetooth Permission is pending
    await _requestMultiplePermissions([
      Permission.camera,
      Permission.microphone,
      Permission.bluetooth,
      Permission.bluetoothConnect
    ]);
    if(localSendBirdUserId.isEmpty){
      localSendBirdUserId = Constants.loginSendBirdUserId;
    }
    try{
      _channel.invokeMethod(Constants.VIDEOCALLJOINFUNC,{'roomId':roomID,"appId":Constants.SENDBIRDAPPID,'userId':localSendBirdUserId});
    }catch(onError, stacktrace){
      print("Video Call start failed some error $onError \n Stacktrace is $stacktrace");
    }
  }

  void joinTheVideoCallUser(String roomId, String userId) async{
    //TODO Bluetooth Permission is pending
    await _requestMultiplePermissions([
      Permission.camera,
      Permission.microphone,
      Permission.bluetooth,
      Permission.bluetoothConnect
    ]);
    try{
      _channel.invokeMethod(Constants.VIDEOCALLJOINFUNC,{'roomId':roomId,"appId":Constants.SENDBIRDAPPID,'userId':userId});
    }catch(onError, stacktrace){
      print("Video Call start failed some error $onError \n Stacktrace is $stacktrace");
    }
  }

  //Click to Join the video room
  void sendVideoCallMessage(String roomId){
    if(groupChannel != null){
      UserMessageParams userMessageParams = UserMessageParams(message: "Click to Join the video room",data: roomId);
      var userMessage = groupChannel!.sendUserMessage(userMessageParams);
      messages.insert(0,userMessage);
      update();
    }
  }
}