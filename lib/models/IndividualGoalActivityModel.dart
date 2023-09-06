class GoalActivityModel {
  String typename;
  List<IndividualGoalActivityModel> goalActivityList;

  GoalActivityModel({
    required this.typename,
    required this.goalActivityList,
  });

  factory GoalActivityModel.fromJson(Map<String, dynamic> json) =>
      GoalActivityModel(
        typename: json["__typename"] ?? "",
        goalActivityList: List<IndividualGoalActivityModel>.from(
            json["goalActivities"]
                .map((x) => IndividualGoalActivityModel.fromJson(x))),
      );

/*Map<String, dynamic> toJson() => {
    "__typename": typename,
    "goalDetailModel": List<dynamic>.from(goalDetailList.map((x) => x.toJson())),
  };*/
}

class IndividualGoalActivityModel {
  //List of ISO String Dates
  var customDay;

  // String
  var desc;

  // It is value entered in daily tab - It is String but need to convert to int and append min at end
  var duration;

  // ISO String
  var endDt;

  //Daily|Weekly|Monthly|Custom -> It is String out of these
  var freq;

  //Activity ID
  var id;

  //List of days [n1,n2….nz] where 1>=n<=31 selected in Monthly days
  var monthDay;

  //String
  var name;

  //ISO String time
  var reminder;

  //ISO String time
  var time;

  //List of days [n1,n2….nz] where 1>=n<=7 selected in Weekly days
  var weekDay;

  IndividualGoalActivityModel(
      {this.id,
      this.customDay,
      this.name,
      this.duration,
      this.endDt,
      this.desc,
      this.freq,
      this.monthDay,
      this.reminder,
      this.time,
      this.weekDay});

  factory IndividualGoalActivityModel.fromJson(Map<String, dynamic> json) =>
      IndividualGoalActivityModel(
        id: json["id"],
        customDay: json["customDay"],
        name: json["name"],
        duration: json["duration"],
        endDt: json["endDt"],
        desc: json["desc"],
        freq: json["freq"],
        monthDay: json["monthDay"],
        reminder: json["reminder"],
        time: json["time"],
        weekDay: json["weekDay"],
      );

  @override
  String toString() {
    return "Id is $id, custom day is ${customDay.toString()}, "
        "name is ${name.toString()}, duration is ${duration.toString()}, "
        "endDt is ${endDt.toString()}, desc is ${desc.toString()}, "
        "freq is ${freq.toString()}, monthDay is ${monthDay.toString()}, "
        "reminder is ${reminder.toString()}, time is ${time.toString()}"
        "week day is ${weekDay.toString()}";
  }
}
//Sample
/*
{__typename: Query, goalActivities: [{__typename: Activity, customDay: [cd], desc: desc, duration: 3, endDt: 1/2/3, freq: Weekly, id: dcfbd60d-6357-49c2-8783-c8d23d537893, monthDay: [md], name: nm1, reminder: 8:2:2, time: 8:2:2, weekDay: [wd]}, {__typename: Activity, customDay: [cd3], desc: desc4, duration: d4, endDt: ed4, freq: f4, id: a77df923-bbb7-41d3-9238-433b29bd457d, monthDay: [md4], name: nm4, reminder: r4, time: t4, weekDay: [wd4]}, {__typename: Activity, customDay: [cd3], desc: desc4, duration: d4, endDt: ed4, freq: f4, id: 053455e0-1f81-4049-9e34-2fb6ff42c4cc, monthDay: [md4], name: nm4, reminder: r4, time: t4, weekDay: [wd4]}, {__typename: Activity, customDay: [2cd], desc: 2desc, duration: 2d, endDt: 2ed, freq: 2f, id: fc74d3cd-e403-49be-9d19-327fd10ced3b, monthDay: [2md], name: 2nm, reminder: 2rem, time: 2tm, weekDay: [2wd]}]}
 */
