import 'dart:developer';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:quds_popup_menu/quds_popup_menu.dart';
import 'package:sizer/sizer.dart';
import 'package:teamup/controllers/VEGoalController.dart';
import 'package:teamup/mixins/baseClass.dart';
import 'package:teamup/models/IndividualGoalMemberModel.dart';
import 'package:teamup/utils/app_integers.dart';
import 'package:teamup/utils/app_strings.dart';

import '../../utils/Constants.dart';
import '../../utils/GoalIconandColorStatic.dart';
import '../../utils/PermissionManager.dart';
import '../../utils/app_colors.dart';
import '../../widgets/MultipleSelectContactView.dart';

class GoalParticipantsTabPage extends StatefulWidget {
  final bool isEditingEnabled;
  const GoalParticipantsTabPage({super.key, required this.isEditingEnabled});

  @override
  State<GoalParticipantsTabPage> createState() => _GoalParticipantsTabPageState();
}

class _GoalParticipantsTabPageState extends State<GoalParticipantsTabPage> with BaseClass{
  final VEGoalController veGoalController = Get.find();

  var selectedGoal = AppStrings.defaultGoalType;
  Color selectionColor = Colors.red;

  @override
  void initState() {
    super.initState();
    selectedGoal = veGoalController.userGoalPerInfo?.goalInfo.type ?? AppStrings.defaultGoalType;
    selectionColor = HexColor(GoalIconandColorStatic.getColorName(selectedGoal));
    print("Selected Goal Type is ${veGoalController.userGoalPerInfo?.goalInfo.type}");
  }

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
    return widget.isEditingEnabled ? InkWell(
      onTap: (){
        veGoalController.addMoreParticipants(selectedColor : selectionColor);
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
    ) : Container();
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
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  veGoalController.convertStringToNotNull(item.mentor).isEmpty ? "" :"Mentored by ${veGoalController.convertStringToNotNull(item.mentor?.fullname)}",
                  style: GoogleFonts.openSans(
                      color: Colors.black,
                      fontWeight:
                      index == 0 ? FontWeight.w600 : FontWeight.w400),
                ),
              ],
            ),
          ),
          widget.isEditingEnabled ? QudsPopupButton(
            // backgroundColor: Colors.red,
            tooltip: 'T',
            items: getMenuItems(index),
            child: const Icon(
              Icons.keyboard_arrow_down_sharp,
              color: Colors.grey,
              size: 20,
            ),
          ) : Container(),
        ],
      ),
    );
  }


  List<QudsPopupMenuBase> getMenuItems(int index) {
    var participantsId = veGoalController.selectedGoalMemberList.elementAt(index)?.id ?? "";
    var backupMemberID = veGoalController.userGoalPerInfo?.goalInfo.backup.toString() ?? "";

    var mentorId = veGoalController.selectedGoalMemberList.elementAt(index).mentor?.id;

    bool showJourneyOption = false;

    print("Mentor Id is ${mentorId} and User Id is ${veGoalController.userId}");
    if(mentorId != null && mentorId == veGoalController.userId){
      showJourneyOption = true;
    }

    return [
      QudsPopupMenuItem(
          leading: const Icon(Icons.person),
          title: Text('Assign Mentor'),
          onPressed: () {
            //   showToast('Feedback Pressed!');
            showMentorDialog(participantsId.toString(), index);
          }),
      QudsPopupMenuDivider(),
      QudsPopupMenuItem(
          leading: Icon(Icons.group),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Backup'),
              FlutterSwitch(
                  activeColor: selectionColor,
                  value: backupMemberID == participantsId,
                  height: 20,
                  toggleSize: 10,
                  width: 40,
                  onToggle: (val) async {
                    print("Updated Backup Value is $val");
                    Navigator.pop(context);
                    var tempId = "";
                    if (val) {
                      tempId = participantsId;
                    }
                    var status =
                    await veGoalController.mutationGoalMemberBackup(tempId);

                    if (!status) {
                      showError(title: "Error", message: "Failed to Backup");
                      return;
                    } else {
                      if (val) {
                        veGoalController.userGoalPerInfo?.goalInfo.backup = participantsId;
                        showSuccess(
                            title: "Success", message: "Backup Switched on",backgroundColor: AppColors.makeColorDarker(selectionColor, AppIntegers.colorDarkerValue));
                      } else {
                        veGoalController.userGoalPerInfo?.goalInfo.backup = "";
                        showSuccess(
                            title: "Success", message: "Backup Switched off",backgroundColor: AppColors.makeColorDarker(selectionColor, AppIntegers.colorDarkerValue));
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
            var status = await veGoalController.mutationGoalMemberRemove(participantsId, index);
            if (status) {
              showSuccess(
                  title: "Success", message: "Member Removed Successfully",backgroundColor: AppColors.makeColorDarker(selectionColor, AppIntegers.colorDarkerValue));
            } else {
              showError(title: "Error", message: "Failed to remove member");
            }
          }),
      QudsPopupMenuDivider(),
      showJourneyOption ? QudsPopupMenuItem(
          leading: Icon(Icons.calendar_month),
          title: Text('Jounery'),
          onPressed: () async {
            veGoalController.showJourneyBottomSheet(participantId: participantsId);
          }) : QudsPopupMenuDivider(),
    ];
  }

  void showMentorDialog(String memberId, int position) async {
    final permissionManager = PermissionManager(context);

    var response = await permissionManager.askForPermissionAndNavigate(null);
    if(!response){
      return;
    }

    try {
      //Show Single Select
      showPLoader();
      List<Contact> contactList = await ContactsService.getContacts(
          withThumbnails: false,
          photoHighResolution: false,
          iOSLocalizedLabels: false,
          androidLocalizedLabels: false);

      //await Future.delayed(Duration(seconds: 5));
      hidePLoader();
      final AnimationController controller = AnimationController(
        vsync: Navigator.of(context),
        duration: Duration(milliseconds: 500),
      );

      //Add Me
      Contact selfContact = Contact(displayName: "${veGoalController.userName}",givenName: "self_selected",phones: [Item(value: "",label: "self")]);
      contactList.insert(0, selfContact);
      var result = await showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          isDismissible: true,
          elevation: 15,
          transitionAnimationController: controller,
          builder: (context) {
            return Container(
                height: 80.h,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: MultiSelectContacts(
                    contactsList: contactList,
                    staticText: "Add Mentor",
                    isSingleSelect: true,
                    selectedColor: HexColor(GoalIconandColorStatic.getColorName(selectedGoal))
                ));
          });

      print("Single Select contact result ${result.runtimeType}");
      if (result != null) {
        log("Single Select Result is ${result}");
        if( result is Set){
          print("Selected Contact is ${(result as Set<Contact>).first.displayName}");
          var name = (result as Set<Contact>).first.displayName ?? "";
          var phone = (result as Set<Contact>).first.phones?.first.value ?? "";
          var givenName = (result as Set<Contact>).first.givenName ?? "";
          var tempNetworkResult = await veGoalController.mutationGoalMemberMentorV1(memberId,name,phone, givenName);
          if(tempNetworkResult != null){
            print("Mentor Id is $tempNetworkResult");
            veGoalController.selectedGoalMemberList.elementAt(position)?.mentor = IndividualGoalMemberModel(fullname: name,id: tempNetworkResult);
            setState(() {

            });
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }

    print("Element Position is $position");

/*    await showModalBottomSheet(
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
        });*/
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
                            showSuccess(title: "Success", message: "Mentor Updated Successfully",backgroundColor: AppColors.makeColorDarker(selectionColor, AppIntegers.colorDarkerValue));
                          });
                        },
                        child: Row(
                          children: [
                            localMentorId.isEmpty
                                ? Icon(
                              Icons.circle,
                              color: selectionColor,
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
                                    showSuccess(title: "Success", message: "Mentor Updated Successfully",backgroundColor: AppColors.makeColorDarker(selectionColor, AppIntegers.colorDarkerValue));
                                  });
                                },
                                child: Row(
                                  children: [
                                    shouldMemberId
                                        ? Icon(
                                      Icons.circle,
                                      color: selectionColor,
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
