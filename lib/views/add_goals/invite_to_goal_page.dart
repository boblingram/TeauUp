import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:teamup/controllers/GoalController.dart';
import 'package:teamup/mixins/baseClass.dart';

import '../../utils/GoalIconandColorStatic.dart';
import '../../utils/PermissionManager.dart';
import '../../utils/app_colors.dart';
import '../../widgets/CreateGoalMetaDataView.dart';
import 'invite_goals_page/group_goals_page.dart';
import 'invite_goals_page/individual_goals_page.dart';


class InviteToGoalPage extends StatefulWidget {
  final String selectedGoal;
  const InviteToGoalPage({Key? key, required this.selectedGoal}) : super(key: key);

  @override
  State<InviteToGoalPage> createState() => _InviteToGoalPageState();
}

class _InviteToGoalPageState extends State<InviteToGoalPage>
    with BaseClass, SingleTickerProviderStateMixin {
  TabController? controller;
  int _selectedTabValue = 0;

  final GoalController goalController = Get.find();

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                elevation: 0,
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.white,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CreateGoalMetaDataView(
                        showBack: true,
                          onPressed: () {
                            Get.back();
                          },
                          sliderText: "4/4",
                          sliderValue: 120,
                          goalMetaTitle: "Invite",
                          containerBackgroundColor: GoalIconandColorStatic.getColorName(
                              widget.selectedGoal),
                          goalMetaDescription:
                              "Do it alone or do it with a group. Invite\nmentor to guide you or invite friends to\ninspire you."),
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
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5),
                        /*boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                    ],*/
                      ),
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 5),
                      child: TabBar(
                        tabs: const [
                          Tab(
                            text: "Group Goals",
                          ),
                          Tab(
                            text: "Individual Goals",
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
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
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
          body: _selectedTabValue == 0 ? GroupGoalPage(selectedGoal: widget.selectedGoal) : IndividualGoalPage(selectedGoal: widget.selectedGoal)),
    );
  }
}
