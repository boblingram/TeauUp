import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoalController extends GetxController {
  TextEditingController goalNameController = TextEditingController(text: "");
  TextEditingController goalDescriptionController = TextEditingController(text: "");
  TextEditingController activityNameController = TextEditingController(text: "");
  List<String> _activityName = [];

  void addActivityName(String activityName){
    _activityName.add(activityName);
  }

  List<String> get getActivityNames => _activityName;



}