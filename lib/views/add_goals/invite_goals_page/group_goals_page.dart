import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quds_popup_menu/quds_popup_menu.dart';
import 'package:sizer/sizer.dart';
import 'package:teamup/mixins/baseClass.dart';
import 'package:teamup/views/add_goals/already_goal_created/goal_created_page.dart';

import '../../../controllers/GoalController.dart';
import '../../../widgets/MultipleSelectContactView.dart';
import '../../../widgets/rounded_edge_button.dart';
import '../goal_confirm_create/confirm_and_create_goal_page.dart';

class GroupGoalPage extends StatefulWidget {
  GroupGoalPage({Key? key}) : super(key: key);

  @override
  State<GroupGoalPage> createState() => _GroupGoalPageState();
}

class _GroupGoalPageState extends State<GroupGoalPage> with BaseClass {
  List<Contact?> _contact = [];

  final GoalController goalController = Get.find();

  Future<void> _pickContact() async {

          List<Contact> contactList = await ContactsService.getContacts(withThumbnails: false,photoHighResolution: false,iOSLocalizedLabels: false,androidLocalizedLabels: false);
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
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                    ),
                    child: MultiSelectContacts(contactsList: contactList,));
              });
          print("Multi Select contact result ${result.runtimeType}");
          if(result != null){
            _contact = result;
            var response = await goalController.createGroupGoalMemberMutation(_contact);
            if(!response){
              _contact = [];
            }
            setState(() {

            });
          }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Wrap(
          children: [
            _contact.isEmpty
                ? Container()
                : InkWell(
                    onTap: () {
                      _pickContact();
                    },
                    child: Container(
                      height: 45,
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                backgroundColor: _contact.isEmpty ?  Colors.grey : Colors.red,
                text: "Next",
                leftMargin: 20,
                buttonRadius: 10,
                rightMargin: 20,
                bottomMargin: 20,
                onPressed: () {
                  if( _contact.isEmpty){
                    showError(title: "Error", message: "Please Select Members");
                    return;
                  }
                  //No Need for Confirm Create Goal Page
                  pushToNextScreen(
                      context: context, destination: GoalCreatedPage());
                },
                context: context),
          ],
        ),
      ),
      body: Container(
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
            _contact.length == 0
                ? const SizedBox(
                    height: 15,
                  )
                : Container(),
            _contact.length == 0
                ? Container()
                : Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        itemCount: _contact.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
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
                                  child:
                                      const Center(child: Icon(Icons.person)),
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
                                        _contact
                                                .elementAt(index)
                                                ?.displayName ??
                                            "",
                                        style: GoogleFonts.roboto(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        "Mentored by Saradhi",
                                        style: GoogleFonts.roboto(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                            QudsPopupButton(
                              // backgroundColor: Colors.red,
                              tooltip: 'T',
                              items: getMenuItems(),
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
            _contact.length == 0
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
            _contact.length == 0
                ? const SizedBox(
                    height: 15,
                  )
                : Container(),
            _contact.length == 0
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
      ),
    );
  }

  List<QudsPopupMenuBase> getMenuItems() {
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
      QudsPopupMenuItem(
          leading: SizedBox(
            width: 50,
          ),
          title: Text('Jatin'),
          onPressed: () {
            //   showToast('Feedback Pressed!');
          }),
      QudsPopupMenuItem(
          leading: SizedBox(
            width: 50,
          ),
          title: Text('Srihar'),
          onPressed: () {
            //   showToast('Feedback Pressed!');
          }),

      QudsPopupMenuDivider(),
      QudsPopupMenuItem(
          leading: Icon(Icons.person),
          title: Text('Backup'),
          onPressed: () {
            //   showToast('Feedback Pressed!');
          }),
      QudsPopupMenuDivider(),
      QudsPopupMenuItem(
          leading: Icon(Icons.remove_circle),
          title: Text('Remove'),
          onPressed: () {
            //   showToast('Feedback Pressed!');
          }),
    ];
  }
}
