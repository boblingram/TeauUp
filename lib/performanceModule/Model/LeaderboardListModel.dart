// To parse this JSON data, do
//
//     final leardboardList = leardboardListFromJson(jsonString);

import 'dart:convert';

LeardboardListModel leardboardListFromJson(String str) => LeardboardListModel.fromJson(json.decode(str));

String leardboardListToJson(LeardboardListModel data) => json.encode(data.toJson());

class LeardboardListModel {
  String typename;
  List<LeaderBoard> leaderBoard;

  LeardboardListModel({
    required this.typename,
    required this.leaderBoard,
  });

  factory LeardboardListModel.fromJson(Map<String, dynamic> json) => LeardboardListModel(
    typename: json["__typename"] ?? "",
    leaderBoard: List<LeaderBoard>.from(json["leaderBoard"].map((x) => LeaderBoard.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "__typename": typename,
    "leaderBoard": List<dynamic>.from(leaderBoard.map((x) => x.toJson())),
  };
}

class LeaderBoard {
  String fnln;
  String id;
  List<int> allTimeStats;
  List<int> sevenDayStats;
  List<int> thirtyDayStats;
  String userId;
  String goalId;

  LeaderBoard({
    required this.fnln,
    required this.id,
    required this.allTimeStats,
    required this.sevenDayStats,
    required this.thirtyDayStats,
    required this.userId,
    required this.goalId,
  });

  factory LeaderBoard.fromJson(Map<String, dynamic> json) => LeaderBoard(
    fnln: json["FNLN"] ?? "N/A",
    id: json["id"] ?? "-1",
    allTimeStats: List<int>.from(json["allTimeStats"].map((x) => int.tryParse(x) ?? 0)),
    sevenDayStats: List<int>.from(json["sevenDayStats"].map((x) => int.tryParse(x) ?? 0)),
    thirtyDayStats: List<int>.from(json["thirtyDayStats"].map((x) => int.tryParse(x) ?? 0)),
    userId: json["userId"] ?? "-1",
    goalId: json["goalId"] ?? "-1",
  );

  Map<String, dynamic> toJson() => {
    "FNLN": fnln,
    "id": id,
    "userId": userId,
    "goalId": goalId,
  };
}