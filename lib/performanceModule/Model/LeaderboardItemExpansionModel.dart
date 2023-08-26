// To parse this JSON data, do
//
//     final leaderboardItemExpansionModel = leaderboardItemExpansionModelFromJson(jsonString);

import 'dart:convert';

import 'GenericModel.dart';

LeaderboardItemExpansionModel leaderboardItemExpansionModelFromJson(String str) => LeaderboardItemExpansionModel.fromJson(json.decode(str));

String leaderboardItemExpansionModelToJson(LeaderboardItemExpansionModel data) => json.encode(data.toJson());

class LeaderboardItemExpansionModel {
  List<UserActivitySumm> userActivitySumm;

  LeaderboardItemExpansionModel({
    required this.userActivitySumm,
  });

  factory LeaderboardItemExpansionModel.fromJson(Map<String, dynamic> json) => LeaderboardItemExpansionModel(
    userActivitySumm: List<UserActivitySumm>.from(json["userActivitySumm"].map((x) => UserActivitySumm.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "userActivitySumm": List<dynamic>.from(userActivitySumm.map((x) => x.toJson())),
  };
}

class UserActivitySumm {
  List<Summ> allTimeSumm;
  String? goalId;
  String? goalName;
  String? id;
  List<Summ> sevenDaySumm;
  List<Summ> thirtyDaySumm;

  UserActivitySumm({
    required this.allTimeSumm,
    required this.goalId,
    required this.goalName,
    required this.id,
    required this.sevenDaySumm,
    required this.thirtyDaySumm,
  });

  factory UserActivitySumm.fromJson(Map<String, dynamic> json) => UserActivitySumm(
    allTimeSumm: List<Summ>.from(json["allTimeSumm"].map((x) => summValues.map[x]!)),
    goalId: json["goalId"],
    goalName: json["goalName"],
    id: json["id"],
    sevenDaySumm: List<Summ>.from(json["sevenDaySumm"].map((x) => summValues.map[x]!)),
    thirtyDaySumm: List<Summ>.from(json["thirtyDaySumm"].map((x) => summValues.map[x]!)),
  );

  Map<String, dynamic> toJson() => {
    "allTimeSumm": List<dynamic>.from(allTimeSumm.map((x) => summValues.reverse[x])),
    "goalId": goalId,
    "goalName": goalName,
    "id": id,
    "sevenDaySumm": List<dynamic>.from(sevenDaySumm.map((x) => summValues.reverse[x])),
    "thirtyDaySumm": List<dynamic>.from(thirtyDaySumm.map((x) => summValues.reverse[x])),
  };
}

enum Summ { GREY, RED, GREEN }

final summValues = EnumValues({
  "green": Summ.GREEN,
  "grey": Summ.GREY,
  "red": Summ.RED
});
