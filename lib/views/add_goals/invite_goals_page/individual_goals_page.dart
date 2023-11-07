import 'dart:developer';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:quds_popup_menu/quds_popup_menu.dart';
import 'package:sizer/sizer.dart';
import 'package:teamup/controllers/GoalController.dart';
import 'package:teamup/mixins/baseClass.dart';
import 'package:teamup/utils/Constants.dart';
import 'package:teamup/utils/GoalIconandColorStatic.dart';

import '../../../utils/PermissionManager.dart';
import '../../../widgets/MultipleSelectContactView.dart';
import '../../../widgets/rounded_edge_button.dart';
import '../already_goal_created/goal_created_page.dart';
import '../goal_confirm_create/confirm_and_create_goal_page.dart';

class IndividualGoalPage extends StatefulWidget {
  final String selectedGoal;
  const IndividualGoalPage({super.key, required this.selectedGoal});

  @override
  State<IndividualGoalPage> createState() => _IndividualGoalPageState();
}

class _IndividualGoalPageState extends State<IndividualGoalPage> with BaseClass {
  Contact? _contact;

  final GoalController goalController = Get.find();

  Future<void> _pickContact() async {

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
                    isSingleSelect: true,
                    selectedColor: HexColor(GoalIconandColorStatic.getColorName(widget.selectedGoal))
                ));
          });

      print("Single Select contact result ${result.runtimeType}");
      if (result != null) {
        log("Single Select Result is ${result}");
        if( result is Set){
          _contact = (result as Set<Contact>).first;
          var tempResult = await goalController.createIndividualMemberMutation(_contact!);
          if(tempResult){
            setState(() {});
          }
        }
      }

      /*final Contact? contact = await ContactsService.openDeviceContactPicker();
      print("Contact Selected is $contact");
      _contact = contact;
      if(contact != null){
        var result = await goalController.createIndividualMemberMutation(contact);
        if(result){
          setState(() {});
        }
      }else{

      }*/
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  void navigateToFinishpage() {
    pushToNextScreen(
        context: context, destination: GoalCreatedPage(selectedColor: selectedColor));
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
        child: Wrap(
          children: [
            _contact == null
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
                      "Change Mentor",
                      style: GoogleFonts.openSans(
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
                backgroundColor: _contact == null ? Colors.grey : selectedColor,
                text: "Next",
                leftMargin: 20,
                buttonRadius: 10,
                rightMargin: 20,
                bottomMargin: 20,
                onPressed: () {
                  if(_contact != null){
                    //Confirm and Create Goal Page is Removed as We are making mutation everytime
                    //ConfirmAndCreateGoalPage()
                    navigateToFinishpage();

                  }else{
                    showError(title: "Error", message: "Please select a mentor");
                  }
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
              "Invite Mentor",
              style: GoogleFonts.openSans(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "Work with a coach or a mentor to achieve this goal.",
              style: GoogleFonts.openSans(
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                  fontSize: 14),
            ),
            _contact == null
                ? const SizedBox(
              height: 15,
            )
                : Container(),
            _contact == null
                ? Container()
                : Expanded(
              child:Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 30,
                      width: 30,
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
                      child: Text(
                        _contact?.displayName ??
                            "",
                        style: GoogleFonts.openSans(
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _contact == null
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
                      "Invite Mentor",
                      style: GoogleFonts.openSans(
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
            _contact == null
                ? const SizedBox(
              height: 15,
            )
                : Container(),
            _contact == null
                ? InkWell(
                  onTap: (){
                    navigateToFinishpage();
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
              "Skip Inviting mentor, I would do this goal alone",
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                    color: Colors.red,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
              ),
            ),
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
