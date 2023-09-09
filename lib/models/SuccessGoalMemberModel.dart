import 'IndividualGoalMemberModel.dart';

class SuccessGoalMemberModel{
  String typename;
  List<IndividualGoalMemberModel> goalMemberList;

  SuccessGoalMemberModel({
    required this.typename,
    required this.goalMemberList,
  });

  factory SuccessGoalMemberModel.fromJson(Map<String, dynamic> json) => SuccessGoalMemberModel(
    typename: json["__typename"] ?? "",
    goalMemberList: List<IndividualGoalMemberModel>.from(json["addGoalMembers"].map((x) => IndividualGoalMemberModel.fromJson(x))),
  );

/*Map<String, dynamic> toJson() => {
    "__typename": typename,
    "goalDetailModel": List<dynamic>.from(goalDetailList.map((x) => x.toJson())),
  };*/
}
