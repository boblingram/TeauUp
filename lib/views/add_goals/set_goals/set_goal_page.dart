import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';
import 'package:teamup/mixins/baseClass.dart';
import 'package:teamup/utils/GoalIconandColorStatic.dart';
import 'package:teamup/utils/app_Images.dart';
import 'package:teamup/utils/app_colors.dart';
import 'package:teamup/widgets/CreateGoalMetaDataView.dart';

import '../describe_goal/describe_goal_page.dart';

class SetGoalPage extends StatelessWidget with BaseClass {
  SetGoalPage({Key? key}) : super(key: key);


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
                itemCount: GoalIconandColorStatic.goalList.length,
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
                          selectedGoal: GoalIconandColorStatic.goalList.elementAt(index),
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
                            color: HexColor(GoalIconandColorStatic.goalColorList.elementAt(index)),
                            shape: BoxShape.circle,
                          ),
                          child: GoalIconandColorStatic.goalList.elementAt(index) == "Custom"
                              ? Icon(
                                  Icons.add,
                                  size: 12.w,
                                  color: Colors.white,
                                )
                              : Padding(
                                  padding: EdgeInsets.all(4.w),
                                  child: Image.asset(
                                      GoalIconandColorStatic.getImageName(GoalIconandColorStatic.goalList.elementAt(index)))),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          GoalIconandColorStatic.goalList.elementAt(index),
                          style: GoogleFonts.roboto(
                            color: HexColor(GoalIconandColorStatic.goalColorList.elementAt(index)),
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
}
