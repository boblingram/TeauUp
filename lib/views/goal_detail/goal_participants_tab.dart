import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teamup/controllers/VEGoalController.dart';
import 'package:teamup/models/IndividualGoalMemberModel.dart';

import '../../utils/app_colors.dart';

class GoalParticipantsTabPage extends StatelessWidget {
  GoalParticipantsTabPage({Key? key}) : super(key: key);

  final VEGoalController veGoalController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    "Participants:",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      color: AppColors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    " 6",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      color: AppColors.black,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade400),
              ),
              margin: const EdgeInsets.only(bottom: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child:
                  Obx(() => veGoalController.selectedGoalMemberList.isNotEmpty
                      ? ListView.builder(
                          itemCount: veGoalController.selectedGoalMemberList.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            var item = veGoalController.selectedGoalMemberList.elementAt(index);
                            return index == veGoalController.selectedGoalMemberList.length
                                ? addMoreWidget()
                                : getInvitedMembers(item, index);
                          })
                      : Container()),
            )
          ],
        ),
      ),
    );
  }

  Widget addMoreWidget() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          const Icon(
            Icons.add_circle,
            color: Colors.black,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            "Add more participants",
            style: GoogleFonts.roboto(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget getInvitedMembers(IndividualGoalMemberModel item, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 25,
            width: 25,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey),
            ),
            child: const Center(child: Icon(Icons.person)),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${item.fullname}",
                  style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontWeight:
                          index == 0 ? FontWeight.w700 : FontWeight.w400),
                ),
                Text(
                    veGoalController.convertStringToNotNull(item.mentor).isEmpty ? "" :"You are mentored by ${veGoalController.convertStringToNotNull(item.mentor)}",
                  style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontWeight:
                          index == 0 ? FontWeight.w600 : FontWeight.w400),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down_sharp,
            color: Colors.grey,
            size: 20,
          )
        ],
      ),
    );
  }
}
