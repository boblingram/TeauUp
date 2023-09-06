import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:teamup/models/GoalMetaDataModel.dart';
import 'package:teamup/models/IndividualGoalMemberModel.dart';
import 'package:teamup/models/JourneyGoalModel.dart';
import 'package:teamup/models/SucessGoalMetaDataModel.dart';
import 'package:teamup/utils/Enums.dart';
import 'package:teamup/utils/GraphQLService.dart';
import 'package:teamup/utils/app_strings.dart';
import 'package:teamup/utils/json_constants.dart';
import 'package:teamup/widgets/EditGoalActivityView.dart';

import '../models/IndividualGoalActivityModel.dart';
import '../utils/Constants.dart';
import '../widgets/EditGoalNDView.dart';

//View and Edit Goal Controller
class VEGoalController extends GetxController {
  String userId = "1";

  var activeGoalList = <UserGoalPerInfo>[].obs;
  var endedGoalList = <UserGoalPerInfo>[].obs;

  String goalId = "";
  UserGoalPerInfo? userGoalPerInfo;
  var selectedGoalListIndex = 0;

  var selectedGoalActivityList = <IndividualGoalActivityModel>[].obs;
  var selectedGoalMemberList = <IndividualGoalMemberModel>[].obs;

  var currentDateTime = DateTime.now();

  var journeyGoalList = <JourneyGoalDataModel>[].obs;
  var individualGoalJourneyList = <JourneyGoalDataModel>[].obs;

  void updateGoalId(String tempId) {
    goalId = tempId;
  }

  //Make All the Queries and Mutation here

  String convertStringToNotNull(var tempString) {
    return (tempString ?? AppStrings.defaultNullString).toString().trim();
  }

  String convertFrequencyToAppropriate(var tempValue) {
    if (tempValue == null || tempValue
        .toString()
        .isEmpty) {
      return AppStrings.defaultFrequencyValue;
    }
    switch (tempValue.toString().trim().toLowerCase()) {
      case "daily":
        return "Daily";
      case "weekly":
        return "Weekly";
      case "monthly":
        return "Monthly";
      case "custom":
        return "Custom";
      default:
        return AppStrings.defaultFrequencyValue;
    }
  }

  String convertTimeToAppropriate(var tempValue) {
    if (tempValue == null || tempValue
        .toString()
        .isEmpty) {
      return AppStrings.defaultTimeValue;
    }
    try {
      var updateTime = DateTime.tryParse(tempValue) ?? currentDateTime;
      return DateFormat('h:mm a').format(updateTime);
    } catch (onError) {
      print("VEC - Convert Time Failed $onError");
      return AppStrings.defaultTimeValue;
    }
  }

  String convertDurationToAppropriate(var tempValue) {
    var newValue = "";
    if (tempValue == null || tempValue
        .toString()
        .isEmpty) {
      newValue = AppStrings.defaultDurationValue;
    }
    if (int.tryParse(tempValue.toString()) == null) {
      newValue = AppStrings.defaultDurationValue;
    } else {
      newValue = int.tryParse(tempValue.toString()).toString();
    }
    if (newValue == "60") {
      return "1 hour";
    }
    return "$newValue min";
  }

  String convertEndDateToAppropriate(var tempValue) {
    if (tempValue == null || tempValue
        .toString()
        .isEmpty) {
      return AppStrings.defaultEndDate;
    }

    try {
      var updateTime = DateTime.tryParse(tempValue) ?? currentDateTime;
      return DateFormat('dd/MM/yyyy').format(updateTime);
    } catch (onError) {
      print("VEC - Convert EDate Failed $onError");
      return AppStrings.defaultEndDate;
    }
  }

