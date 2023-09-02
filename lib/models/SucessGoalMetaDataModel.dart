

import 'GoalMetaDataModel.dart';

class SuccessGoalMetaDataModel{
  String typename;
  //ONLY ID, Name, Desc are there
  UserGoalInfo goalMetaDataModel;

  SuccessGoalMetaDataModel({
    required this.typename,
    required this.goalMetaDataModel,
  });

  factory SuccessGoalMetaDataModel.fromJson(Map<String, dynamic> json) => SuccessGoalMetaDataModel(
    typename: json["__typename"] ?? "",
    goalMetaDataModel: UserGoalInfo.fromJson(json["updateGoalMeta"]));

/*Map<String, dynamic> toJson() => {
    "__typename": typename,
    "goalDetailModel": List<dynamic>.from(goalDetailList.map((x) => x.toJson())),
  };*/
}