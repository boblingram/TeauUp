import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamup/controllers/VEGoalController.dart';
import 'package:teamup/utils/Enums.dart';
import 'package:teamup/utils/app_strings.dart';
import 'package:teamup/widgets/ErrorListWidget.dart';
import 'package:teamup/widgets/ProgressBarWidget.dart';

import 'widgets/active_goal_widget.dart';

class ActiveGoalsPage extends StatelessWidget {
  ActiveGoalsPage({Key? key}) : super(key: key);

  VEGoalController veGoalController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppStrings.yourGoals, style: TextStyle(fontWeight: FontWeight.w600,letterSpacing: 0.5),),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: GetBuilder<VEGoalController>(
              builder: (veGoalController){
                switch(veGoalController.aeGoalNetworkEnum){
                  case NetworkCallEnum.Completed:
                    return veGoalController.activeGoalList.isNotEmpty ? RefreshIndicator(
                      onRefresh: () async{
                        veGoalController.refreshAEGoalList();
                      },
                      color: Colors.red,
                      child: ListView.builder(
                          itemCount: veGoalController.activeGoalList.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            var item = veGoalController.activeGoalList.elementAt(index);
                            return ActiveGoalWidget(userGoalPerInfo: item,itemIndex: index,);
                          }),
                    ) : ListErrorWidget(text: "Active Goal List is empty.");
                  case NetworkCallEnum.Error:
                    return ListErrorWidget(text: "Failed to retrieve active goal list.");
                  case NetworkCallEnum.Loading:
                    return ListLoadingWidget();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

