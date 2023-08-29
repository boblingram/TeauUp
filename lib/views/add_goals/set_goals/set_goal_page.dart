import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';
import 'package:teamup/mixins/baseClass.dart';
import 'package:teamup/utils/app_Images.dart';
import 'package:teamup/utils/app_colors.dart';
import 'package:teamup/widgets/CreateGoalMetaDataView.dart';

import '../describe_goal/describe_goal_page.dart';

class SetGoalPage extends StatelessWidget with BaseClass {
  SetGoalPage({Key? key}) : super(key: key);
  final List<String> goalList = [
    "Wellness",
    "Yoga",
    "Study",
    "Cycling",
    "Running",
    "Walking",
    "Gym",
    "Introspection",
    "Custom"
  ];

  final List<String> goalColorList = [
    AppColors.wellnessIconBG,
    AppColors.yogaIconBG,
    AppColors.studyIconBG,
    AppColors.cyclingIconBG,
    AppColors.runningIconBG,
    AppColors.walkingIconBG,
    AppColors.gymIconBG,
    AppColors.introspectionIconBG,
    AppColors.customIconBG
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CreateGoalMetaDataView(
              onPressed: () {
                popToPreviousScreen(context: context);
              },
              showWelcome: true,
              sliderText: "1/4",
              sliderValue: 30,
              sliderColor: HexColor(AppColors.sliderColor),
              goalMetaTitle: "Set a Goal",
              goalMetaDescription:
                  "Choose a goal from a list below to\nstart. You can create your own goal if\nyou are not able to find one in the list\nbelow."),
          Expanded(
            child: Container(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
                itemCount: goalList.length,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 15),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      pushToNextScreen(
                        context: context,
                        destination: DescribeGoalPage(
                          selectedGoal: goalList.elementAt(index),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 9.h,
                          width: 9.h,
                          decoration: BoxDecoration(
                            color: HexColor(goalColorList.elementAt(index)),
                            shape: BoxShape.circle,
                          ),
                          child: goalList.elementAt(index) == "Custom"
                              ? Icon(
                                  Icons.add,
                                  size: 12.w,
                                  color: Colors.white,
                                )
                              : Padding(
                                  padding: EdgeInsets.all(4.w),
                                  child: Image.asset(
                                      getImageName(goalList.elementAt(index)))),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          goalList.elementAt(index),
                          style: GoogleFonts.roboto(
                            color: HexColor(goalColorList.elementAt(index)),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getImageName(String elementAt) {
    switch (elementAt) {
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
}
