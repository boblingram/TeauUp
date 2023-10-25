import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';
import 'package:teamup/controllers/VEGoalController.dart';
import 'package:teamup/mixins/baseClass.dart';
import 'package:teamup/utils/GoalIconandColorStatic.dart';
import 'package:teamup/utils/app_strings.dart';
import 'package:teamup/views/goal_detail/goal_participants_tab.dart';
import 'package:teamup/views/journey_views/journey_view.dart';

import '../../models/GoalMetaDataModel.dart';
import '../../utils/app_Images.dart';
import '../../utils/app_colors.dart';
import '../../widgets/rounded_edge_button.dart';
import 'goal_activity_tab.dart';

class GoalDetailPage extends StatefulWidget {
  final UserGoalPerInfo userGoalPerInfo;
  final bool isEditingEnabled;
  final int itemIndex;
  const GoalDetailPage({Key? key, required this.userGoalPerInfo, this.isEditingEnabled = true, required this.itemIndex}) : super(key: key);

  @override
  State<GoalDetailPage> createState() => _GoalDetailPageState();
}

class _GoalDetailPageState extends State<GoalDetailPage>
    with BaseClass, SingleTickerProviderStateMixin {
  TabController? controller;
  int _selectedTabValue = 0;

  VEGoalController veGoalController = Get.put(VEGoalController());

  String createdByName = "";
  String localGoalType = AppStrings.defaultGoalType;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);

    veGoalController.updateGoalId(widget.userGoalPerInfo.goalInfo.id.toString());
    veGoalController.updateUserGoalPerInfo(widget.userGoalPerInfo);
    veGoalController.updateSelectedItemIndex(widget.itemIndex);

    if(widget.userGoalPerInfo.goalInfo.createdByName != null){
      createdByName = widget.userGoalPerInfo.goalInfo.createdByName.toString().trim();
    }

    localGoalType = widget.userGoalPerInfo.goalInfo.type ?? AppStrings.defaultGoalType;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {fetchGoalDetailData();});
  }

  void fetchGoalDetailData(){
    //String goalId = "1";
    String goalId = veGoalController.goalId;
    veGoalController.getGoalActivitiesData(goalId);
    veGoalController.getGoalMembershipData(goalId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                elevation: 0,
                automaticallyImplyLeading: true,
                backgroundColor: HexColor(GoalIconandColorStatic.getColorName(localGoalType)),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        color: HexColor(GoalIconandColorStatic.getColorName(localGoalType)),
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /*InkWell(
                            onTap: () {
                              popToPreviousScreen(context: context);
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              margin: const EdgeInsets.only(top: 20),
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),*/
                            SizedBox(
                              height: 11.h,
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 11.w,
                                  width: 11.w,
                                  decoration: BoxDecoration(
                                    color: HexColor(GoalIconandColorStatic.getColorName(widget.userGoalPerInfo.goalInfo.type ?? AppStrings.defaultGoalType)),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                      padding: EdgeInsets.all(1.w),
                                      child: Image.asset(GoalIconandColorStatic.getImageName(widget.userGoalPerInfo.goalInfo.type ?? AppStrings.defaultGoalType))),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                /*const Icon(
                                  Icons.keyboard_arrow_down_sharp,
                                  color: Colors.white,
                                  size: 15,
                                )*/
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "${widget.userGoalPerInfo.goalInfo.type ?? AppStrings.defaultGoalType}",
                              style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                wordSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(()=>Text(
                                  veGoalController.goalName.value,
                                  style: GoogleFonts.openSans(
                                    color: Colors.white,
                                    fontSize: 23,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),),
                                widget.isEditingEnabled ? InkWell(
                                  onTap: (){
                                    veGoalController.editGoalNDSheet(selectedColor: HexColor(GoalIconandColorStatic.getColorName(localGoalType)));
                                  },
                                  child: Text(
                                    "Edit",
                                    style: GoogleFonts.openSans(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ) : Container(),
                              ],
                            ),
                            createdByName.isNotEmpty ? Text(
                              "Goal set by: $createdByName",
                              style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ) : Container(),
                            const SizedBox(
                              height: 15,
                            ),
                            Obx(()=>Text(
                              veGoalController.goalDesc.value,
                              style: GoogleFonts.openSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16),
                            ),)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                expandedHeight: getScreenHeight(context) * 0.45,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(56),
                  child: Container(
                    color: Colors.white,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          //border: Border.all(color: Colors.white),
                          color: Colors.grey.shade300),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: TabBar(
                        tabs: const [
                          Tab(
                            text: "Activities",
                          ),
                          Tab(
                            text: "Participants",
                          ),
                          Tab(
                            text: "Journey",
                          ),
                          //  Tab(icon: Icon(Icons.directions_bike)),
                        ],
                        controller: controller,
                        labelStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700),
                        unselectedLabelStyle: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w500),
                        unselectedLabelColor: Colors.black,
                        indicatorColor: Colors.transparent,
                        indicator: BoxDecoration(
                            borderRadius: _selectedTabValue == 0
                                ? BorderRadius.circular(5)
                                : BorderRadius.circular(5),
                            color: Colors.white),
                        labelColor: Colors.black,
                        onTap: (value) {
                          setState(() {
                            _selectedTabValue = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              )
            ];
          },
          body: _selectedTabValue == 0
              ? GoalActivityTabPage(isEditingEnabled: widget.isEditingEnabled, localGoalType: localGoalType)
              : _selectedTabValue == 1
              ? GoalParticipantsTabPage()
              : Journey_View(isGoalTab: true,goalId: veGoalController.goalId,)),
    );
  }
}
