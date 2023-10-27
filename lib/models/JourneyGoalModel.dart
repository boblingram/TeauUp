/*
{__typename: Query, userJourney: [{__typename: Task, date: 1, id: 1, name: 1, status: SKIP, time: 1}]}*/

class JourneyGoalModel {
  String typename;
  List<JourneyGoalDataModel> journeyModelList;

  JourneyGoalModel({
    required this.typename,
    required this.journeyModelList,
  });

  factory JourneyGoalModel.fromJson(Map<String, dynamic> json) =>
      JourneyGoalModel(
        typename: json["__typename"] ?? "",
        journeyModelList: json["userJourney"] == null
            ? List<JourneyGoalDataModel>.from(json["userJourneyByGoal"]
                .map((x) => JourneyGoalDataModel.fromJson(x)))
            : List<JourneyGoalDataModel>.from(json["userJourney"]
                .map((x) => JourneyGoalDataModel.fromJson(x))),
      );

/*Map<String, dynamic> toJson() => {
    "__typename": typename,
    "goalDetailModel": List<dynamic>.from(goalDetailList.map((x) => x.toJson())),
  };*/
}

class JourneyGoalDataModel {
  //List of ISO String Dates
  var date;
  var id;
  var name;
  var status;
  var time;
  var desc;

  JourneyGoalDataModel({
    this.id,
    this.name,
    this.time,
    this.status,
    this.date,
    this.desc,
  });

  factory JourneyGoalDataModel.fromJson(Map<String, dynamic> json) =>
      JourneyGoalDataModel(
          id: json["id"],
          name: json["name"],
          time: json["time"],
          date: json["date"],
          status: json["status"],
          desc: json["desc"]);
}
//Sample
/*
{__typename: Query, goalActivities: [{__typename: Activity, customDay: [cd], desc: desc, duration: 3, endDt: 1/2/3, freq: Weekly, id: dcfbd60d-6357-49c2-8783-c8d23d537893, monthDay: [md], name: nm1, reminder: 8:2:2, time: 8:2:2, weekDay: [wd]}, {__typename: Activity, customDay: [cd3], desc: desc4, duration: d4, endDt: ed4, freq: f4, id: a77df923-bbb7-41d3-9238-433b29bd457d, monthDay: [md4], name: nm4, reminder: r4, time: t4, weekDay: [wd4]}, {__typename: Activity, customDay: [cd3], desc: desc4, duration: d4, endDt: ed4, freq: f4, id: 053455e0-1f81-4049-9e34-2fb6ff42c4cc, monthDay: [md4], name: nm4, reminder: r4, time: t4, weekDay: [wd4]}, {__typename: Activity, customDay: [2cd], desc: 2desc, duration: 2d, endDt: 2ed, freq: 2f, id: fc74d3cd-e403-49be-9d19-327fd10ced3b, monthDay: [2md], name: 2nm, reminder: 2rem, time: 2tm, weekDay: [2wd]}]}
 */
