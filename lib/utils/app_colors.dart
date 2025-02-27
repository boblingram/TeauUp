import 'package:flutter/material.dart';

class AppColors {
  static const Color goalAppBarColor = Color(0xff589288);
  static const Color black = Color(0xff000000);
  static const Color white = Color(0xffffffff);
  static const Color darkGrey = Colors.grey;
  static const Color red = Colors.red;
  static const Color blue = Colors.blue;
  static const Color green = Colors.green;
  static const Color transparent = Colors.transparent;
  static  Color greyWithShade900 = Colors.grey.shade900;
  static  Color greyWithShade300 = Colors.grey.shade300;
  static  Color prupleWithShade300 = Colors.purple.shade300;


  //Goal View
  static String goalViewBC = "#E9E9E9";
  //Performance Module
  //FBC - Fall back Color
  static String performanceFBC = "#5B5B5B";

  //Bottom Bar Color
  static String nonSelectedColor = "#000000";
  static String selectedColor = "#E52137";

  //Invite Goal Color
  static String downArrowGrey = "#676767";

  //Empty Text Field Color
  static String describeTextFieldColor = "#F6F6F6";

  //Create Goal Activity Color
  static String staticActivityTextColor = "#434343";
  static String nonActivitySelectedBGColor = "#F2F1F0";

  //Progress Bar Color
  static String progressBarC = "#FF0000";
  static String failedMessageC = "#EC268F";
  static String successMessageC = "#a6ce39";
  static String generalMessageC = "#00AFEF";

  //Goal Screen 1
  static String goalBackgroundColor = "#6B8D96";
  static String studyIconBG = "#94BFB6";
  static String yogaIconBG = "#7BBEEE";
  static String wellnessIconBG = "#EABEEE";
  static String cyclingIconBG = "#B98BAB";
  static String runningIconBG = "#F2AD55";
  static String walkingIconBG = "#E18070";
  static String introspectionIconBG = "#6F9EDA";
  static String gymIconBG = "#E6C153";
  static String customIconBG = "#888888";
  static String swimmingIconBG = "#559166";
  static String meditationIconBG = "#A9A78B";
  static String sadhanaIconBG = "#94C973";
  static String teamupIconBG = "#FF0000BF";

  //Goal Screen 2
  static String describeGoalColor = "#429488";
  static String sliderColor = "#000000";
  static String setGoalColor = "#658E92";

  //Journey
  static String journeyColor = "#F3F3F3";

  //Notification
  static String notificationColor = "#39394A";

  static Color makeColorDarker(Color color, int amount) {
    print("Red is ${color.red}, green is ${color.green}, blue is ${color.blue} and alpha is ${color.alpha} ${color.toString()}");
    int red = color.red - amount;
    int green = color.green - amount;
    int blue = color.blue - amount;

    red = red.clamp(0, 255);
    green = green.clamp(0, 255);
    blue = blue.clamp(0, 255);
    print("Red is $red, green is $green, blue is $blue and alpha is ${color.alpha} ${color.toString()}");
    return Color.fromRGBO(red, green, blue, 1);
    //return Color.fromARGB(color.alpha, red, green, blue);
  }

  static Color makeHexColorDarker(String hexColor, int amount) {
    Color color = Color(int.parse(hexColor.substring(1), radix: 16));
    print("Red is ${color.red}, green is ${color.green}, blue is ${color.blue} and alpha is ${color.alpha} ${color.toString()}");
    int red = color.red - amount;
    int green = color.green - amount;
    int blue = color.blue - amount;

    red = red.clamp(0, 255);
    green = green.clamp(0, 255);
    blue = blue.clamp(0, 255);
    print("Red is $red, green is $green, blue is $blue and alpha is ${color.alpha} ${color.toString()}");
    return Color.fromRGBO(red, green, blue, 1);
    //return Color.fromARGB(color.alpha, red, green, blue);
  }
}