import 'dart:convert';
import 'dart:developer';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:teamup/models/GoalMetaDataModel.dart';
import 'package:teamup/models/IndividualGoalMemberModel.dart';
import 'package:teamup/models/JourneyGoalModel.dart';
import 'package:teamup/models/SuccessGoalMentorDataModel.dart';
import 'package:teamup/models/SuccessGoalMetaDataModel.dart';
import 'package:teamup/utils/Enums.dart';
import 'package:teamup/utils/GraphQLService.dart';
import 'package:teamup/utils/app_Images.dart';
import 'package:teamup/utils/app_colors.dart';
import 'package:teamup/utils/app_integers.dart';
import 'package:teamup/utils/app_strings.dart';
import 'package:teamup/utils/json_constants.dart';
import 'package:teamup/views/add_goals/create_goal_activities/create_goal_activities_page.dart';
import 'package:teamup/views/journey_views/journey_view.dart';
import 'package:teamup/widgets/EditGoalActivityView.dart';

import '../models/IndividualGoalActivityModel.dart';
import '../utils/Constants.dart';
import '../utils/PermissionManager.dart';
import '../widgets/EditGoalNDView.dart';
import '../widgets/MultipleSelectContactView.dart';

//View and Edit Goal Controller
class VEGoalController extends GetxController {
  String userId = "1";

  var activeGoalList = <UserGoalPerInfo>[];
  var endedGoalList = <UserGoalPerInfo>[];
  var showNotifDot = false.obs;

  String goalId = "";
  String goalType = "";
  UserGoalPerInfo? userGoalPerInfo;
  var selectedGoalListIndex = 0;

  var selectedGoalActivityList = <IndividualGoalActivityModel>[];
  var selectedGoalMemberList = <IndividualGoalMemberModel>[].obs;

  var currentDateTime = DateTime.now();

  var journeyGoalList = <JourneyGoalDataModel>[];

  var goalName = "".obs;
  var goalDesc = "".obs;

  final localStorage = GetStorage();

  var userName = "";

  @override
  void onInit() {
    super.onInit();
    userId = localStorage.read(AppStrings.localClientIdValue) ??
        AppStrings.defaultUserId;
    userName = localStorage.read(AppStrings.localClientNameValue) ?? "";
    print("UserId is $userId");
  }

  void updateGoalId(String tempId, String tempType) {
    goalId = tempId;
    goalType = tempType;
  }

  //Make All the Queries and Mutation here

  String convertStringToNotNull(var tempString) {
    return (tempString ?? AppStrings.defaultNullString).toString().trim();
  }

