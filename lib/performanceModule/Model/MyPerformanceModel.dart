// To parse this JSON data, do
//
//     final myPerformanceModel = myPerformanceModelFromJson(jsonString);

import 'dart:convert';

MyPerformanceModel myPerformanceModelFromJson(String str) => MyPerformanceModel.fromJson(json.decode(str));

String myPerformanceModelToJson(MyPerformanceModel data) => json.encode(data.toJson());

class MyPerformanceModel {
  UserPerformance userPerformance;

  MyPerformanceModel({
    required this.userPerformance,
  });

  factory MyPerformanceModel.fromJson(Map<String, dynamic> json) => MyPerformanceModel(
    userPerformance: UserPerformance.fromJson(json["userPerformance"]),
  );

  Map<String, dynamic> toJson() => {
    "userPerformance": userPerformance.toJson(),
  };
}

class UserPerformance {
  String currentStreak;
  List<String> earnedBadges;
  List<GoalCompare> goalCompare;
  String id;
  String longestStreak;
  double mainStreak;
  List<String> sevenDayStatus;
  List<double> sevenDaysXp;
  String totalXp;
  String userId;
  List<WeeklyCompare> weeklyCompare;
  List<Badge> badges;
  double totalDays;

  UserPerformance({
    required this.currentStreak,
    required this.earnedBadges,
    required this.goalCompare,
    required this.id,
    required this.longestStreak,
    required this.mainStreak,
    required this.sevenDayStatus,
    required this.sevenDaysXp,
    required this.totalXp,
    required this.userId,
    required this.weeklyCompare,
    required this.badges,
    required this.totalDays,
  });

  factory UserPerformance.fromJson(Map<String, dynamic> json) => UserPerformance(
    currentStreak: json["currentStreak"],
    earnedBadges: List<String>.from(json["earnedBadges"].map((x) => x)),
    goalCompare: List<GoalCompare>.from(json["goalCompare"].map((x) => GoalCompare.fromJson(x))),
    id: json["id"],
    longestStreak: json["longestStreak"],
    mainStreak: double.tryParse(json["mainStreak"]) ?? 0,
    sevenDayStatus: List<String>.from(json["sevenDayStatus"].map((x) => x)),
    sevenDaysXp: List<double>.from(json["sevenDaysXP"].map((x) => double.tryParse(x) ?? 0)),
    totalXp: json["totalXP"],
    userId: json["userId"],
    weeklyCompare: List<WeeklyCompare>.from(json["weeklyCompare"].map((x) => WeeklyCompare.fromJson(x))),
    badges: List<Badge>.from(json["badges"].map((x) => Badge.fromJson(x))),
    totalDays: double.tryParse(json["totalDays"] ?? "0") ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "currentStreak": currentStreak,
    "earnedBadges": List<dynamic>.from(earnedBadges.map((x) => x)),
    "goalCompare": List<dynamic>.from(goalCompare.map((x) => x.toJson())),
    "id": id,
    "longestStreak": longestStreak,
    "mainStreak": mainStreak,
    "sevenDayStatus": List<dynamic>.from(sevenDayStatus.map((x) => x)),
    "sevenDaysXP": List<dynamic>.from(sevenDaysXp.map((x) => x)),
    "totalXP": totalXp,
    "userId": userId,
    "weeklyCompare": List<dynamic>.from(weeklyCompare.map((x) => x.toJson())),
    "badges": List<dynamic>.from(badges.map((x) => x.toJson())),
    "totalDays": totalDays,
  };
}

class Badge {
  String desc;
  String icon;
  String id;
  String name;

  Badge({
    required this.desc,
    required this.icon,
    required this.id,
    required this.name,
  });

  factory Badge.fromJson(Map<String, dynamic> json) => Badge(
    desc: json["desc"],
    icon: json["icon"],
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "desc": desc,
    "icon": icon,
    "id": id,
    "name": name,
  };
}

class GoalCompare {
  String activityCompleted;
  String activityNotComplete;
  String goalName;
  //It Should be date
  String updatedDt;
  String userId;
  String id;

  GoalCompare({
    required this.activityCompleted,
    required this.activityNotComplete,
    required this.goalName,
    required this.updatedDt,
    required this.userId,
    required this.id,
  });

  factory GoalCompare.fromJson(Map<String, dynamic> json) => GoalCompare(
    activityCompleted: json["activityCompleted"],
    activityNotComplete: json["activityNotComplete"],
    goalName: json["goalName"] ?? "N/A",
    updatedDt: json["updatedDt"],
    userId: json["userId"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "activityCompleted": activityCompleted,
    "activityNotComplete": activityNotComplete,
    "userId": userId,
    "id": id,
  };
}

class WeeklyCompare {
  String id;
  String userId;
  List<GoalCompare> userTaskSumm;
  String week;

  WeeklyCompare({
    required this.id,
    required this.userId,
    required this.userTaskSumm,
    required this.week,
  });

  factory WeeklyCompare.fromJson(Map<String, dynamic> json) => WeeklyCompare(
    id: json["id"],
    userId: json["userId"],
    userTaskSumm: List<GoalCompare>.from(json["userTaskSumm"].map((x) => GoalCompare.fromJson(x))),
    week: json["week"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "userTaskSumm": List<dynamic>.from(userTaskSumm.map((x) => x.toJson())),
    "week": week,
  };
}
