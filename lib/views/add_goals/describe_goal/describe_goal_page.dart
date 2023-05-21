import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teamup/controllers/goalController.dart';
import 'package:teamup/mixins/baseClass.dart';
import 'package:teamup/widgets/edittext_with_hint.dart';
import 'package:teamup/widgets/rounded_edge_button.dart';

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
  GoalController _goalController = Get.put(GoalController());

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
            Container(
              width: double.infinity,
              color: const Color(0xff589288),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      popToPreviousScreen(context: context);
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      margin: const EdgeInsets.only(top: 20),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
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
                  const SizedBox(
                    height: 25,
                  ),
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
                                  height: 20,
                                  width: 20,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
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
                          //popToPreviousScreen(context: context);
                          pickImage();
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
                      fontWeight: FontWeight.w700,
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
                            _goalController.goalNameController,
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
                      fontWeight: FontWeight.w700,
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
                            _goalController.goalDescriptionController,
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
                                  height: 20,
                                  width: 20,
                                  decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle),
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
                      )
                    ],
                  ),
                  GetBuilder<GoalController>(
                    init: _goalController,
                    builder: (snapshot) {
                      return RoundedEdgeButton(
                          backgroundColor: _goalController.goalNameController.text
                                      .trim()
                                      .isNotEmpty &&
                                  _goalController.goalDescriptionController.text
                                      .trim()
                                      .isNotEmpty
                              ? Colors.red
                              : Colors.grey,
                          text: "Next",
                          leftMargin: 0,
                          rightMargin: 0,
                          topMargin: 20,
                          buttonRadius: 5,
                          onPressed: () {
                            pushToNextScreen(
                                context: context,
                                destination: CreateGoalActivities());
                          },
                          context: context);
                    }
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