  bool showReminderDate(var tempValue) {
    if (tempValue == null || tempValue
        .toString()
        .isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  String convertJDatetoDateText(var tempValue) {
    if (tempValue == null || tempValue
        .toString()
        .isEmpty) {
      return AppStrings.defaultEndDate;
    }

    try {
      var updateTime = DateTime.tryParse(tempValue) ?? currentDateTime;
      return DateFormat('dd MMM').format(updateTime);
    } catch (onError) {
      print("VEC - Convert JDate - Date Failed $onError");
      return AppStrings.defaultEndDate;
    }
  }

  String convertJDateToDayText(var tempValue) {
    if (tempValue == null || tempValue
        .toString()
        .isEmpty) {
      return AppStrings.defaultEndDate;
    }

    try {
      var updateTime = DateTime.tryParse(tempValue) ?? currentDateTime;
      return DateFormat('EEE').format(updateTime);
    } catch (onError) {
      print("VEC - Convert JDate - Day Failed $onError");
      return AppStrings.defaultEndDate;
    }
  }

  String convertJTimeToTimeText(var tempValue) {
    if (tempValue == null || tempValue
        .toString()
        .isEmpty) {
      return AppStrings.defaultTimeValue;
    }
    try {
      var updateTime = DateTime.tryParse(tempValue) ?? currentDateTime;
      return DateFormat('h:mm a').format(updateTime);
    } catch (onError) {
      print("VEC - Convert JTime - Time Failed $onError");
      return AppStrings.defaultTimeValue;
    }
  }

  /*[{"date":"2023-06-01T10:15:55.469427Z","id":"1","time":"2023-06-01T10:15:55.469427Z","name":"One","status":"COMPLETED"},{"date":"2023-06-01T10:15:55.469427Z","id":"1","time":"2023-06-01T10:15:55.469427Z","name":"One","status":"COMPLETED"}]*/
  /*[{"date":,"id":,"time":,"name":,"status":}]*/


  void getJourneyData({String localGoalId = ""}) async {
    String query = "";

    if (localGoalId.isEmpty) {
      query = '''query MyQuery {
  userJourney(userId: "$userId") {
    date
    id
    name
    status
    time
  }
}
''';
    } else {
      print("Goal Id is Called");
      query = '''query MyQuery {
  userJourneyByGoal(goalId: "$localGoalId", userId: "$userId") {
    date
    id
    name
    status
    time
  }
}
''';
    }

    var result = await GraphQLService.tempClient.query(
        QueryOptions(document: gql(query)));
    //var result = await graphqlClient.query(QueryOptions(document: gql(mutation)));
    //It can have exception or data
    log(result.data.toString());
    //json.encode(result.data);
    //Hide Progress Bar
    hidePLoader();
    if (!shouldContinueFurther("GetJourneyData", result)) {
      showError("Failed to Get Journey Data");
      return;
    }

    try {
      JourneyGoalModel journeyGoalModel =
      JourneyGoalModel.fromJson(result.data!);
      print("Length of List is ${journeyGoalModel.journeyModelList.length}");
    } catch (onError, stackTrace) {
      print("Error while parsing Journey Goal Model $onError");
    }
  }

  void getFromJourneyJson({bool localIsJourney = false}) {
    var tempResult = json.decode(journeyJson);
    if (localIsJourney) {
      print("Journey Goal is shown");
      tempResult = json.decode(journeyGJson);
    }
    try {
      JourneyGoalModel journeyGoalModel =
      JourneyGoalModel.fromJson(tempResult);
      print("Length of List is ${journeyGoalModel.journeyModelList.length}");
      journeyGoalList.clear();
      journeyGoalList.value = journeyGoalModel.journeyModelList;
      // Sort the list based on the 'date' attribute in ascending order.
      journeyGoalList.sort((a, b) => a.date.compareTo(b.date));
    } catch (onError, stackTrace) {
      print("Error while parsing Journey Goal Model $onError");
    }
  }


  //Show Bottom Sheet for editing of Goal name and Description
  void editGoalNDSheet() {
    var name = convertStringToNotNull(userGoalPerInfo?.goalInfo.name ?? "");
    var desc = convertStringToNotNull(userGoalPerInfo?.goalInfo.desc);
    print("Show Goal Name and Description Sheet");
    Get.bottomSheet(
        Padding(
          padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 5.h),
          child: EditGoalNDView(
            name: name,
            description: desc,
          ),
        ),
        backgroundColor: Colors.white);
  }

  void editGoalActivitySheet(IndividualGoalActivityModel activityId) {
    print("Edit Individual Activity Sheet");
    Get.bottomSheet(
        Padding(
          padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 5.h),
          child: EditGoalActivityView(
            activityModel: activityId,
          ),
        ),
        backgroundColor: Colors.white);
  }

  /*
  {__typename: Mutation, updateGoalMeta: {__typename: Goal, id: f9f004da-d869-4a6b-b530-ff15956d1f8b, name: Goal - Cycling, desc: This goal will help us to focus on improving health. Focus would be on the topic such as stamina.}}
   */
  void updateGoalND(String tempName, String tempDesc) async {
    print("Initiate Mutation for tempName, TempDesc");
    //Show Progress Bar
    showLoader();

    String mutation = """
  mutation MyMutation {
  updateGoalMeta(goal: {id: "$goalId", desc: "$tempDesc", name: "$tempName"}) {
    id
    name
    desc
  }
}
""";

    var result =
    await GraphQLService.tempClient.mutate(
        MutationOptions(document: gql(mutation)));
    //var result = await graphqlClient.query(QueryOptions(document: gql(mutation)));
    //It can have exception or data
    log(result.data.toString());
    //json.encode(result.data);
    //Hide Progress Bar
    hidePLoader();
    if (!shouldContinueFurther("EditGoalMetaData", result)) {
      showError("Failed to Update Goal Name and Desc");
      return;
    }

    //TODO Make Current List and Current Item Reactive in nature
    SuccessGoalMetaDataModel successGoalMetaDataModel =
    SuccessGoalMetaDataModel.fromJson(result.data!);
  }

