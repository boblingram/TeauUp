import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:quds_popup_menu/quds_popup_menu.dart';
import 'package:sizer/sizer.dart';
import 'package:teamup/mixins/baseClass.dart';
import 'package:teamup/models/IndividualGoalMemberModel.dart';
import 'package:teamup/utils/app_integers.dart';
import 'package:teamup/views/add_goals/already_goal_created/goal_created_page.dart';

import '../../../controllers/GoalController.dart';
import '../../../utils/GoalIconandColorStatic.dart';
import '../../../utils/PermissionManager.dart';
import '../../../utils/app_Images.dart';
import '../../../utils/app_colors.dart';
import '../../../widgets/MultipleSelectContactView.dart';
import '../../../widgets/rounded_edge_button.dart';
import '../../../utils/Constants.dart';

class GroupGoalPage extends StatefulWidget {
  final String selectedGoal;
  GroupGoalPage({Key? key, required this.selectedGoal}) : super(key: key);

  @override
  State<GroupGoalPage> createState() => _GroupGoalPageState();
}

class _GroupGoalPageState extends State<GroupGoalPage> with BaseClass {
  var memberList = <IndividualGoalMemberModel?>[].obs;

  final GoalController goalController = Get.find();

  String backupMemberID = "";

  Map<String, String> memberMentorMap = {};

