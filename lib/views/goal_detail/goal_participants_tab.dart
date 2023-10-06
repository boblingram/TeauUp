import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quds_popup_menu/quds_popup_menu.dart';
import 'package:sizer/sizer.dart';
import 'package:teamup/controllers/VEGoalController.dart';
import 'package:teamup/mixins/baseClass.dart';
import 'package:teamup/models/IndividualGoalMemberModel.dart';

import '../../utils/app_colors.dart';

class GoalParticipantsTabPage extends StatefulWidget {
  const GoalParticipantsTabPage({super.key});

  @override
  State<GoalParticipantsTabPage> createState() => _GoalParticipantsTabPageState();
}

class _GoalParticipantsTabPageState extends State<GoalParticipantsTabPage> with BaseClass{
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
                    style: GoogleFonts.openSans(
                      color: AppColors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  Obx(()=>Text(
                    " ${veGoalController.selectedGoalMemberList.length}",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      color: AppColors.black,
                      fontSize: 18,
                    ),
                  ),)
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
                  itemCount: veGoalController.selectedGoalMemberList.length + 1,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    var item;
                    if(index < veGoalController.selectedGoalMemberList.length){
                      item = veGoalController.selectedGoalMemberList.elementAt(index);
                    }
                    return index == veGoalController.selectedGoalMemberList.length
                        ? addMoreWidget()
                        : getInvitedMembers(item, index);
                  })
                  : addMoreWidget()),
            )
          ],
        ),
      ),
    );
  }

  Widget addMoreWidget() {
    return InkWell(
      onTap: (){
        veGoalController.addMoreParticipants();
      },
      child: Container(
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
              style: GoogleFonts.openSans(
                  color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
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
                  style: GoogleFonts.openSans(
                      color: Colors.black,
                      fontWeight:
                      index == 0 ? FontWeight.w700 : FontWeight.w400),
                ),
                Text(
                  veGoalController.convertStringToNotNull(item.mentor).isEmpty ? "" :"You are mentored by ${veGoalController.convertStringToNotNull(item.mentor?.fullname)}",
                  style: GoogleFonts.openSans(
                      color: Colors.black,
                      fontWeight:
                      index == 0 ? FontWeight.w600 : FontWeight.w400),
                ),
              ],
            ),
          ),
          QudsPopupButton(
            // backgroundColor: Colors.red,
            tooltip: 'T',
            items: getMenuItems(index),
            child: const Icon(
              Icons.keyboard_arrow_down_sharp,
              color: Colors.grey,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }


  List<QudsPopupMenuBase> getMenuItems(int index) {
    var userId = veGoalController.selectedGoalMemberList.elementAt(index)?.id ?? "";
    var backupMemberID = veGoalController.userGoalPerInfo?.goalInfo.backup.toString() ?? "";

    return [
      QudsPopupMenuItem(
          leading: const Icon(Icons.person),
          title: Text('Assign Mentor'),
          onPressed: () {
            //   showToast('Feedback Pressed!');
            showMentorDialog(userId.toString(), index);
          }),
      QudsPopupMenuDivider(),
      QudsPopupMenuItem(
          leading: Icon(Icons.group),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Backup'),
              FlutterSwitch(
                  activeColor: Colors.red,
                  value: backupMemberID == userId,
                  height: 20,
                  toggleSize: 10,
                  width: 40,
                  onToggle: (val) async {
                    print("Updated Backup Value is $val");
                    Navigator.pop(context);
                    var tempId = "";
                    if (val) {
                      tempId = userId;
                    }
                    var status =
                    await veGoalController.mutationGoalMemberBackup(tempId);

                    if (!status) {
                      showError(title: "Error", message: "Failed to Backup");
                      return;
                    } else {
                      if (val) {
                        veGoalController.userGoalPerInfo?.goalInfo.backup = userId;
                        showSuccess(
                            title: "Success", message: "Backup Switched on");
                      } else {
                        veGoalController.userGoalPerInfo?.goalInfo.backup = "";
                        showSuccess(
                            title: "Success", message: "Backup Switched off");
                      }
                    }
                    setState(() {});
                  })
            ],
          ),
          onPressed: () {
            //   showToast('Feedback Pressed!');
          }),
      QudsPopupMenuDivider(),
      QudsPopupMenuItem(
          leading: Icon(Icons.remove_circle),
          title: Text('Remove'),
          onPressed: () async {
            var status = await veGoalController.mutationGoalMemberRemove(userId, index);
            if (status) {
              showSuccess(
                  title: "Success", message: "Member Removed Successfully");
            } else {
              showError(title: "Error", message: "Failed to remove member");
            }
          }),
    ];
  }

  void showMentorDialog(String memberId, int position) async {
    await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: true,
        elevation: 15,
        builder: (context) {
          return Container(
              height: 40.h,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: showMentorList(memberId, position));
        });
  }

  Widget showMentorList(String memberId, int position) {
    var localMentorId = veGoalController.selectedGoalMemberList.elementAt(position).mentor?.id ?? "";
    print("Element Position is $position");
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              height: 15.w,
              width: double.infinity,
              child: Stack(
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.cancel,
                      )),
                  Center(
                    child: Container(
                        margin:
                        EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        child: Text(
                          "Assign Mentor",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w700),
                        )),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                      child: InkWell(
                        onTap: () async {
                          var shouldProceed = await veGoalController.mutationGoalMemberMentor(memberId, "");
                          if(shouldProceed){
                            veGoalController.selectedGoalMemberList.elementAt(position).mentor = null;
                          }
                          setState(() {
                            Get.back();
                            showSuccess(title: "Success", message: "Mentor Updated Successfully");
                          });
                        },
                        child: Row(
                          children: [
                            localMentorId.isEmpty
                                ? Icon(
                              Icons.circle,
                              color: Colors.red,
                            )
                                : Icon(Icons.circle_outlined),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Text(
                                  "None",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: veGoalController.selectedGoalMemberList.length,
                          itemBuilder: (context, localPosition) {
                            var individualMember = veGoalController.selectedGoalMemberList.elementAt(localPosition);
                            bool shouldMemberId =
                                (individualMember?.id ?? "") == localMentorId;
                            print("Local Mentor ID is $localMentorId & Selected Mentor Id is ${individualMember?.id}");

                            bool shouldShowMentor = memberId != (individualMember?.id ?? "");
                            return shouldShowMentor ? Container(
                              margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                              child: InkWell(
                                onTap: () async {
                                  var shouldProceed = await veGoalController.mutationGoalMemberMentor(memberId, individualMember?.id);
                                  print("Individual Member ${individualMember?.fullname}");
                                  if(shouldProceed){
                                    veGoalController.selectedGoalMemberList.elementAt(position)?.mentor = individualMember;
                                  }
                                  setState(() {
                                    Get.back();
                                    showSuccess(title: "Success", message: "Mentor Updated Successfully");
                                  });
                                },
                                child: Row(
                                  children: [
                                    shouldMemberId
                                        ? Icon(
                                      Icons.circle,
                                      color: Colors.red,
                                    )
                                        : Icon(Icons.circle_outlined),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Text(
                                          "${individualMember?.fullname ?? ""}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ) : Container();
                          }),
                    ),
                  ],
                )),
          ],
        ),
      ],
    );
  }
}
