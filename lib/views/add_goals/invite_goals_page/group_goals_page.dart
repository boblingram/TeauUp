import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quds_popup_menu/quds_popup_menu.dart';
import 'package:sizer/sizer.dart';
import 'package:teamup/mixins/baseClass.dart';
import 'package:teamup/models/IndividualGoalMemberModel.dart';
import 'package:teamup/views/add_goals/already_goal_created/goal_created_page.dart';

import '../../../controllers/GoalController.dart';
import '../../../utils/PermissionManager.dart';
import '../../../widgets/MultipleSelectContactView.dart';
import '../../../widgets/rounded_edge_button.dart';
import '../goal_confirm_create/confirm_and_create_goal_page.dart';

class GroupGoalPage extends StatefulWidget {
  GroupGoalPage({Key? key}) : super(key: key);

  @override
  State<GroupGoalPage> createState() => _GroupGoalPageState();
}

class _GroupGoalPageState extends State<GroupGoalPage> with BaseClass {
  var memberList = <IndividualGoalMemberModel?>[].obs;

  final GoalController goalController = Get.find();

  Map<String, bool> backupMemberMap = {};
  GlobalKey popupKey = GlobalKey();

  Future<void> _pickContact() async {
    final permissionManager = PermissionManager(context);

    var response = await permissionManager.askForPermissionAndNavigate(null);
    if (!response) {
      return;
    }

    List<Contact> contactList = await ContactsService.getContacts(
        withThumbnails: false,
        photoHighResolution: false,
        iOSLocalizedLabels: false,
        androidLocalizedLabels: false);
    var result = await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: true,
        elevation: 15,
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
                              const Icon(
                                Icons.people_alt_outlined,
                                color: Colors.black,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Add more members",
                                style: GoogleFonts.roboto(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                RoundedEdgeButton(
                    backgroundColor:
                        memberList.value.isEmpty ? Colors.grey : Colors.red,
                    text: "Next",
                    leftMargin: 20,
                    buttonRadius: 10,
                    rightMargin: 20,
                    bottomMargin: 20,
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
                Text(
                  "Invite members",
                  style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Invite your friends and encourage each other to push a little harder",
                  style: GoogleFonts.roboto(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
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
                                      child: const Center(
                                          child: Icon(Icons.person)),
                                    ),
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
                                            style: GoogleFonts.roboto(
                                                color: Colors.black,
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          memberItem?.mentor == null
                                              ? Container()
                                              : Text(
                                                  "Mentored by Saradhi",
                                                  style: GoogleFonts.roboto(
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
                                      key: popupKey,
                                      tooltip: 'T',
                                      items: getMenuItems(index),
                                      child: const Icon(
                                        Icons.keyboard_arrow_down_sharp,
                                        color: Colors.grey,
                                        size: 20,
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
                              const Icon(
                                Icons.people_outline,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Add members",
                                style: GoogleFonts.roboto(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
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
                        style: GoogleFonts.roboto(
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
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
    var backupValue = backupMemberMap[userId ?? ""] ?? false;

    print("Backup value is ${backupValue}");

    return [
      QudsPopupMenuItem(
          leading: const Icon(Icons.person),
          title: Text('Assign Mentor'),
          onPressed: () {
            //   showToast('Feedback Pressed!');
          }),
      QudsPopupMenuItem(
          leading: SizedBox(
            width: 50,
          ),
          title: Text('None'),
          onPressed: () {
            //   showToast('Feedback Pressed!');
          }),
      QudsPopupMenuItem(
          leading: SizedBox(
            width: 50,
          ),
          title: Text('Tarun'),
          onPressed: () {
            //   showToast('Feedback Pressed!');
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
                  onToggle: (val) async{
                    print("Updated Backup Value is $val");
                    Navigator.pop(context);
                    var tempId = "";
                    if(val){
                      tempId = userId;
                    }
                    var status = await goalController.mutationGoalMemberBackup(tempId);

                    if(!status){
                      showError(title: "Error", message: "Failed to Backup");
                      return;
                    }else{
                      if(val){
                        backupMemberMap[userId] = true;
                        showSuccess(title: "Success", message: "Backup Switched on");
                      }else{
                        backupMemberMap[userId] = false;
                        showSuccess(title: "Success", message: "Backup Switched off");
                      }
                    }
                    setState(() {

                    });
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
            var status =
                await goalController.mutationGoalMemberRemove(userId);
            if (status) {
              memberList.removeAt(index);
              showSuccess(
                  title: "Success", message: "Member Removed Successfully");
            } else {
              showError(title: "Error", message: "Failed to remove member");
            }
          }),
    ];
  }
}
