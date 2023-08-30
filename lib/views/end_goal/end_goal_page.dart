import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/VEGoalController.dart';
import 'widgets/end_goal_widget.dart';

class EndGoalPage extends StatelessWidget {
  EndGoalPage({Key? key}) : super(key: key);

  VEGoalController veGoalController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(()=>veGoalController.endedGoalList.isNotEmpty ? ListView.builder(
          itemCount: veGoalController.endedGoalList.length,
          itemBuilder: (BuildContext context, int index) {
            var item = veGoalController.endedGoalList.elementAt(index);
            return EndGoalWidget(userGoalPerInfo: item,);
          }) : Text("Ended Goal List is Empty")),
    );
  }
}
