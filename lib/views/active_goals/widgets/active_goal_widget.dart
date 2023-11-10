import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';
import 'package:teamup/controllers/VEGoalController.dart';
import 'package:teamup/mixins/baseClass.dart';
import 'package:teamup/models/GoalMetaDataModel.dart';
import 'package:teamup/utils/GoalIconandColorStatic.dart';
import 'package:teamup/utils/app_Images.dart';
import 'package:teamup/utils/app_strings.dart';
import 'package:teamup/views/goal_detail/goal_detail_page.dart';

import '../../../utils/app_colors.dart';

class ActiveGoalWidget extends StatelessWidget with BaseClass {
  final UserGoalPerInfo userGoalPerInfo;
  final int itemIndex;
  final VEGoalController veGoalController = Get.find();

  ActiveGoalWidget(
      {Key? key, required this.userGoalPerInfo, required this.itemIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Check if they are participants or not
    var createdBy = userGoalPerInfo.goalInfo.createdBy ?? "";
    var backup = userGoalPerInfo.goalInfo.backup ?? "";
    var loginUserId = veGoalController.userId;
    /*print(
        "Created By Id ${userGoalPerInfo.goalInfo.createdBy} && Backup Info ${userGoalPerInfo.goalInfo.backup}");
    print("Size of member is ${userGoalPerInfo.goalInfo.members?.length}");*/

    var editingEnabled = false;
    var isLoginUserAdmin = false;
    var isLoginUserParticipant = false;
    var isLoginUserMentor = false;
    var sizeOfMembers = 0;
    var sizeOfMentors = 0;
    if (loginUserId == createdBy || loginUserId == backup) {
      isLoginUserAdmin = true;
      editingEnabled = true;
    }

    if (userGoalPerInfo.goalInfo.members != null) {
      //Check whether user exists in participants or not?
      sizeOfMembers = userGoalPerInfo.goalInfo.members!.length;
      var tempParticipantData = userGoalPerInfo.goalInfo.members!
          .firstWhereOrNull((element) => element.userId == loginUserId);
      var tempMentorData = userGoalPerInfo.goalInfo.members!
          .firstWhereOrNull((element) => element.mentorId == loginUserId);

      var usersWithMentorId24 = userGoalPerInfo.goalInfo.members!
          .where((userMentor) => userMentor.mentorId == loginUserId)
          .toList();

      sizeOfMentors = usersWithMentorId24.length;

      if (tempParticipantData != null) {
        isLoginUserParticipant = true;
      }

      if (tempMentorData != null) {
        isLoginUserMentor = true;
      }
    }

    return InkWell(
      onTap: () {
        pushToNextScreen(
          context: context,
          destination: GoalDetailPage(
            userGoalPerInfo: userGoalPerInfo,
            itemIndex: itemIndex,
            isEditingEnabled: editingEnabled,
            showJourney: (isLoginUserAdmin && !isLoginUserParticipant),
          ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Container(
                    height: 11.w,
                    width: 11.w,
                    decoration: BoxDecoration(
                      color: HexColor(GoalIconandColorStatic.getColorName(
                          userGoalPerInfo.goalInfo.type ?? "Custom")),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(1.w),
                        child: Image.asset(GoalIconandColorStatic.getImageName(
                            userGoalPerInfo.goalInfo.type ?? "Custom"))),
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
                          style: GoogleFonts.openSans(
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
                              style: GoogleFonts.openSans(
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
                      style: GoogleFonts.openSans(color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: (isLoginUserAdmin && !isLoginUserParticipant)
                  ? AccessoryTextActiveGoalWidget(
                      text: "$sizeOfMembers members participating in this goal")
                  : (isLoginUserMentor && !isLoginUserParticipant)
                      ? AccessoryTextActiveGoalWidget(
                  text: "$sizeOfMentors participants mentored by you.")
                      : Row(
                          children: [
                            Expanded(
                              child: IndividualDetailsActiveGoalWidget(
                                textToShow:
                                    "${userGoalPerInfo.perInfo.totalDays ?? "0"} days spent",
                                assetStringName: AppImages.weekly_GIcon,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: IndividualDetailsActiveGoalWidget(
                                textToShow:
                                    "${userGoalPerInfo.perInfo.mainStreak ?? "0"} days streak",
                                assetStringName: AppImages.streak_GIcon,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: IndividualDetailsActiveGoalWidget(
                                textToShow:
                                    "${userGoalPerInfo.perInfo.totalXP ?? "0"} xp points",
                                assetStringName: AppImages.star_GIcon,
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
                  style: GoogleFonts.openSans(
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

class IndividualDetailsActiveGoalWidget extends StatelessWidget {
  final String textToShow;
  final String assetStringName;

  const IndividualDetailsActiveGoalWidget(
      {super.key, required this.textToShow, required this.assetStringName});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.greyWithShade300,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Image(
              image: AssetImage(assetStringName),
              height: 12,
              width: 12,
            ),
          ),
          Expanded(
            child: Text(
              textToShow,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.openSans(color: AppColors.black, fontSize: 12),
              maxLines: 1,
            ),
            flex: 4,
          ),
        ],
      ),
    );
  }
}

class AccessoryTextActiveGoalWidget extends StatelessWidget {
  final String text;

  const AccessoryTextActiveGoalWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(13.w, 0, 0, 0),
      child: Text(text),
    );
  }
}
