import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import 'package:teamup/mixins/baseClass.dart';
import 'package:teamup/utils/app_colors.dart';
import 'package:teamup/widgets/edittext_with_hint.dart';
import 'package:teamup/widgets/rounded_edge_button.dart';

import '../../../controllers/GoalController.dart';
import '../../../utils/GoalIconandColorStatic.dart';
import '../../../utils/app_Images.dart';
import '../../../widgets/CreateGoalMetaDataView.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CreateGoalMetaDataView(onPressed: (){
              popToPreviousScreen(context: context);
            },
              sliderText: "2/4",
              sliderValue: 50,
              sliderColor: HexColor(AppColors.sliderColor),
              goalMetaTitle: "Describe your Goal",
              goalMetaDescription: "This goal helps participants to know\nwhat they can achieve by this goal. We\nhave prefilled a default description\nbased on your goal selection. You can\nedit this or create your own description"),
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
                                    color: HexColor(GoalIconandColorStatic.getColorName(widget.selectedGoal)),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                      padding: EdgeInsets.all(0.9.w),
                                      child: Image.asset(GoalIconandColorStatic.getImageName(widget.selectedGoal))),
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
                                        color: HexColor(GoalIconandColorStatic.getColorName(widget.selectedGoal)),
                                        shape: BoxShape.circle),
                              child: Padding(
                                  padding: EdgeInsets.all(0.9.w),
                                  child: Image.asset(GoalIconandColorStatic.getImageName(widget.selectedGoal))),
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
