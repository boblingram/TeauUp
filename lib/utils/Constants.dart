import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:teamup/utils/app_colors.dart';
import 'package:teamup/widgets/ProgressBarWidget.dart';

class Constants{
  //Http Link
  static String BASEURL = "https://l6ehkopu7fcq5lglpxspaw5yyu.appsync-api.us-west-2.amazonaws.com/graphql";
  static String HEADER_API_KEY = "x-api-key";
  //static String API_KEY = "da2-afrlccepgjc5xhkwsfqy3bfidm";
  static String API_KEY = "da2-l3lglx2ihbajlbdenx56njjzbu";

  static String STORAGEURL = "https://ndp1u8b9n4.execute-api.us-west-2.amazonaws.com/v1/teamup-pub/";
  static String SENDBIRDAPPID = "BCD6DF14-603E-4CA4-828B-B05FA986A007";

  //Method Channels
  static String VIDEOCALLMETHODCHANNEL = 'video_call_method_channel';
  static String VIDEOCALLSTARTFUNC = 'video_call_start_function';
  static String VIDEOCALLJOINFUNC = 'video_call_join_function';

  static bool isConnectLocalTesting = true;
  //static String loginSendBirdUserId = "Dr Rajan-6a764cf8-98ff-48e2-b158-9c201a3c4551";
  static String loginSendBirdUserId = "Viv18Nov6-24c63baa-d589-494a-9969-8deb599ae4ef";
  //static String testingUserId2 = 'Viv18Nov6-24c63baa-d589-494a-9969-8deb599ae4ef';
  //static String testingRoomId = "0d9b18d0-b377-49c2-9ac7-dccebf03e80d";
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

showPLoader({String text = "Please wait...", String? progressColor, bool isExpanded = false}) {
  Get.dialog(
    Center(
      child: ProgressBarWidget(text: "$text", progressColor: progressColor,isExpanded: isExpanded,),
    ),
    barrierDismissible: false,
  );
}

hidePLoader() {
  print(
      "Is Snackbar open ${Get.isSnackbarOpen} is Dialog open ${Get.isDialogOpen}");
  if (Get.isSnackbarOpen) {
    //print("Close After Delay");
    Future.delayed(Duration(seconds: 4, milliseconds: 300), () {
      Get.back();
    });
  } else {
    //print("Immediately Close After Delay");
    Get.back();
  }
}


showErrorWOTitle(String message) {
  Get.snackbar('Error!', message,
      backgroundColor: HexColor(AppColors.failedMessageC), colorText: Colors.white);
}

showPSuccess(String message, {Color? selectedColor}) {
  Get.snackbar('Success!', message,
      backgroundColor: selectedColor ?? HexColor(AppColors.successMessageC), colorText: Colors.white);
}

showSnackMessage(String message,
    {bool showTitle = false, String title = "Alert"}) {
  Get.snackbar(showTitle ? title : "", message,
      backgroundColor: Colors.white,
      colorText: Colors.blue,
      snackPosition: SnackPosition.BOTTOM);
}

final List<String> activityTimeList = [
  "1:00",
  "1:30",
  "2:00",
  "2:30",
  "3:00",
  "3:30",
  "4:00",
  "4:30",
  "5:00",
  "5:30",
  "6:00",
  "6:30",
  "7:00",
  "7:30",
  "8:00",
  "8:30",
  "9:00",
  "9:30",
  "10:00",
  "10:30",
  "11:00",
  "11:30",
  "12:00",
  "12:30",
];