import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamup/controllers/VEGoalController.dart';
import 'package:teamup/utils/app_strings.dart';
import 'package:teamup/views/active_goals/active_goals_page.dart';

import '../utils/app_colors.dart';
import 'end_goal/end_goal_page.dart';

class GoalView extends StatefulWidget {
  const GoalView({Key? key}) : super(key: key);

  @override
  State<GoalView> createState() => _GoalViewState();
}

class _GoalViewState extends State<GoalView> {
  int _selectedTabValue = 0;

  VEGoalController veGoalController = Get.find();

  @override
  void initState() {
    super.initState();
    //veGoalController.createGoalMutation("Cycling", "Goal2", "Description1");
    veGoalController.getAEGoal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: DefaultTabController(
          length: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  //border: Border.all(color: AppColors.white),
                  color: AppColors.greyWithShade300,
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: TabBar(
                  tabs: const [
                    Tab(
                      text: AppStrings.activeGoals,
                    ),
                    Tab(
                      text: AppStrings.endedGoals,
                    ),
                    //  Tab(icon: Icon(Icons.directions_bike)),
                  ],
                  labelStyle: const TextStyle(
                      color: AppColors.black, fontWeight: FontWeight.w700),
                  unselectedLabelStyle: const TextStyle(
                      color: AppColors.darkGrey, fontWeight: FontWeight.w500),
                  unselectedLabelColor: AppColors.black,
                  indicatorColor: AppColors.transparent,
                  indicator: BoxDecoration(
                      borderRadius: _selectedTabValue == 0
                          ? BorderRadius.circular(5)
                          : BorderRadius.circular(5),
                      color: AppColors.white),
                  labelColor: AppColors.black,
                  onTap: (value) {
                    setState(() {
                      _selectedTabValue = value;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                flex: 1,
                child: TabBarView(
                  children: [
                    ActiveGoalsPage(),
                    EndGoalPage()
                    //   Icon(Icons.directions_bike),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
