

import 'SuccessGoalMentorDataModel.dart';

class GoalMetaDataModel{
  String typename;
  List<UserGoalPerInfo> userGoalPerList;

  GoalMetaDataModel({
    required this.typename,
    required this.userGoalPerList,
  });

  factory GoalMetaDataModel.fromJson(Map<String, dynamic> json) => GoalMetaDataModel(
    typename: json["__typename"] ?? "",
    userGoalPerList: List<UserGoalPerInfo>.from(json["userGoalsWithPerfInfo"].map((x) => UserGoalPerInfo.fromJson(x))),
  );

  /*Map<String, dynamic> toJson() => {
    "__typename": typename,
    "goalDetailModel": List<dynamic>.from(goalDetailList.map((x) => x.toJson())),
  };*/
}

class UserGoalPerInfo{
  UserGoalInfo goalInfo;
  UserPerInfo perInfo;

  UserGoalPerInfo({
    required this.goalInfo,
    required this.perInfo,
  });

  factory UserGoalPerInfo.fromJson(Map<String, dynamic> json) => UserGoalPerInfo(
    goalInfo: UserGoalInfo.fromJson(json["goalInfo"]),
    perInfo: UserPerInfo.fromJson(json["perfInfo"]),
  );

/*Map<String, dynamic> toJson() => {
    "__typename": typename,
    "goalDetailModel": List<dynamic>.from(goalDetailList.map((x) => x.toJson())),
  };*/

}

class UserPerInfo{
  var mainStreak;
  var totalXP;
  var totalDays;

  UserPerInfo({
    this.mainStreak,
    this.totalXP,
    this.totalDays,
  });
  
  factory UserPerInfo.fromJson(Map<String, dynamic> json) => UserPerInfo(
    mainStreak: json["goalInfo"] ?? "0",
    totalXP: json["totalXP"] ?? "0",
    totalDays:json["totalDays"] ?? "0",
  );

}

class UserGoalInfo{
  var id;
  var endDate;
  var name;
  var status;
  var type;
  var desc;
  var backup;
  var createdByName;
  var createdBy;
  List<UserMentorData>? members;

  UserGoalInfo({
    this.id,
    this.status,
    this.name,
    this.endDate,
    this.type,
    this.desc,
    this.backup,
    this.createdByName,
    this.createdBy,
    this.members
});

  factory UserGoalInfo.fromJson(Map<String, dynamic> json) => UserGoalInfo(
    id: json["id"],
    status: json["status"],
    name: json["name"],
    endDate: json["endDate"],
    type: json["type"],
    desc: json["desc"],
    backup: json["backup"],
    createdByName: json["createdByName"],
    createdBy: json["createdBy"],
    members: List<UserMentorData>.from(
        json["members"]
            .map((x) => UserMentorData.fromJson(x)))
  );

}