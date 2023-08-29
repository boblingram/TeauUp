
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teamup/widgets/EditGoalNDView.dart';

class GoalDetailController extends GetxController{
  String goalId = "";

  void updateGoalId(String tempId) {
    goalId = tempId;
  }

  //Make All the Queries and Mutation here

  //Show Bottom Sheet for editing of Goal name and Description
  void editGoalNDSheet(){
    print("Show Goal Name and Description Sheet");
    Get.bottomSheet(
        Padding(
          padding: EdgeInsets.fromLTRB(4.w,1.h, 4.w,5.h),
          child: EditGoalNDView(name: 'A', description: 'B',),
        ),
    backgroundColor: Colors.white);
  }

  void updateGoalND(String tempName, String tempDesc) {
    print("Initiate Mutation for tempName, TempDesc");
  }

  void editGoalActivitySheet(String activityId){
    print("Edit Individual Activity Sheet");
  }

  void endGoalIsPressed(){
    print("Edit Goal is pressed");
  }


}