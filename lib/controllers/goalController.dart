import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoalController extends GetxController {
  TextEditingController activityNameController = TextEditingController(text: "");
  List<String> _activityName = [];

  var newGoalName = "";
  var newGoalDescription = "";
  var newSelectedGoalType = "";

  void addActivityName(String activityName){
    _activityName.add(activityName);
  }

  List<String> get getActivityNames => _activityName;

  void updateNameAndDescription(String name, String description, String selectedGoalType) {
    newGoalName = name;
    newGoalDescription = description;
    newSelectedGoalType = selectedGoalType;
  }



}