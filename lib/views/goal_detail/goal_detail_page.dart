import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:teamup/controllers/GoalDetailController.dart';
import 'package:teamup/controllers/VEGoalController.dart';
import 'package:teamup/mixins/baseClass.dart';
import 'package:teamup/views/goal_detail/goal_participants_tab.dart';

import '../../utils/app_Images.dart';
import '../../utils/app_colors.dart';
import '../../widgets/rounded_edge_button.dart';
import 'goal_activity_tab.dart';

class GoalDetailPage extends StatefulWidget {
  final String goalId;
  const GoalDetailPage({Key? key, required this.goalId}) : super(key: key);

  @override
  State<GoalDetailPage> createState() => _GoalDetailPageState();
}

class _GoalDetailPageState extends State<GoalDetailPage>
    with BaseClass, SingleTickerProviderStateMixin {
  TabController? controller;
  int _selectedTabValue = 0;

  GoalDetailController goalDetailController = Get.put(GoalDetailController());

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);

    goalDetailController.updateGoalId(widget.goalId);
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
                backgroundColor: AppColors.goalAppBarColor,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        color: const Color(0xff589288),
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
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white,
                                      ),
                                      shape: BoxShape.circle),
                                  child: const Center(
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                  ),
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
                              "Study",
                              style: GoogleFonts.roboto(
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
                                Text(
                                  "Practice Maths",
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 23,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                InkWell(
                                  onTap: (){
                                    goalDetailController.editGoalNDSheet();
                                  },
                                  child: Text(
                                    "Edit",
                                    style: GoogleFonts.roboto(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "Goal set by: Saradhi (You)",
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              "This goal helps participants to know\nwhat they can achieve by this goal. We\nhave prefilled a default description\nbased on your goal selection. You can\nedit this or create your own description",
                              style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16),
                            ),
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
              ? GoalActivityTabPage()
              : _selectedTabValue == 1
                  ? const GoalParticipantsTabPage()
                  : Container()),
    );
  }
}
