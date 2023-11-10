import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamup/widgets/ErrorListWidget.dart';

import '../../controllers/VEGoalController.dart';
import '../../utils/Enums.dart';
import 'widgets/end_goal_widget.dart';

class EndGoalPage extends StatelessWidget {
  EndGoalPage({Key? key}) : super(key: key);

  VEGoalController veGoalController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child:GetBuilder<VEGoalController>(
        builder: (veGoalController){
          switch(veGoalController.aeGoalNetworkEnum){
            case NetworkCallEnum.Completed:
              return veGoalController.endedGoalList.isNotEmpty ? RefreshIndicator(
                onRefresh: ()async{
                  veGoalController.refreshAEGoalList();
                },
                color: Colors.red,
                child: ListView.builder(
                    itemCount: veGoalController.endedGoalList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var item = veGoalController.endedGoalList.elementAt(index);
                      return EndGoalWidget(userGoalPerInfo: item,);
                    }),
              ) : ListErrorWidget(text: "Archived Goal List is empty.");
            case NetworkCallEnum.Error:
              return ListErrorWidget(text: "Failed to retrieve archived goal list.");
            case NetworkCallEnum.Loading:
              return ListLoadingWidget();
          }
        },
      ),
    );
  }
}