  bool shouldContinueFurther(String? tempName,
      QueryResult<Object?> result,) {
    if (result.data == null || result.exception != null) {
      //No Data Received from Server;
      parseError(result.exception, "$tempName");
      return false;
    }
    return true;
  }

  /*
  {__typename: Mutation, endGoal: {__typename: Goal, id: 09b2838e-535a-451d-af53-45ab0e706443, status: ENDED, name: name}}
   */
  void endGoalIsPressed() async {
    print("End Goal is pressed");
    //Show Progress Bar
    showLoader();

    String mutation = """mutation MyMutation {
  endGoal(goalId: "$goalId") {
    id
    status
    name
  }
}

""";

    var result =
    await GraphQLService.tempClient.mutate(
        MutationOptions(document: gql(mutation)));
    //var result = await graphqlClient.query(QueryOptions(document: gql(mutation)));
    //It can have exception or data
    log(result.data.toString());
    //json.encode(result.data);
    //Hide Progress Bar
    hidePLoader();
    if (!shouldContinueFurther("EndGoalM", result)) {
      showError("Failed to end goal mutation");
      return;
    }

    //TODO Update UI on Tap on Archive Goal
  }

  void updateUserGoalPerInfo(UserGoalPerInfo tempUserInfo) {
    userGoalPerInfo = tempUserInfo;
  }

  void updateSelectedItemIndex(int itemIndex) {
    selectedGoalListIndex = itemIndex;
  }

  //Get Active or Ended Goal
  void getAEGoal() async {

    ///View Goal - Active
    final query = gql('''query MyQuery {
  userGoalsWithPerfInfo(userId: "$userId") {
    goalInfo {
      activities
      backup
      collabType
      createdBy
      createdDt
      desc
      endDate
      id
      members {
        mentorId
        userId
      }
      mentor
      modifiedBy
      modifiedDt
      name
      status
      type
    }
    perfInfo {
      mainStreak
      totalXP
      totalDays
    }
  }
}
''');

    var result = await GraphQLService.tempClient.query(
        QueryOptions(document: query));
    //It can have exception or data
    //log(result.data.toString());
    //json.encode(result.data);
    if (result.data == null && result.exception != null) {
      //No Data Received from Server;
      parseError(result.exception, "FetchActiveEndedGoalList");
      return;
    }

    try {
      GoalMetaDataModel goalActivityModel =
      GoalMetaDataModel.fromJson(result.data!);
      print("Length of List is ${goalActivityModel.userGoalPerList.length}");
      parseIntoAEGoalList(goalActivityModel.userGoalPerList);
    } catch (onError, stackTrace) {
      print("Error while parsing GoalActivityModel $onError");
    }
  }

  //Get Individual Goal Activities
  void getGoalActivitiesData(String goalId) async {
    print("Goal Activity Data $goalId");

    //TO Check place goalID = 1
    ///View Goal - Active
    final query = gql('''query MyQuery {
  goalActivities(goalId: "$goalId") {
    customDay
    desc
    duration
    endDt
    freq
    id
    monthDay
    name
    reminder
    time
    weekDay
  }
}
''');

    var result = await GraphQLService.tempClient.query(
        QueryOptions(document: query));
    //It can have exception or data
    //log(result.data.toString());
    //json.encode(result.data);
    if (!shouldContinueFurther("FetchGoalActivitiesData", result)) {
      showError("Failed to Fetch Goal Activities");
      return;
    }

    try {
      GoalActivityModel goalActivityModel =
      GoalActivityModel.fromJson(result.data!);
      print("Length of List is ${goalActivityModel.goalActivityList.length}");
      selectedGoalActivityList.value.clear();
      selectedGoalActivityList.value = goalActivityModel.goalActivityList;
    } catch (onError, stackTrace) {
      print("Error while parsing FetchGoalActivitiesData $onError");
    }
  }

