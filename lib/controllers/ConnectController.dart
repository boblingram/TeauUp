import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';
import 'package:teamup/utils/Constants.dart';

import '../utils/app_strings.dart';

class ConnectController extends GetxController{

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
    //TODO Reactivate old
    userId = 'Viv18Nov6-24c63baa-d589-494a-9969-8deb599ae4ef';
    //userId = "${userName}-${userId}";
    try {
      final sendbird = SendbirdSdk(appId: Constants.SENDBIRDCONSTANT);
      final user = await sendbird.connect(userId);

    } catch (e) {
      print('login_view: connect: ERROR: $e');
      rethrow;
    }
  }

  final MethodChannel _channel = MethodChannel(Constants.VIDEOCALLMETHODCHANNEL);

  void startVideoCall() {
    print("Video Call Tapped");
    //Returns the future
    try{
      _channel.invokeMethod(Constants.VIDEOCALLSTARTFUNC,{'userId':"Flutter UserID"});
    }catch(onError, stacktrace){
      print("Video Call start failed some error $onError \n Stacktrace is $stacktrace");
    }

  }
}