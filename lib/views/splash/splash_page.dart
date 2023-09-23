import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teamup/controllers/RootController.dart';
import 'package:teamup/utils/app_strings.dart';
import 'package:teamup/views/HomeView.dart';
import 'package:teamup/views/onboard/onboard_page.dart';

import '../../utils/app_Images.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  final RootController rootController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {postUIBuildTask();});
  }

  void postUIBuildTask()async{
    await firebaseNotification();
    await rootController.checkAndNavigate();
  }

  Future<void> firebaseNotification() async {
    print("FirebaseInitialization");
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      //await Notification_Service().init();
      messaging.getToken().then((value) {
        print("FCM Token is $value");
        rootController.updateFCMToken(value ?? AppStrings.emptyValue);
      }).catchError((error) {
        print("GetFCMTokenFunctionError is $error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image(
        image: AssetImage(AppImages.splash),
        fit: BoxFit.cover,
        height: Get.height,
        width: Get.width,
      ),
    );
  }
}