  //Get Membership Goal Data
  void getGoalMembershipData(String goalId) async {
    //TO Check place goalID = 1
    ///View Goal - Active
    final query = gql('''query MyQuery {
  goalMembersWithMentor(goalId: "$goalId") {
    createdBy
    createdDt
    deviceId
    fullname
    id
    mentor {
      createdBy
      createdDt
      deviceId
      fullname
      id
      modifiedBy
      modifiedDt
      ph
    }
    modifiedBy
    modifiedDt
    ph
  }
}
''');


    var result = await GraphQLService.tempClient.query(
        QueryOptions(document: query));
    //It can have exception or data
    //log(result.data.toString());
    //json.encode(result.data);
    if (!shouldContinueFurther("FetchGoalMembershipData", result)) {
      showError("Failed to Update Goal Membership");
      return;
    }

    try {
      GoalMemberModel goalMemberModel = GoalMemberModel.fromJson(result.data!);
      print("Length of List is ${goalMemberModel.goalMemberList.length}");
      selectedGoalMemberList.value.clear();
      selectedGoalMemberList.value = goalMemberModel.goalMemberList;
    } catch (onError, stackTrace) {
      print("Error while parsing FetchGoalMembershipData $onError");
    }
  }

  void parseIntoAEGoalList(List<UserGoalPerInfo> goalActivityList) {
    activeGoalList.clear();
    endedGoalList.clear();

    for (var item in goalActivityList) {
      if (item.goalInfo.status.toString().trim().toLowerCase() == "ended") {
        endedGoalList.add(item);
      } else {
        activeGoalList.add(item);
      }
    }
  }

  void parseError(OperationException? responseToShow, String apiCallFrom) {
    print("Error in $apiCallFrom");
    if (responseToShow != null && responseToShow.graphqlErrors.isNotEmpty) {
      print("Error is ${responseToShow.graphqlErrors[0].message}");
    } else {
      log("Exception is $responseToShow");
    }
  }

  bool checkJDate(DateTime oldDate, DateTime newDate) {
    //print("Check J Date old Date and New Date ${oldDate} ${newDate}");
    if (oldDate.year == newDate.year &&
        oldDate.month == newDate.month &&
        oldDate.day == newDate.day) {
      return true;
    } else {
      return false;
    }
  }

  /*
  {__typename: Mutation, completeTask: null}
   */
  void updateJourneyMutation(JourneyMutationEnum tempJEnum,
      {String taskId = ""}) async {
    print("Mutation Called is ${tempJEnum}");

    showLoader();

    String mutation = '';
    switch (tempJEnum) {
      case JourneyMutationEnum.SkipIt:
        mutation = '''mutation MyMutation {
  skipTask(taskId: "$taskId") {
    id
    name
    status
    time
    date
    activityId
  }
}
''';
        break;
      case JourneyMutationEnum.MarkasComplete:
        mutation = '''mutation MyMutation {
  completeTask(taskId: "$taskId") {
    id
    name
    status
    time
    date
    activityId
  }
}
''';
        break;
    }


    //TODO Update The UI Accordingly
    var result = await GraphQLService.tempClient.mutate(
        MutationOptions(document: gql(mutation)));
    //var result = await graphqlClient.query(QueryOptions(document: gql(mutation)));
    //It can have exception or data
    log(result.data.toString());
    //json.encode(result.data);
    //Hide Progress Bar
    hidePLoader();
    if (!shouldContinueFurther("Journey Mutation Failed", result)) {
      showError("Failed to Mutate Journey Mark as complete");
      return;
    }
  }

  JourneyStatus convertJStatusToJourney(var tempStatus, var tempDate) {
    if(tempStatus == null){
      return JourneyStatus.Failed;
    }

    DateTime updateTempDate = DateTime.tryParse(tempDate) ?? currentDateTime;
    if(updateTempDate.isAfter(currentDateTime)){
      return JourneyStatus.Upcoming;
    }

    var tempString = tempStatus.toString().trim().toLowerCase();
    if(tempString == "completed"){
      return JourneyStatus.Success;
    }else if(tempString == "skipped"){
      return JourneyStatus.Failed;
    }else if(tempString != "completed" && updateTempDate.isBefore(currentDateTime)){
      return JourneyStatus.Overdue;
    }else{
      return JourneyStatus.Failed;
    }
  }

  void updateActivityModel(IndividualGoalActivityModel activityModel) {
    print("Updated Activity Model is ${activityModel.toString()}");
  }

  void refreshGoalActivityList() {
    GraphQLService.tempClient.resetStore(refetchQueries: false);
    getGoalActivitiesData(goalId);
  }
}