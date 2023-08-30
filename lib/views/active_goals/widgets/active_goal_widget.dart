import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';
import 'package:teamup/mixins/baseClass.dart';
import 'package:teamup/models/GoalActivityModel.dart';
import 'package:teamup/utils/app_Images.dart';
import 'package:teamup/utils/app_strings.dart';
import 'package:teamup/views/goal_detail/goal_detail_page.dart';

import '../../../utils/app_colors.dart';

class ActiveGoalWidget extends StatelessWidget with BaseClass {

  final UserGoalPerInfo userGoalPerInfo;
  const ActiveGoalWidget({Key? key, required this.userGoalPerInfo}) : super(key: key);

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
    return InkWell(
      onTap: () {
        pushToNextScreen(
          context: context,
          destination: GoalDetailPage(goalId: userGoalPerInfo.goalInfo.id.toString(),),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.greyWithShade300,
            ),
            borderRadius: BorderRadius.circular(5)),
        margin: const EdgeInsets.only(bottom: 15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Container(
                    height: 11.w,
                    width: 11.w,
                    decoration: BoxDecoration(
                      color: HexColor(getColorName(userGoalPerInfo.goalInfo.type ?? "Custom")),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(1.w),
                        child: Image.asset(getImageName(userGoalPerInfo.goalInfo.type ?? "Custom"))),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${userGoalPerInfo.goalInfo.name}",
                          style: GoogleFonts.roboto(
                              color: AppColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        /*Row(
                          children: [
                            Container(
                              height: 8,
                              width: 8,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: AppColors.green),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              AppStrings.nextActivityInOneHour,
                              style: GoogleFonts.roboto(
                                  color: AppColors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),*/
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(15)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Text(
                      AppStrings.view,
                      style: GoogleFonts.roboto(color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.greyWithShade300,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage(AppImages.shareIcon),
                            height: 12,
                            width: 12,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${userGoalPerInfo.perInfo.totalDays ?? "0"} Rank",
                            style: GoogleFonts.roboto(
                              color: AppColors.black,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.greyWithShade300,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage(AppImages.shareIcon),
                            height: 12,
                            width: 12,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${userGoalPerInfo.perInfo.mainStreak ?? "0"} days streak",
                            style: GoogleFonts.roboto(
                                color: AppColors.black, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.greyWithShade300,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage(AppImages.shareIcon),
                            height: 12,
                            width: 12,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${userGoalPerInfo.perInfo.totalXP ?? "0"} xp points",
                            style: GoogleFonts.roboto(
                                color: AppColors.black, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            /*Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.prupleWithShade300,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: Center(
                child: Text(
                  "We generate fear when we do nothing. We overcome those fears by taking actions",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    color: AppColors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )*/
          ],
        ),
      ),
    );
  }
}
