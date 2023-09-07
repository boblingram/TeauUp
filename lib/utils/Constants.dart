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
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

showLoader({String text = "Please wait..."}) {
  Get.dialog(
    Center(
      child: ProgressBarWidget(text: "$text"),
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

showSuccess(String message) {
  Get.snackbar('Success!', message,
      backgroundColor: HexColor(AppColors.successMessageC), colorText: Colors.white);
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