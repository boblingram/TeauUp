import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:teamup/controllers/goalController.dart';
import 'package:teamup/mixins/baseClass.dart';
import 'package:teamup/utils/app_colors.dart';
import 'package:teamup/widgets/edittext_with_hint.dart';
import 'package:teamup/widgets/rounded_edge_button.dart';

import '../../../utils/app_Images.dart';
import '../create_goal_activities/create_goal_activities_page.dart';

class DescribeGoalPage extends StatefulWidget {
  final String selectedGoal;

  const DescribeGoalPage({Key? key, required this.selectedGoal})
      : super(key: key);

  @override
  State<DescribeGoalPage> createState() => _DescribeGoalPageState();
}

class _DescribeGoalPageState extends State<DescribeGoalPage> with BaseClass {
  File? imagePicked;
  GoalController _goalController = Get.find();

  TextEditingController goalNTC = TextEditingController(text: "");
  TextEditingController goalDTC = TextEditingController(text: "");

  var isNextAllowed = false.obs;

  @override
  void initState() {
    super.initState();
    goalNTC.addListener(_handleTextChanged);
    goalDTC.addListener(_handleTextChanged);
  }
  
  @override
  void dispose() {
    goalNTC.removeListener(_handleTextChanged);
    goalDTC.removeListener(_handleTextChanged);
    goalNTC.dispose();
    goalDTC.dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    isNextAllowed.value = goalNTC.text
        .trim()
        .isNotEmpty &&
      goalDTC.text
            .trim()
            .isNotEmpty;
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        imagePicked = imageTemp;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  String getColorName(String selectedGoal) {
    switch (selectedGoal) {
      case "Wellness":
        return AppColors.wellnessIconBG;
      case "Yoga":
        return AppColors.yogaIconBG;
      case "Study":
        return AppColors.studyIconBG;
      case "Cycling":
        return AppColors.cyclingIconBG;
      case "Running":
        return AppColors.runningIconBG;
      case "Walking":
        return AppColors.walkingIconBG;
      case "Gym":
        return AppColors.gymIconBG;
      case "Introspection":
        return AppColors.introspectionIconBG;
      default:
        return AppColors.customIconBG;
    }
  }

  String getImageName(String elementAt) {
    switch (elementAt){
      case "Wellness":
        return AppImages.wellnessIcon;
      case "Walking":
        return AppImages.walkingIcon;
      case "Yoga":
        return AppImages.yogaIcon;
      case "Study":
        return AppImages.studyIcon;
      case "Running":
        return AppImages.runningIcon;
      case "Gym":
        return AppImages.gymIcon;
      case "Introspection":
        return AppImages.introspectionIcon;
      case "Cycling":
      default:
        return AppImages.cyclingIcon;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: HexColor(AppColors.describeGoalColor),
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 1.5.h,),
                  InkWell(
                    onTap: () {
                      popToPreviousScreen(context: context);
                    },
                    child: Container(
                      height: 5.w,
                      width: 5.w,
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 11.h,),
                  Text(
                    "2/4",
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      wordSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h,),
                  Text(
                    "Describe your Goal",
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "This goal helps participants to know\nwhat they can achieve by this goal. We\nhave prefilled a default description\nbased on your goal selection. You can\nedit this or create your own description",
                    style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          imagePicked != null
                              ? Container(
                                  height: 20,
                                  width: 20,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image(
                                    image: FileImage(imagePicked!),
                                  ),
                                )
                              : Container(
                                  height: 6.w,
                                  width: 6.w,
                                  decoration: BoxDecoration(
                                    color: HexColor(getColorName(widget.selectedGoal)),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                      padding: EdgeInsets.all(0.9.w),
                                      child: Image.asset(getImageName(widget.selectedGoal))),
                                ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.selectedGoal,
                            style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          popToPreviousScreen(context: context);
                        },
                        child: Row(
                          children: [
                            Text(
                              "Change",
                              style: GoogleFonts.roboto(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                              size: 15,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Goal Name",
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    child: EditTextWithHint(
                        hintText: "Enter Goal Name",
                        context: context,
                        leftMargin: 0,
                        rightMargin: 0,
                        radius: 5,
                        textEditingController:
                            goalNTC,
                        inputAction: TextInputAction.done,
                        inputType: TextInputType.text),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Goal Description",
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    child: EditTextWithHint(
                        hintText: "",
                        maxLines: 6,
                        context: context,
                        leftMargin: 0,
                        rightMargin: 0,
                        textEditingController:
                            goalDTC,
                        inputAction: TextInputAction.done,
                        inputType: TextInputType.text),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Goal Icon",
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          pickImage();
                        },
                        child: Row(
                          children: [
                            imagePicked != null
                                ? Container(
                                    height: 20,
                                    width: 20,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image(
                                      image: FileImage(imagePicked!),
                                    ),
                                  )
                                : Container(
                                    height: 6.w,
                                    width: 6.w,
                                    decoration: BoxDecoration(
                                        color: HexColor(getColorName(widget.selectedGoal)),
                                        shape: BoxShape.circle),
                              child: Padding(
                                  padding: EdgeInsets.all(0.9.w),
                                  child: Image.asset(getImageName(widget.selectedGoal))),
                                  ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                              size: 15,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Obx(()=>RoundedEdgeButton(
                      backgroundColor: isNextAllowed.value
                          ? Colors.red
                          : Colors.grey,
                      text: "Next",
                      leftMargin: 0,
                      rightMargin: 0,
                      topMargin: 20,
                      buttonRadius: 5,
                      onPressed: () {
                        if(!isNextAllowed.value){
                          //TODO Show Error
                          return;
                        }
                        _goalController.updateNameAndDescription(goalNTC.text.trim(),goalDTC.text.trim(),widget.selectedGoal);
                        pushToNextScreen(
                            context: context,
                            destination: CreateGoalActivities());
                      },
                      context: context)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
