class SuccessGoalMentorDataModel{
  String typename;
  //ONLY ID, Name, Desc are there
  SetMemberMentorModel setMemberMentorModel;

  SuccessGoalMentorDataModel({
    required this.typename,
    required this.setMemberMentorModel,
  });

  factory SuccessGoalMentorDataModel.fromJson(Map<String, dynamic> json) => SuccessGoalMentorDataModel(
      typename: json["__typename"] ?? "",
      setMemberMentorModel: SetMemberMentorModel.fromJson(json["setMemberMentor_v1"]));
}

class SetMemberMentorModel {
  List<UserMentorData> members;

  SetMemberMentorModel({
    required this.members,
  });

  factory SetMemberMentorModel.fromJson(Map<String, dynamic> json) => SetMemberMentorModel(
      members: List<UserMentorData>.from(
          json["members"]
              .map((x) => UserMentorData.fromJson(x))));
}

class UserMentorData{
  String? mentorId;
  String? userId;

  UserMentorData({
    this.mentorId,
    this.userId,
  });

  factory UserMentorData.fromJson(Map<String, dynamic> json) => UserMentorData(
      mentorId: json["mentorId"] ?? "",
      userId: json["userId"] ?? "");

}