class GoalMemberModel{
  String typename;
  List<IndividualGoalMemberModel> goalMemberList;

  GoalMemberModel({
    required this.typename,
    required this.goalMemberList,
  });

  factory GoalMemberModel.fromJson(Map<String, dynamic> json) => GoalMemberModel(
    typename: json["__typename"] ?? "",
    goalMemberList: List<IndividualGoalMemberModel>.from(json["goalMembersWithMentor"].map((x) => IndividualGoalMemberModel.fromJson(x))),
  );

/*Map<String, dynamic> toJson() => {
    "__typename": typename,
    "goalDetailModel": List<dynamic>.from(goalDetailList.map((x) => x.toJson())),
  };*/
}

class IndividualGoalMemberModel {
  //String
  var createdBy;

  // ISO Date String
  var createdDt;

  //String
  var deviceId;

  //String
  var fullname;

  //String
  var id;

  // In Mentor.mentor would always be null
  IndividualGoalMemberModel? mentor;

  //String
  var modifiedBy;

  //ISO String
  var modifiedDt;

  //String
  var ph;

  IndividualGoalMemberModel({
    this.id,
    this.fullname,
    this.createdBy,
    this.createdDt,
    this.deviceId,
    this.mentor,
    this.modifiedBy,
    this.modifiedDt,
    this.ph
  });

  factory IndividualGoalMemberModel.fromJson(Map<String, dynamic> json) =>
      IndividualGoalMemberModel(
          id: json["id"],
          ph: json["ph"],
          createdDt: json["createdDt"],
          createdBy: json["createdBy"],
          fullname: json["fullname"],
          modifiedDt: json["modifiedDt"],
          modifiedBy: json["modifiedBy"],
          mentor: json["mentor"] == null ? null : IndividualGoalMemberModel
              .fromJson(json["mentor"]),
          deviceId: json["deviceId"]
      );

  Map<String, dynamic> toJson() {
    if(ph == "-1"){
      return {
        'createdBy': createdBy,
        'createdDt': createdDt,
        'deviceId': deviceId,
        'fullname': fullname,
        'modifiedBy': modifiedBy,
        'modifiedDt': modifiedDt,
        'ph': ph,
        'id':id
      };
    }else{
      return {
        'createdBy': createdBy,
        'createdDt': createdDt,
        'deviceId': deviceId,
        'fullname': fullname,
        'modifiedBy': modifiedBy,
        'modifiedDt': modifiedDt,
        'ph': ph,
      };
    }
  }
}
/*
{__typename: Query, goalMembersWithMentor: [{__typename: GoalMemberWithMentor, createdBy: 1, createdDt: 1/2/3, deviceId: 12344, fullname: fn12, id: a2e4d4af-e38c-4946-9dca-4e70e918f1ff, mentor: null, modifiedBy: 1, modifiedDt: 1/2/3, ph: 12334411}, {__typename: GoalMemberWithMentor, createdBy: null, createdDt: null, deviceId: dsEx1rTYQq-DkYQu4mwKls:APA91bF8jjHB8seEpvYOpOmkwfIP-xxa-tLD6vtK5pmelMT_nyiEHaTYK3XSrGiMr15aUy8hiHf3Psjfc7DaANk_Y4MxPsKq4T8hDWYsTlA6JpFtC6UkM-guzeeQ1hMPw2H5h5kOYjQy, fullname: U2 U2, id: 2, mentor: {__typename: User, createdBy: null, createdDt: null, deviceId: dsEx1rTYQq-DkYQu4mwKls:APA91bF8jjHB8seEpvYOpOmkwfIP-xxa-tLD6vtK5pmelMT_nyiEHaTYK3XSrGiMr15aUy8hiHf3Psjfc7DaANk_Y4MxPsKq4T8hDWYsTlA6JpFtC6UkM-guzeeQ1hMPw2H5h5kOYjQy, fullname: U3 U3, id: 3, modifiedBy: null, modifiedDt: null, ph: +123423456789}, modifiedBy: null, modifiedDt: null, ph: +123423456789}, {__typename: GoalMemberWithMentor, createdBy: null, createdDt: null, deviceId: dsEx1rTYQq-DkYQu4mwKls:APA91bF8jjHB8seEpvYOpOmkwfIP-xxa-tLD6vtK5pmelMT_nyiEHaTYK3XSrGiMr15aUy8hiHf3Psjfc7DaANk_Y4MxPsKq4T8hDWYsTlA6JpFtC6UkM-guzeeQ1hMPw2H5h5kOYjQy, fullname: U1 U2, id: 1, mentor: null, modifiedBy: null, modifiedDt: null, ph: +123423456789}, {__typename: GoalMemberWithMentor, createdBy: 1, createdDt: 1/2/3, deviceId: 12344, fullname: fn12, id: 8e9c2a1e-faa4-4b55-bad1-7f60250d8b97, mentor: null, modifiedBy: 1, modifiedDt: 1/2/3, ph: 1233441}, {__typename: GoalMemberWithMentor, createdBy: 1, createdDt: 1/2/3, deviceId: 12344, fullname: fn12, id: 3f0adbd9-b4cb-41e5-8d0b-2cc6c37e06d5, mentor: null, modifiedBy: 1, modifiedDt: 1/2/3, ph: 123344}, {__typename: GoalMemberWithMentor, createdBy: null, createdDt: null, deviceId: dsEx1rTYQq-DkYQu4mwKls:APA91bF8jjHB8seEpvYOpOmkwfIP-xxa-tLD6vtK5pmelMT_nyiEHaTYK3XSrGiMr15aUy8hiHf3Psjfc7DaANk_Y4MxPsKq4T8hDWYsTlA6JpFtC6UkM-guzeeQ1hMPw2H5h5kOYjQy, fullname: U3 U3, id: 3, mentor: null, modifiedBy: null, modifiedDt: null, ph: +123423456789}]}
 */