  Future<void> _pickContact() async {
    final permissionManager = PermissionManager(context);

    var response = await permissionManager.askForPermissionAndNavigate(null);
    if (!response) {
      return;
    }

    showLoader(progressColor: GoalIconandColorStatic.getColorName(widget.selectedGoal));
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
    Contact selfContact = Contact(displayName: "${goalController.userName}",givenName: "self_selected",phones: [Item(value: "",label: "self")]);
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
                selectedColor: HexColor(GoalIconandColorStatic.getColorName(widget.selectedGoal))
              ));
        });

    print("Multi Select contact result ${result.runtimeType}");
    if (result != null) {
      var response = await goalController.createGroupGoalMemberMutation(result);
      if (response == null) {
        //_contact.value = [];
      } else {
        if (memberList.isEmpty) {
          memberList.value = response;
        } else {
          memberList.addAll(response);
        }

        print("Length of List is ${response.length}");
      }
    }
  }

  Color selectedColor = Colors.red;

  @override
  void initState() {
    selectedColor = HexColor(GoalIconandColorStatic.getColorName(widget.selectedGoal));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Obx(() => Wrap(
              children: [
                memberList.value.isEmpty
                    ? Container()
                    : InkWell(
                        onTap: () {
                          _pickContact();
                        },
                        child: Container(
                          height: 45,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey.shade400,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(AppImages.add_member_3Icon,height: 4.h,width: 4.h,),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Add more members",
                                style: GoogleFonts.openSans(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                RoundedEdgeButton(
                    backgroundColor:
                        memberList.value.isEmpty ? Colors.grey : selectedColor,
                    text: "Next",
                    leftMargin: 20,
                    buttonRadius: 10,
                    rightMargin: 20,
                    bottomMargin: 30,
                    onPressed: () {
                      if (memberList.value.isEmpty) {
                        showError(
                            title: "Error", message: "Please Select Members");
                        return;
                      }
                      //No Need for Confirm Create Goal Page
                      pushToNextScreen(
                          context: context, destination: GoalCreatedPage());
                    },
                    context: context),
              ],
            )),
      ),
      body: Obx(() => Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16,),
                Text(
                  "Invite members",
                  style: GoogleFonts.openSans(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 13.sp),
                ),
                const SizedBox(
                  height: 7,
                ),
                Text(
                  "Invite your friends and encourage each other to push a little harder",
                  style: GoogleFonts.openSans(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 11.5.sp),
                ),
                memberList.value.length == 0
                    ? const SizedBox(
                        height: 15,
                      )
                    : Container(),
                memberList.value.length == 0
                    ? Container()
                    : Expanded(
                        child: ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                            itemCount: memberList.value.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              var memberItem = memberList.elementAt(index);
                              return Container(
                                padding:  EdgeInsets.fromLTRB(
                                    0, 15, 0,10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(AppImages.user_white_icon, height: 17,width: 17,),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                memberItem?.fullname ?? "",
                                                style: GoogleFonts.openSans(
                                                    color: Colors.black,
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w400),
                                              ),
                                              memberItem?.mentor == null
                                                  ? Container()
                                                  : Text(
                                                      "Mentored by ${memberItem?.mentor?.fullname ?? ""}",
                                                      style: GoogleFonts.openSans(
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                            ],
                                          ),
                                        ),
                                        QudsPopupButton(
                                          // backgroundColor: Colors.red,
                                          tooltip: 'T',
                                          items: getMenuItems(index),
                                          child: Icon(
                                            Icons.keyboard_arrow_down_sharp,
                                            color: HexColor(AppColors.downArrowGrey),
                                            size: 24.sp,
                                          ),
                                        ),
                                        /*   IconButton(
                                      onPressed: () {

                                        );
                                      },
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down_sharp,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                    )*/
                                      ],
                                    ),
                                    Divider()
                                  ],
                                ),
                              );
                            }),
                      ),
                memberList.value.length == 0
                    ? InkWell(
                        onTap: () {
                          _pickContact();
                        },
                        child: Container(
                          height: 45,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey.shade400,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(AppImages.add_member_3Icon,height: 4.h,width: 4.h,),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Add members",
                                style: GoogleFonts.openSans(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                memberList.value.length == 0
                    ? const SizedBox(
                        height: 15,
                      )
                    : Container(),
                memberList.value.length == 0
                    ? Text(
                        "Note: After adding participants, you can select backup & mentors from the added participants",
                        style: GoogleFonts.openSans(
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                          fontSize: 11.5.sp,
                        ),
                      )
                    : Container(),
              ],
            ),
          )),
    );
  }

  List<QudsPopupMenuBase> getMenuItems(int index) {
    var userId = memberList.elementAt(index)?.id ?? "";

    var backupValue = backupMemberID == userId;

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
                  value: backupValue,
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
                        await goalController.mutationGoalMemberBackup(tempId);

                    if (!status) {
                      showError(title: "Error", message: "Failed to Backup");
                      return;
                    } else {
                      if (val) {
                        backupMemberID = userId;
                        showSuccess("Backup Switched on",selectedColor: AppColors.makeColorDarker(selectedColor, AppIntegers.colorDarkerValue));
                      } else {
                        backupMemberID = "";
                        showSuccess("Backup Switched off",selectedColor: AppColors.makeColorDarker(selectedColor, AppIntegers.colorDarkerValue));
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
            var status = await goalController.mutationGoalMemberRemove(userId);
            if (status) {
              memberList.removeAt(index);
              showSuccess("Member Removed Successfully",selectedColor: AppColors.makeColorDarker(selectedColor, AppIntegers.colorDarkerValue));
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
    var localMentorId = memberMentorMap[memberId] ?? "";
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
                      var shouldProceed = await goalController.mutationGoalMemberMentor(memberId, "");
                      if(shouldProceed){
                        memberMentorMap[memberId] = "";
                        memberList.elementAt(position)?.mentor = null;
                      }

                      setState(() {
                        Get.back();
                        showSuccess("Mentor Updated Successfully",selectedColor: AppColors.makeColorDarker(selectedColor, AppIntegers.colorDarkerValue));
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
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: memberList.length,
                    itemBuilder: (context, localPosition) {
                      var individualMember = memberList.elementAt(localPosition);
                      bool shouldMemberId =
                          (individualMember?.id ?? "") == localMentorId;
                      print("Local Mentor ID is $localMentorId & Selected Mentor Id is ${individualMember?.id}");

                      bool shouldShowMentor = memberId != (individualMember?.id ?? "");
                      return shouldShowMentor ? Container(
                        margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                        child: InkWell(
                          onTap: () async {
                            var shouldProceed = await goalController.mutationGoalMemberMentor(memberId, individualMember?.id);
                            print("Individual Member ${individualMember?.fullname}");
                            if(shouldProceed){
                              memberMentorMap[memberId] = individualMember?.id ?? "";
                              memberList.elementAt(position)?.mentor = individualMember;
                            }
                            setState(() {
                              Get.back();
                              showSuccess("Mentor Updated Successfully",selectedColor: AppColors.makeColorDarker(selectedColor, AppIntegers.colorDarkerValue));
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
              ],
            )),
          ],
        ),
      ],
    );
  }
}
