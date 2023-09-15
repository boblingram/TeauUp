import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
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

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
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
                      leftMargin: 0,topMargin: 20,
                      buttonRadius: 10,
                      rightMargin: 0,
                      bottomMargin: 20,
                      onPressed: () {
                        print("Next Button Pressed");
                      },
                      context: context)
                ],
              ),
            ),flex: 3,),
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
