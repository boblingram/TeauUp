import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamup/controllers/VEGoalController.dart';
import 'package:teamup/utils/app_strings.dart';

import 'widgets/active_goal_widget.dart';

class ActiveGoalsPage extends StatelessWidget {
  ActiveGoalsPage({Key? key}) : super(key: key);

  VEGoalController veGoalController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppStrings.yourGoals, style: TextStyle(fontWeight: FontWeight.w400),),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Obx(()=>veGoalController.activeGoalList.isNotEmpty ? ListView.builder(
                itemCount: veGoalController.activeGoalList.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  var item = veGoalController.activeGoalList.elementAt(index);
                  return ActiveGoalWidget(userGoalPerInfo: item,);
                }) : Text("Active Goal List is Empty")),
          ),
        ],
      ),
    );
  }
}