  String convertFrequencyToAppropriate(var tempValue) {
    if (tempValue == null || tempValue.toString().isEmpty) {
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
    if (tempValue == null || tempValue.toString().isEmpty) {
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
    if (tempValue == null || tempValue.toString().isEmpty) {
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
    if (tempValue == null || tempValue.toString().isEmpty) {
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
    if (tempValue == null || tempValue.toString().isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  String convertJDatetoDateText(var tempValue) {
    if (tempValue == null || tempValue.toString().isEmpty) {
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
    if (tempValue == null || tempValue.toString().isEmpty) {
      return AppStrings.defaultEndDate;
    }

    try {
      var updateTime = DateTime.tryParse(tempValue) ?? currentDateTime;
      return DateFormat('EEE').format(updateTime.toLocal());
    } catch (onError) {
      print("VEC - Convert JDate - Day Failed $onError");
      return AppStrings.defaultEndDate;
    }
  }

  String convertJTimeToTimeText(var tempValue) {
    if (tempValue == null || tempValue.toString().isEmpty) {
      return AppStrings.defaultTimeValue;
    }
    try {
      var updateTime = DateTime.tryParse(tempValue) ?? currentDateTime;
      return DateFormat('h:mm a').format(updateTime.toLocal());
    } catch (onError) {
      print("VEC - Convert JTime - Time Failed $onError");
      return AppStrings.defaultTimeValue;
    }
  }

  /*[{"date":"2023-06-01T10:15:55.469427Z","id":"1","time":"2023-06-01T10:15:55.469427Z","name":"One","status":"COMPLETED"},{"date":"2023-06-01T10:15:55.469427Z","id":"1","time":"2023-06-01T10:15:55.469427Z","name":"One","status":"COMPLETED"}]*/
  /*[{"date":,"id":,"time":,"name":,"status":}]*/

  NetworkCallEnum journeyNetworkEnum = NetworkCallEnum.Loading;

  void updateJouneyNetworkEnum(NetworkCallEnum tempValue) {
    journeyNetworkEnum = tempValue;
    update();
  }

  void getJourneyData({String localGoalId = "", String? newUserId, bool cleanCache = false}) async {
    String queryData = "";
    //Revert Testing purpose
    //userId = "2e1a8f17-fde1-4cb7-9e81-41afb6c9f9ad";
    if (localGoalId.isEmpty) {
      queryData = '''query MyQuery {
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
      if (newUserId != null) {
        queryData = '''query MyQuery {
  userJourneyByGoal(goalId: "$localGoalId", userId: "$newUserId") {
    date
    id
    name
    status
    time
  }
}
''';
      } else {
        queryData = '''query MyQuery {
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
    }

    var query = gql(queryData);
    //showPLoader();
    if(cleanCache){
      GraphQLService.tempWAClient.resetStore(refetchQueries: false);
    }

    updateJouneyNetworkEnum(NetworkCallEnum.Loading);
    /*var result = await GraphQLService.tempClient
        .query(QueryOptions(document: query));*/
    var result =
        await GraphQLService.makeGraphQLRequest(QueryOptions(document: query));
    //var result = await graphqlClient.query(QueryOptions(document: gql(mutation)));
    //It can have exception or data
    log(result.data.toString());
    //json.encode(result.data);
    //Hide Progress Bar
    //hidePLoader();
    if (!shouldContinueFurther("GetJourneyData", result)) {
      showErrorWOTitle("Failed to Get Journey Data");
      updateJouneyNetworkEnum(NetworkCallEnum.Error);
      return;
    }

    try {
      JourneyGoalModel journeyGoalModel =
          JourneyGoalModel.fromJson(result.data!);
      updateJouneyNetworkEnum(NetworkCallEnum.Completed);
      if (journeyGoalModel.journeyModelList.isEmpty) {
        journeyErrorText = AppStrings.errorJourneyData;
        update();
        return;
      }
      journeyGoalList.clear();
      journeyGoalList = journeyGoalModel.journeyModelList;
      // Sort the list based on the 'date' attribute in ascending order.
      journeyGoalList.sort((a, b) => a.date.compareTo(b.date));

      update();
    } catch (onError, stackTrace) {
      print(
          "Error while parsing Journey Goal Model $onError and Stack trace is $stackTrace");
      updateJouneyNetworkEnum(NetworkCallEnum.Error);
    }
  }

  void getFromJourneyJson({bool localIsJourney = false}) {
    var tempResult = json.decode(journeyJson);
    if (localIsJourney) {
      print("Journey Goal is shown");
      tempResult = json.decode(journeyGJson);
    }
    try {
      JourneyGoalModel journeyGoalModel = JourneyGoalModel.fromJson(tempResult);
      print("Length of List is ${journeyGoalModel.journeyModelList.length}");
      journeyGoalList.clear();
      journeyGoalList = journeyGoalModel.journeyModelList;
      // Sort the list based on the 'date' attribute in ascending order.
      journeyGoalList.sort((a, b) => a.date.compareTo(b.date));
      update();
    } catch (onError, stackTrace) {
      print("Error while parsing Journey Goal Model $onError");
    }
  }

  //Show Bottom Sheet for editing of Goal name and Description
  void editGoalNDSheet({Color selectedColor = Colors.red}) {
    var name = convertStringToNotNull(userGoalPerInfo?.goalInfo.name ?? "");
    var desc = convertStringToNotNull(userGoalPerInfo?.goalInfo.desc);
    print("Show Goal Name and Description Sheet");
    Get.bottomSheet(
        Padding(
          padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 5.h),
          child: EditGoalNDView(
            name: name,
            description: desc,
            selectedColor: selectedColor,
          ),
        ),
        backgroundColor: Colors.white);
  }

  void editGoalActivitySheet(
      IndividualGoalActivityModel activityModel, int listIndex,
      {Color selectedColor = Colors.red}) async {
    print("Edit Individual Activity Sheet ${activityModel.toString()}");
    if (Get.context == null) {
      return;
    }
    var result = await showModalBottomSheet(
        context: Get.context!,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: true,
        elevation: 15,
        builder: (context) {
          return Container(
              height: 80.h,
              color: Colors.white,
              /*decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
          ),*/
              child: EditGoalActivityView(
                activityModel: activityModel,
                selectedColor: selectedColor,
              ));
        });

    print("Updated InitialActivity is ${result.toString()}");

    if (result == null) {
      return;
    }

    try {
      var errorResponse =
          await mutateActivityCreated(result as IndividualGoalActivityModel);
      if (errorResponse != null) {
        showErrorWOTitle(errorResponse);
        return;
      }
      selectedGoalActivityList[listIndex] = result;
      update();

      showPSuccess("Activity Edited Successfully",
          selectedColor: AppColors.makeColorDarker(
              selectedColor, AppIntegers.colorDarkerValue));
    } catch (onError, Stacktrace) {
      print(
          "Failed to UpdateActivity this is response $onError Error Stack Trace $Stacktrace");
    }
  }

  Future<String?> mutateActivityCreated(
      IndividualGoalActivityModel tempModel) async {
    var mutation = gql(
        '''mutation MyMutation( \$customDay: [String] = ${json.encode(tempModel.customDay)}, \$monthDay: [String] = ${json.encode(tempModel.monthDay)}, \$weekDay: [String] = ${json.encode(tempModel.weekDay)}) {
  updateActivity(activity: {customDay: \$customDay, desc: "${tempModel.desc}", 
  duration: "${tempModel.duration.toString()}", endDt: "${tempModel.endDt}", 
  freq: "${tempModel.freq}", monthDay: \$monthDay, 
  name: "${tempModel.name}", reminder: "${tempModel.reminder}", 
  time: "${tempModel.time}", weekDay: \$weekDay, id: "${tempModel.id}", instrFile : "${tempModel.instrFile.toString()}"}) {
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
    instrFile
  }
}''');

    showPLoader();
    /*var result = await GraphQLService.tempClient
        .mutate(MutationOptions(document: mutation));*/
    var result = await GraphQLService.makeGraphMRequest(
        MutationOptions(document: mutation));
    //var result = await graphqlClient.query(QueryOptions(document: gql(mutation)));
    //It can have exception or data
    log(result.data.toString());
    //json.encode(result.data);
    //Hide Progress Bar
    hidePLoader();
    if (!shouldContinueFurther("EditGoalActivityData", result)) {
      return "Failed to Update Goal Activity";
    }
    return null;
  }

  /*
  {__typename: Mutation, updateGoalMeta: {__typename: Goal, id: f9f004da-d869-4a6b-b530-ff15956d1f8b, name: Goal - Cycling, desc: This goal will help us to focus on improving health. Focus would be on the topic such as stamina.}}
   */
  void updateGoalND(String tempName, String tempDesc) async {
    print("Initiate Mutation for tempName, TempDesc");

    var mutation = gql("""
  mutation MyMutation {
  updateGoalMeta(goal: {id: "$goalId", desc: "$tempDesc", name: "$tempName"}) {
    id
    name
    desc
    type
  }
}
""");

    //Show Progress Bar
    showPLoader();
    /*var result = await GraphQLService.tempClient
        .mutate(MutationOptions(document: mutation));*/
    var result = await GraphQLService.makeGraphMRequest(
        MutationOptions(document: mutation));
    //var result = await graphqlClient.query(QueryOptions(document: gql(mutation)));
    //It can have exception or data
    log(result.data.toString());
    //json.encode(result.data);
    //Hide Progress Bar
    hidePLoader();
    if (!shouldContinueFurther("EditGoalMetaData", result)) {
      showErrorWOTitle("Failed to Update Goal Name and Desc");
      Get.back();
      return;
    }

    SuccessGoalMetaDataModel successGoalMetaDataModel =
        SuccessGoalMetaDataModel.fromJson(result.data!);

    goalName.value = successGoalMetaDataModel.goalMetaDataModel.name;
    goalDesc.value = successGoalMetaDataModel.goalMetaDataModel.desc;
    Get.back();

    try {
      print(
          "Selected Index item ${activeGoalList.elementAt(selectedGoalListIndex)}");
      activeGoalList.elementAt(selectedGoalListIndex).goalInfo =
          successGoalMetaDataModel.goalMetaDataModel;
      update();
    } catch (onError, stackTrace) {
      print(
          "Failed Updating the Goal Active List $onError and StackTrace is $stackTrace");
    }
  }

  bool shouldContinueFurther(
    String? tempName,
    QueryResult<Object?> result,
  ) {
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

    var mutation = gql("""mutation MyMutation {
  endGoal(goalId: "$goalId") {
    id
    status
    name
  }
}

""");

    showPLoader();
/*    var result = await GraphQLService.tempClient
        .mutate(MutationOptions(document: mutation));*/
    var result = await GraphQLService.makeGraphMRequest(
        MutationOptions(document: mutation));
    //var result = await graphqlClient.query(QueryOptions(document: gql(mutation)));
    //It can have exception or data
    log(result.data.toString());
    //json.encode(result.data);
    //Hide Progress Bar
    hidePLoader();
    if (!shouldContinueFurther("EndGoalM", result)) {
      showErrorWOTitle("Failed to end goal mutation");
      return;
    }

    try {
      var item = activeGoalList.removeAt(selectedGoalListIndex);
      print("Item is ${item.goalInfo.name}");
      endedGoalList.add(item);
      selectedGoalListIndex = 0;
      update();
      Get.back();
      showPSuccess("${item.goalInfo.name ?? ""} Successfully Archived");
    } catch (onError, stackTrace) {
      print(
          "Failed Updating active goal to end goal $onError, StackTrace is $stackTrace");
    }
  }

  void updateUserGoalPerInfo(UserGoalPerInfo tempUserInfo) {
    userGoalPerInfo = tempUserInfo;
    goalName.value =
        userGoalPerInfo?.goalInfo.name ?? AppStrings.defaultDescription;
    goalDesc.value =
        userGoalPerInfo?.goalInfo.desc ?? AppStrings.defaultDescription;
  }

  void updateSelectedItemIndex(int itemIndex) {
    selectedGoalListIndex = itemIndex;
  }

  NetworkCallEnum aeGoalNetworkEnum = NetworkCallEnum.Loading;

  void updateAEGoalNetworkEnum(NetworkCallEnum tempValue) {
    aeGoalNetworkEnum = tempValue;
    update();
  }

  //Get Active or Ended Goal
  void getAEGoal() async {
    ///View Goal - Active
    final query = gql('''query MyQuery {
    userNotifyInfo(userId: "4e5d361f-1242-4e73-ab98-fe27196ab09a") {
     read
     unread
  }
  userGoalsWithPerfInfo(userId: "$userId") {
     goalInfo {
      activities
      backup
      collabType
      createdBy
      createdByName
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

    updateAEGoalNetworkEnum(NetworkCallEnum.Loading);
    /*var result =
        await GraphQLService.tempClient.query(QueryOptions(document: query));*/
    var result =
        await GraphQLService.makeGraphQLRequest(QueryOptions(document: query));
    //print("Temporary Results are $tempResult");

    //It can have exception or data
    log(result.data.toString());
    //json.encode(result.data);
    if (result.data == null && result.exception != null) {
      //No Data Received from Server;
      parseError(result.exception, "FetchActiveEndedGoalList");
      updateAEGoalNetworkEnum(NetworkCallEnum.Error);
      return;
    }

    try {
      GoalMetaDataModel goalActivityModel =
          GoalMetaDataModel.fromJson(result.data!);
      print("Length of List is ${goalActivityModel.userGoalPerList.length}");
      parseIntoAEGoalList(goalActivityModel.userGoalPerList);
      updateAEGoalNetworkEnum(NetworkCallEnum.Completed);
      try{
        if(goalActivityModel.userNotifyInfo != null && goalActivityModel.userNotifyInfo!.unread != null && goalActivityModel.userNotifyInfo!.unread != "0"){
          showNotifDot.value = true;
        }
      }catch(onError, stack){
        print("Failed updating the userNotification Info $onError");
      }

    } catch (onError, stackTrace) {
      print("Error while parsing GoalActivityModel $onError");
      updateAEGoalNetworkEnum(NetworkCallEnum.Error);
    }
    GraphQLService.parseName();
  }

  NetworkCallEnum goalActivityNetworkEnum = NetworkCallEnum.Loading;

  void updateGoalActivityNetworkEnum(NetworkCallEnum tempValue) {
    goalActivityNetworkEnum = tempValue;
    update();
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
    instrFile
  }
}
''');

    updateGoalActivityNetworkEnum(NetworkCallEnum.Loading);
    /*var result =
        await GraphQLService.tempClient.query(QueryOptions(document: query));*/
    var result =
        await GraphQLService.makeGraphQLRequest(QueryOptions(document: query));
    //It can have exception or data
    //log(result.data.toString());
    //json.encode(result.data);
    if (!shouldContinueFurther("FetchGoalActivitiesData", result)) {
      showErrorWOTitle("Failed to Fetch Goal Activities");
      updateGoalActivityNetworkEnum(NetworkCallEnum.Error);
      return;
    }

    try {
      GoalActivityModel goalActivityModel =
          GoalActivityModel.fromJson(result.data!);
      print("Length of List is ${goalActivityModel.goalActivityList.length}");
      selectedGoalActivityList.clear();
      selectedGoalActivityList = goalActivityModel.goalActivityList;
      update();
      updateGoalActivityNetworkEnum(NetworkCallEnum.Completed);
    } catch (onError, stackTrace) {
      print("Error while parsing FetchGoalActivitiesData $onError");
      updateGoalActivityNetworkEnum(NetworkCallEnum.Error);
    }
  }

  var participantNetworkEnum = NetworkCallEnum.Loading.obs;

  void updateParticipantNetworkEnum(NetworkCallEnum tempValue) {
    participantNetworkEnum.value = tempValue;
  }

  //Get Participants Goal Data
  void getGoalParticipantData(String goalId) async {
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

    updateParticipantNetworkEnum(NetworkCallEnum.Loading);
    /*var result =
        await GraphQLService.tempClient.query(QueryOptions(document: query));*/
    var result =
        await GraphQLService.makeGraphQLRequest(QueryOptions(document: query));
    //It can have exception or data
    log(result.data.toString());
    //json.encode(result.data);
    if (!shouldContinueFurther("FetchGoalParticipantData", result)) {
      showErrorWOTitle("Failed to Update Goal Participant");
      updateParticipantNetworkEnum(NetworkCallEnum.Error);
      return;
    }

    try {
      GoalMemberModel goalMemberModel = GoalMemberModel.fromJson(result.data!);
      print("Length of List is ${goalMemberModel.goalMemberList.length}");
      selectedGoalMemberList.value.clear();
      selectedGoalMemberList.value = goalMemberModel.goalMemberList;
      updateParticipantNetworkEnum(NetworkCallEnum.Completed);
    } catch (onError, stackTrace) {
      print("Error while parsing FetchGoalMembershipData $onError");
      updateParticipantNetworkEnum(NetworkCallEnum.Error);
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
    update();
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
  void updateJourneyMutation(
    JourneyMutationEnum tempJEnum,
    int index, {
    String taskId = "",
  }) async {
    print("Mutation Called is ${tempJEnum}");

    String mutationData = '';
    switch (tempJEnum) {
      case JourneyMutationEnum.SkipIt:
        mutationData = '''mutation MyMutation {
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
        mutationData = '''mutation MyMutation {
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

    var mutation = gql(mutationData);

    showPLoader();
    /*var result = await GraphQLService.tempClient
        .mutate(MutationOptions(document: mutation));*/
    var result = await GraphQLService.makeGraphMRequest(
        MutationOptions(document: mutation));
    //var result = await graphqlClient.query(QueryOptions(document: gql(mutation)));
    //It can have exception or data
    log(result.data.toString());
    //json.encode(result.data);
    //Hide Progress Bar
    hidePLoader();
    if (!shouldContinueFurther("Journey Mutation Failed", result)) {
      showErrorWOTitle("Failed to update journey Status");
      return;
    }

    switch (tempJEnum) {
      case JourneyMutationEnum.SkipIt:
        journeyGoalList.elementAt(index).status = "skipped";
        break;
      case JourneyMutationEnum.MarkasComplete:
        journeyGoalList.elementAt(index).status = "completed";
        break;
    }
    update();
  }

  JourneyStatus convertJStatusToJourney(var tempStatus, var tempDate) {
    if (tempStatus == null) {
      return JourneyStatus.Failed;
    }

    DateTime updateTempDate = DateTime.tryParse(tempDate) ?? currentDateTime;

    var tempString = tempStatus.toString().trim().toLowerCase();
    //print("Journey Status is ${tempString}");
    if (tempString == "completed" || tempString == "complete") {
      return JourneyStatus.Success;
    } else if (tempString == "skipped") {
      return JourneyStatus.Failed;
    } else if ((tempString != "completed" || tempString != "complete") &&
        updateTempDate.isBefore(currentDateTime)) {
      return JourneyStatus.Overdue;
    } else if (updateTempDate.isAfter(currentDateTime)) {
      return JourneyStatus.Upcoming;
    }
      else {
      return JourneyStatus.Failed;
    }

  }

  void updateActivityModel(IndividualGoalActivityModel activityModel) {
    print("Updated Activity Model is ${activityModel.toString()}");
  }

  void refreshGoalActivityList() {
    GraphQLService.tempWAClient.resetStore(refetchQueries: false);
    getGoalActivitiesData(goalId);
  }

  void refreshAEGoalList() {
    GraphQLService.tempWAClient.resetStore(refetchQueries: false);
    getAEGoal();
  }

  void addMoreParticipants({required Color selectedColor}) async {
    if (Get.context == null) {
      return;
    }

    final permissionManager = PermissionManager(Get.context!);

    var response = await permissionManager.askForPermissionAndNavigate(null);
    if (!response) {
      return;
    }

    List<Contact> contactList = await ContactsService.getContacts(
        withThumbnails: false,
        photoHighResolution: false,
        iOSLocalizedLabels: false,
        androidLocalizedLabels: false);

    //Add Me
    var localName = localStorage.read(AppStrings.localClientNameValue) ??
        AppStrings.emptyName;
    Contact selfContact = Contact(
        displayName: "$localName",
        givenName: "self_selected",
        phones: [Item(value: "", label: "self")]);
    contactList.insert(0, selfContact);
    var result = await showModalBottomSheet(
        context: Get.context!,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: true,
        elevation: 15,
        builder: (context) {
          return Container(
              height: 80.h,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: MultiSelectContacts(
                contactsList: contactList,
                selectedColor: selectedColor,
              ));
        });
    print("Multi Select contact result ${result.runtimeType}");
    if (result != null) {
      var response = await createGroupGoalMemberMutation(result);
      if (response) {
        GraphQLService.tempWAClient.resetStore(refetchQueries: false);
        getGoalParticipantData(goalId);
        getAEGoal();
      }
    }
  }

  Future<bool> createGroupGoalMemberMutation(List<Contact?> contact) async {
    List<IndividualGoalMemberModel> groupMembers = contact.map((e) {
      if (e != null && e.givenName != null && e.givenName == "self_selected") {
        print("Self Was Selected");
        return IndividualGoalMemberModel(
          createdBy: userId,
          createdDt: currentDateTime.toIso8601String(),
          deviceId: "",
          fullname: e?.displayName ?? "",
          modifiedBy: userId,
          modifiedDt: currentDateTime.toIso8601String(),
          id: userId,
          ph: "-1",
        );
      }
      return IndividualGoalMemberModel(
        createdBy: userId,
        createdDt: currentDateTime.toIso8601String(),
        deviceId: "",
        fullname: e?.displayName ?? "",
        modifiedBy: userId,
        modifiedDt: currentDateTime.toIso8601String(),
        ph: e?.phones?[0].value ?? "",
      );
    }).toList();
    var mutation = gql(
        '''mutation MyMutation(\$goalId: String!, \$goalMembers: [UserIP]!) {
      addGoalMembers(goalId: \$goalId, goalMembers: \$goalMembers) {
        createdBy
        fullname
        deviceId
        id
        modifiedBy
        modifiedDt
        ph
      }

 udpateCollabType(goalId: \$goalId, type: "GROUP") {
    id
    collabType
    desc
    name
  }

}
''');

    print("Group Mutation is $mutation");
    showPLoader();
    try {
      /*var result = await GraphQLService.tempClient
          .mutate(MutationOptions(document: mutation,variables: {
        'goalId': goalId, // Set the value for \$goalId
        'goalMembers': groupMembers.map((member) => member.toJson()).toList(), // Set the value for \$goalMembers
      }));*/

      var result = await GraphQLService.makeGraphMRequest(
          MutationOptions(document: mutation, variables: {
        'goalId': goalId, // Set the value for \$goalId
        'goalMembers': groupMembers
            .map((member) => member.toJson())
            .toList(), // Set the value for \$goalMembers
      }));
      //var result = await graphqlClient.query(QueryOptions(document: gql(mutation)));
      //It can have exception or data
      log(result.data.toString());
      //json.encode(result.data);
      hidePLoader();
      if (result.data == null && result.exception != null) {
        //No Data Received from Server;
        GraphQLService.parseError(
            result.exception, "Add Member to Participants Mutation");
        return false;
      }
    } catch (onError, stacktrace) {
      print("Group Mutation Error is $onError");
      print("Failed at $stacktrace");
      hidePLoader();
      return false;
    }

    return true;
  }

  //Goal
  Future<bool> mutationGoalMemberRemove(
      String memberID, int positionIndex) async {
    print("Member Remove Mutation is $memberID");

    var mutation = gql('''mutation MyMutation {
  removeGoalMember(goalId: "$goalId", userId: "$memberID") {
    activities
    id
  }
}
''');
    showPLoader();
    try {
      /*var result = await GraphQLService.tempClient
          .mutate(MutationOptions(document: mutation));*/
      var result = await GraphQLService.makeGraphMRequest(
          MutationOptions(document: mutation));
      //var result = await graphqlClient.query(QueryOptions(document: gql(mutation)));
      //It can have exception or data
      log(result.data.toString());
      //json.encode(result.data);
      hidePLoader();
      if (result.data == null && result.exception != null) {
        //No Data Received from Server;
        GraphQLService.parseError(
            result.exception, "Remove Group Member Mutation");
        return false;
      }

      selectedGoalMemberList.removeAt(positionIndex);

      return true;
    } catch (onError, stacktrace) {
      print("Remove Group Member Mutation is $onError");
      print("Failed at $stacktrace");
      hidePLoader();
      return false;
    }
  }

  Future<bool> mutationGoalMemberBackup(String tempId) async {
    print("Member Remove Mutation is $tempId");

    var mutation = gql('''mutation MyMutation {
  setBackup(goalId: "$goalId", userId: "$tempId") {
    id
    mentor
    backup
  }
}
''');
    showPLoader();
    try {
      /*var result = await GraphQLService.tempClient
          .mutate(MutationOptions(document: mutation));*/
      var result = await GraphQLService.makeGraphMRequest(
          MutationOptions(document: mutation));
      //var result = await graphqlClient.query(QueryOptions(document: gql(mutation)));
      //It can have exception or data
      log(result.data.toString());
      //json.encode(result.data);
      hidePLoader();
      if (result.data == null && result.exception != null) {
        //No Data Received from Server;
        GraphQLService.parseError(
            result.exception, "Backup Group Member Mutation");
        return false;
      }
    } catch (onError, stacktrace) {
      print("Backup Group Member Mutation is $onError");
      print("Failed at $stacktrace");
      hidePLoader();
      return false;
    }
    return true;
  }

  Future<bool> mutationGoalMemberMentor(
      String memberID, String mentorID) async {
    print("Member Mentor Mutation is $memberID $mentorID");

    var mutation = gql('''mutation MyMutation {
setMemberMentor(goalId: "$goalId", memberId: "$memberID", mentorId: "$mentorID") {
    collabType
    id
    members {
      mentorId
      userId
    }
  }
}
''');

    showPLoader();
    try {
      /*var result = await GraphQLService.tempClient
          .mutate(MutationOptions(document: mutation));*/
      var result = await GraphQLService.makeGraphMRequest(
          MutationOptions(document: mutation));
      //var result = await graphqlClient.query(QueryOptions(document: gql(mutation)));
      //It can have exception or data
      log(result.data.toString());
      //json.encode(result.data);
      hidePLoader();
      if (result.data == null && result.exception != null) {
        //No Data Received from Server;
        GraphQLService.parseError(
            result.exception, "Mentor Group Member Mutation");
        return false;
      }
      return true;
    } catch (onError, stacktrace) {
      print("Mentor Group Member Mutation is $onError");
      print("Failed at $stacktrace");
      hidePLoader();
      return false;
    }
  }

  Future<String?> mutationGoalMemberMentorV1(
      String memberID, String name, String phone, String givenName) async {
    print("Member Mentor is $memberID");

    var localDeviceId = localStorage.read(AppStrings.localDeviceIdValue) ?? "";
    String mutationString;

    if (givenName == "self_selected") {
      mutationString = '''mutation MyMutation {
  setMemberMentor_v1(goalId: "$goalId", memberId: "$memberID", mentor: {createdBy: "$userId", createdDt: "${currentDateTime.toIso8601String()}", deviceId: "$localDeviceId", fullname: "$name", modifiedBy: "$userId", modifiedDt: "${currentDateTime.toIso8601String()}", ph: "-1", id: "$userId"}) {
      mentorId
      userId
  }
}

''';
    } else {
      mutationString = '''mutation MyMutation {
  setMemberMentor_v1(goalId: "$goalId", memberId: "$memberID", mentor: {createdBy: "$userId", createdDt: "${currentDateTime.toIso8601String()}", deviceId: "$localDeviceId", fullname: "$name", modifiedBy: "$userId", modifiedDt: "${currentDateTime.toIso8601String()}", ph: "$phone"}) {
      mentorId
      userId
  }
}

''';
    }

    var mutation = gql(mutationString);

    showPLoader();
    try {
      /*var result = await GraphQLService.tempClient
          .mutate(MutationOptions(document: gql(mutation)));*/
      var result = await GraphQLService.makeGraphMRequest(
          MutationOptions(document: mutation));
      //var result = await graphqlClient.query(QueryOptions(document: gql(mutation)));
      //It can have exception or data
      log(result.data.toString());
      //json.encode(result.data);
      hidePLoader();
      if (result.data == null && result.exception != null) {
        //No Data Received from Server;
        GraphQLService.parseError(
            result.exception, "Mentor Group Member Mutation");
        return null;
      }
      SuccessGoalMentorDataModel successGoalMentorDataModel =
          SuccessGoalMentorDataModel.fromJson(result.data!);
      print(
          "Mentor Id is ${successGoalMentorDataModel.setMemberMentorModel.mentorId}");
      return successGoalMentorDataModel.setMemberMentorModel.mentorId ?? "";
    } catch (onError, stacktrace) {
      print("Mentor Group Member Mutation is $onError");
      print("Failed at $stacktrace");
      hidePLoader();
      return null;
    }
  }

  void showJourneyBottomSheet({required participantId}) async {
    await showModalBottomSheet(
        context: Get.context!,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: true,
        elevation: 15,
        builder: (context) {
          return Container(
              height: 80.h,
              color: Colors.white,
              /*decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
          ),*/
              child: Journey_View(
                goalId: goalId,
                participantId: participantId,
              ));
        });
  }

  String journeyErrorText = AppStrings.errorJourneyData;

  void restrictedJourneyAccess() {
    journeyErrorText =
        "You do not have any activities to do as you are not a participant in this goal";
    update();
  }

  void refreshJourneyData({required String localGoalId, String? newUserId}) {
    GraphQLService.tempWAClient.resetStore(refetchQueries: false);
    getJourneyData(localGoalId: localGoalId, newUserId: newUserId);
  }

  void addMoreActivity() async{
    print("Add More Activity is Pressed");
    print("Name of Goal is ${goalType}");
    await Get.to(()=>CreateGoalActivities(selectedGoal: goalType,isFromGoalDetail: true,editedGoalId: goalId,));
    //Refresh this list
    refreshGoalActivityList();
  }
}
