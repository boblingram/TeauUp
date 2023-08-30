

class GoalActivityModel{
  String typename;
  List<UserGoalPerInfo> userGoalPerList;

  GoalActivityModel({
    required this.typename,
    required this.userGoalPerList,
  });

  factory GoalActivityModel.fromJson(Map<String, dynamic> json) => GoalActivityModel(
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
    mainStreak: json["goalInfo"],
    totalXP: json["totalXP"],
    totalDays:json["totalDays"],
  );

}

class UserGoalInfo{
  var id;
  var endDate;
  var name;
  var status;
  var type;

  UserGoalInfo({
    this.id,
    this.status,
    this.name,
    this.endDate,
    this.type
});

  factory UserGoalInfo.fromJson(Map<String, dynamic> json) => UserGoalInfo(
    id: json["id"],
    status: json["status"],
    name: json["name"],
    endDate: json["endDate"],
    type: json["type"],
  );

}