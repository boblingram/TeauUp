import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teamup/controllers/RootController.dart';
import 'package:teamup/mixins/baseClass.dart';

import '../bottom_sheets/privacy_policy_bottom_sheet.dart';
import '../bottom_sheets/terms_condition_bottom_sheet.dart';
import '../utils/app_strings.dart';
import '../widgets/edittext_with_hint.dart';
import '../widgets/rounded_edge_button.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> with BaseClass{

  TextEditingController nameController = TextEditingController();
  final RootController rootController = Get.find();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void postUIBuild() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if(GetPlatform.isAndroid){
      var androidResult = await deviceInfo.androidInfo;
      log("Data is ${androidResult.data}");
      rootController.deviceId = androidResult.id;
      rootController.fingerprint = androidResult.fingerprint;
    }else{
      var iOSResult = await deviceInfo.iosInfo;
      rootController.deviceId = iOSResult.model ?? AppStrings.emptyValue;
      rootController.fingerprint = iOSResult.identifierForVendor ?? AppStrings.emptyValue;
      print("iOS Data Received is Name ${iOSResult.name}"
          "\n Identifier for Vendor ${iOSResult.identifierForVendor}"
          "\n Localized Model ${iOSResult.localizedModel}"
          "\n Model ${iOSResult.model}"
          "\n System Name ${iOSResult.systemName}"
          "\n System Version ${iOSResult.systemVersion}"
          "\n Data ${iOSResult.data}"
          "\n  UTS ${iOSResult.utsname}");
    }
    rootController.updateDeviceIdFingerprint();


    var result = await deviceInfo.deviceInfo;

    print("Base Device Info is ${result.data}");
  }

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {postUIBuild();});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.red,),
      body: Container(
        child: Column(
          children: [
            Expanded(child: Container(),flex: 2,),
            Expanded(child: Container(
              padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Let's Get\nStarted",style: TextStyle(fontSize: 20.sp,color: Colors.black54,fontWeight: FontWeight.w700),),
                  Text("Looks like you are using Teamup for the first time. By what name do you want to appear for others?",style: TextStyle(fontSize: 12.sp),),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    child: EditTextWithHint(
                        hintText: "Enter Your Name",
                        context: context,
                        leftMargin: 0,
                        rightMargin: 0,
                        radius: 5,
                        textEditingController:
                        nameController,
                        inputAction: TextInputAction.done,
                        inputType: TextInputType.text),
                  ),
                  RoundedEdgeButton(
                      backgroundColor:
                      Colors.red,
                      text: "Next",
                      leftMargin: 0,topMargin: 40,
                      buttonRadius: 10,
                      rightMargin: 0,
                      bottomMargin: 20,
                      onPressed: () {
                        if(nameController.text == null || nameController.text.isEmpty){
                          showError(title: "Error", message: "Name is required");
                          return;
                        }
                        rootController.newRegistrationToServer(nameController.text.trim());
                      },
                      context: context)
                ],
              ),
            ),flex: 4,),
            Expanded(child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'By Signing up you agree to the '),
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = _handleTermsTap,
                    text: 'Terms of Service',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' \n and '),
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = _handlePrivacyTap,
                    text: 'Privacy Policy',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),flex: 1,)
          ],
        ),
      ),
    );
  }

  void _handlePrivacyTap() {
    PrivacyPolicyBottomSheet().privacyBottomSheet(
        context: context,
        title: "Privacy Policy",
        data: AppStrings.privacyData,
        onCloseClick: () {
          popToPreviousScreen(context: context);
        });
  }
  void _handleTermsTap() {
    TermsBottomSheet().termsBottomSheet(
        context: context,
        title: "Terms & Conditions",
        data: AppStrings.termsData,
        onCloseClick: () {
          popToPreviousScreen(context: context);
        });
  }
}
