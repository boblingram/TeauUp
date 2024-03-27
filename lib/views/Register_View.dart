import 'dart:developer';
import 'dart:ui';

import 'package:country_picker/country_picker.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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

class _RegisterViewState extends State<RegisterView> with BaseClass {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final RootController rootController = Get.find();

  var phoneCode = "91".obs;

  String _getCountryCode(BuildContext context) {
    var countryCode = PlatformDispatcher.instance.locale.countryCode;
    switch((countryCode ?? "").toLowerCase()){
      case "in":phoneCode.value = "91";break;
      case "us":phoneCode.value = "1";break;
      case "fr":phoneCode.value = "33";break;
      case "ru":phoneCode.value = "7";break;
    }
    //final List<Locale> systemLocales = WidgetsBinding.instance.window.locales;
    //print("Local Code is ${systemLocales.first.countryCode} Local Code is ${}");
    return countryCode ?? "";
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void postUIBuild() async {
    _getCountryCode(context);
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (GetPlatform.isAndroid) {
      var androidResult = await deviceInfo.androidInfo;
      log("Data is ${androidResult.data}");
      rootController.deviceId = androidResult.id;
      rootController.fingerprint = androidResult.fingerprint;
    } else {
      var iOSResult = await deviceInfo.iosInfo;
      rootController.deviceId = iOSResult.model ?? AppStrings.emptyValue;
      rootController.fingerprint =
          iOSResult.identifierForVendor ?? AppStrings.emptyValue;
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      postUIBuild();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                height: 30.h,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Let's Get\nStarted",
                        style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.black54,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "Looks like you are using Teamup for the first time. By what name do you want to appear for others?",
                        style: TextStyle(fontSize: 12.sp),
                      ),
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
                            textEditingController: nameController,
                            inputAction: TextInputAction.done,
                            inputType: TextInputType.text),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          children: [
                            Obx(
                              () => InkWell(
                                onTap: () {
                                  showCountryPicker(
                                      context: context,
                                      showPhoneCode: true,
                                      onSelect: (var country) {
                                        phoneCode.value = country.phoneCode;
                                        /*loginController.setCountryName(country.name);
                                    loginController.setPhoneCode(country.phoneCode);*/
                                        print(
                                            "Selected Country is ${country.name} + ${country.phoneCode}");
                                      });
                                },
                                child: Text(
                                  "+${phoneCode.value}",
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Expanded(
                              child: TextField(
                                controller: phoneController,
                                cursorColor: Colors.black,
                                style: TextStyle(fontSize: 14.sp),
                                decoration: InputDecoration(
                                    hintText: "Enter your phone",
                                    border: InputBorder.none,),
                              ),
                            )
                          ],
                        ),
                      ),
                      RoundedEdgeButton(
                          backgroundColor: Colors.red,
                          text: "Next",
                          leftMargin: 0,
                          topMargin: 40,
                          buttonRadius: 10,
                          rightMargin: 0,
                          bottomMargin: 20,
                          onPressed: () {
                            if (nameController.text == null ||
                                nameController.text.isEmpty) {
                              showError(
                                  title: "Error", message: "Name is required");
                              return;
                            }
                            if (phoneController.text == null ||
                                phoneController.text.isEmpty) {
                              showError(
                                  title: "Error", message: "Phone is required");
                              return;
                            }
                            rootController.newRegistrationToServer(
                                nameController.text.trim(),
                                "+${phoneCode.value}" +
                                    phoneController.text.trim());
                          },
                          context: context)
                    ],
                  ),
                ),
              ),
              Text.rich(
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
              ),
              Container(height: 70.h,color: Colors.white,)
            ],
          ),
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
