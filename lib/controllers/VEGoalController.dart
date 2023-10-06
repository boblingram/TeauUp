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
import 'package:teamup/models/SuccessGoalMetaDataModel.dart';
import 'package:teamup/utils/Enums.dart';
import 'package:teamup/utils/GraphQLService.dart';
import 'package:teamup/utils/app_strings.dart';
import 'package:teamup/utils/json_constants.dart';
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
  var endedGoalList = <UserGoalPerInfo>[].obs;

  String goalId = "";
  UserGoalPerInfo? userGoalPerInfo;
  var selectedGoalListIndex = 0;

  var selectedGoalActivityList = <IndividualGoalActivityModel>[];
  var selectedGoalMemberList = <IndividualGoalMemberModel>[].obs;

  var currentDateTime = DateTime.now();

  var journeyGoalList = <JourneyGoalDataModel>[];

  var goalName = "".obs;
  var goalDesc = "".obs;

  final localStorage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    userId = localStorage.read(AppStrings.localClientIdValue) ?? AppStrings.defaultUserId;
    print("UserId is $userId");
  }

  void updateGoalId(String tempId) {
    goalId = tempId;
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
      return DateFormat('EEE').format(updateTime);
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
      return DateFormat('h:mm a').format(updateTime);
    } catch (onError) {
      print("VEC - Convert JTime - Time Failed $onError");
      return AppStrings.defaultTimeValue;
    }
  }

  /*[{"date":"2023-06-01T10:15:55.469427Z","id":"1","time":"2023-06-01T10:15:55.469427Z","name":"One","status":"COMPLETED"},{"date":"2023-06-01T10:15:55.469427Z","id":"1","time":"2023-06-01T10:15:55.469427Z","name":"One","status":"COMPLETED"}]*/
  /*[{"date":,"id":,"time":,"name":,"status":}]*/

  void getJourneyData({String localGoalId = ""}) async {
    String queryData = "";
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

    var query = gql(queryData);
    showLoader();

    /*var result = await GraphQLService.tempClient
        .query(QueryOptions(document: query));*/
    var result = await GraphQLService.makeGraphQLRequest(QueryOptions( document: query));
    //var result = await graphqlClient.query(QueryOptions(document: gql(mutation)));
    //It can have exception or data
    log(result.data.toString());
    //json.encode(result.data);
    //Hide Progress Bar
    hidePLoader();
    if (!shouldContinueFurther("GetJourneyData", result)) {
      showErrorWOTitle("Failed to Get Journey Data");
      return;
    }

    try {
      JourneyGoalModel journeyGoalModel =
          JourneyGoalModel.fromJson(result.data!);
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

  void editGoalActivitySheet(IndividualGoalActivityModel activityModel, int listIndex, {Color selectedColor = Colors.red}) async {
    print("Edit Individual Activity Sheet");
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

    if(result == null){
      return;
    }

    try{
      var errorResponse = await mutateActivityCreated(result as IndividualGoalActivityModel);
      if(errorResponse != null){
        showErrorWOTitle(errorResponse);
        return;
      }
      selectedGoalActivityList[listIndex] = result;
      update();
      showSuccess("Activity Edited Successfully");
    }catch(onError, Stacktrace){
      print("Failed to UpdateActivity this is response $onError Error Stack Trace $Stacktrace");
    }
  }

  Future<String?> mutateActivityCreated(IndividualGoalActivityModel tempModel) async{
    var mutation = gql('''mutation MyMutation( \$customDay: [String] = ${json.encode(tempModel.customDay)}, \$monthDay: [String] = ${json.encode(tempModel.monthDay)}, \$weekDay: [String] = ${json.encode(tempModel.weekDay)}) {
  updateActivity(activity: {customDay: \$customDay, desc: "${tempModel.desc}", 
  duration: "${tempModel.duration.toString()}", endDt: "${tempModel.endDt}", 
  freq: "${tempModel.freq}", monthDay: \$monthDay, 
  name: "${tempModel.name}", reminder: "${tempModel.reminder}", 
  time: "${tempModel.time}", weekDay: \$weekDay, id: "${tempModel.id}"}) {
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
}''');

    showLoader();
    /*var result = await GraphQLService.tempClient
        .mutate(MutationOptions(document: mutation));*/
    var result = await GraphQLService.makeGraphMRequest(MutationOptions( document: mutation));
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
  }
}
""");

    //Show Progress Bar
    showLoader();
    /*var result = await GraphQLService.tempClient
        .mutate(MutationOptions(document: mutation));*/
    var result = await GraphQLService.makeGraphMRequest(MutationOptions( document: mutation));
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

    try{
      print("Selected Index item ${activeGoalList.elementAt(selectedGoalListIndex)}");
      activeGoalList.elementAt(selectedGoalListIndex).goalInfo = successGoalMetaDataModel.goalMetaDataModel;
      update();
    }catch(onError, stackTrace){
      print("Failed Updating the Goal Active List $onError and StackTrace is $stackTrace");
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

    showLoader();
/*    var result = await GraphQLService.tempClient
        .mutate(MutationOptions(document: mutation));*/
    var result = await GraphQLService.makeGraphMRequest(MutationOptions( document: mutation));
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

    try{
      var item = activeGoalList.removeAt(selectedGoalListIndex);
      print("Item is ${item.goalInfo.name}");
      endedGoalList.add(item);
      selectedGoalListIndex = 0;
      update();
      Get.back();
      showSuccess("${item.goalInfo.name ?? ""} Successfully Archived");
    }catch(onError, stackTrace){
      print("Failed Updating active goal to end goal $onError, StackTrace is $stackTrace");
    }
  }

  void updateUserGoalPerInfo(UserGoalPerInfo tempUserInfo) {
    userGoalPerInfo = tempUserInfo;
    goalName.value = userGoalPerInfo?.goalInfo.name ?? AppStrings.defaultDescription;
    goalDesc.value = userGoalPerInfo?.goalInfo.desc ?? AppStrings.defaultDescription;
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

    /*var result =
        await GraphQLService.tempClient.query(QueryOptions(document: query));*/
    var result = await GraphQLService.makeGraphQLRequest(QueryOptions( document: query));
    //print("Temporary Results are $tempResult");

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
    GraphQLService.parseName();
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

    /*var result =
        await GraphQLService.tempClient.query(QueryOptions(document: query));*/
    var result = await GraphQLService.makeGraphQLRequest(QueryOptions( document: query));
    //It can have exception or data
    //log(result.data.toString());
    //json.encode(result.data);
    if (!shouldContinueFurther("FetchGoalActivitiesData", result)) {
      showErrorWOTitle("Failed to Fetch Goal Activities");
      return;
    }

    try {
      GoalActivityModel goalActivityModel =
          GoalActivityModel.fromJson(result.data!);
      print("Length of List is ${goalActivityModel.goalActivityList.length}");
      selectedGoalActivityList.clear();
      selectedGoalActivityList = goalActivityModel.goalActivityList;
      update();
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

    /*var result =
        await GraphQLService.tempClient.query(QueryOptions(document: query));*/
    var result = await GraphQLService.makeGraphQLRequest(QueryOptions( document: query));
    //It can have exception or data
    //log(result.data.toString());
    //json.encode(result.data);
    if (!shouldContinueFurther("FetchGoalMembershipData", result)) {
      showErrorWOTitle("Failed to Update Goal Membership");
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
  void updateJourneyMutation(JourneyMutationEnum tempJEnum, int index,
      {String taskId = "",}) async {
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

    showLoader();
    /*var result = await GraphQLService.tempClient
        .mutate(MutationOptions(document: mutation));*/
    var result = await GraphQLService.makeGraphMRequest(MutationOptions( document: mutation));
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

    switch(tempJEnum){
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
    if (updateTempDate.isAfter(currentDateTime)) {
      return JourneyStatus.Upcoming;
    }

    var tempString = tempStatus.toString().trim().toLowerCase();
    if (tempString == "completed") {
      return JourneyStatus.Success;
    } else if (tempString == "skipped") {
      return JourneyStatus.Failed;
    } else if (tempString != "completed" &&
        updateTempDate.isBefore(currentDateTime)) {
      return JourneyStatus.Overdue;
    } else {
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

  void addMoreParticipants() async {
    if(Get.context == null){
      return;
    }

    final permissionManager = PermissionManager(Get.context!);

    var response = await permissionManager.askForPermissionAndNavigate(null);
    if(!response){
      return;
    }

    List<Contact> contactList = await ContactsService.getContacts(withThumbnails: false,photoHighResolution: false,iOSLocalizedLabels: false,androidLocalizedLabels: false);
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
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
              ),
              child: MultiSelectContacts(contactsList: contactList,));
        });
    print("Multi Select contact result ${result.runtimeType}");
    if(result != null){
      var response = await createGroupGoalMemberMutation(result);
      if(response){
        GraphQLService.tempWAClient.resetStore(refetchQueries: false);
        getGoalMembershipData(goalId);
      }
    }
  }

  Future<bool> createGroupGoalMemberMutation(List<Contact?> contact) async {
    List<IndividualGoalMemberModel> groupMembers = contact
        .map((e) => IndividualGoalMemberModel(
      createdBy: userId,
      createdDt: currentDateTime.toIso8601String(),
      deviceId: "",
      fullname: e?.displayName ?? "",
      modifiedBy: userId,
      modifiedDt: currentDateTime.toIso8601String(),
      ph: e?.phones?[0].value ?? "",
    ))
        .toList();
    var mutation =
    gql('''mutation MyMutation(\$goalId: String!, \$goalMembers: [UserIP]!) {
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
    showLoader();
    try {
      /*var result = await GraphQLService.tempClient
          .mutate(MutationOptions(document: mutation,variables: {
        'goalId': goalId, // Set the value for \$goalId
        'goalMembers': groupMembers.map((member) => member.toJson()).toList(), // Set the value for \$goalMembers
      }));*/

      var result = await GraphQLService.makeGraphMRequest(MutationOptions( document: mutation,variables: {
      'goalId': goalId, // Set the value for \$goalId
      'goalMembers': groupMembers.map((member) => member.toJson()).toList(), // Set the value for \$goalMembers
      }));
      //var result = await graphqlClient.query(QueryOptions(document: gql(mutation)));
      //It can have exception or data
      log(result.data.toString());
      //json.encode(result.data);
      hidePLoader();
      if (result.data == null && result.exception != null) {
        //No Data Received from Server;
        GraphQLService.parseError(result.exception, "Add Member to Participants Mutation");
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
  Future<bool> mutationGoalMemberRemove(String memberID, int positionIndex) async{
    print("Member Remove Mutation is $memberID");


    var mutation =
    gql('''mutation MyMutation {
  removeGoalMember(goalId: "$goalId", userId: "$memberID") {
    activities
    id
  }
}
''');
    showLoader();
    try {
      /*var result = await GraphQLService.tempClient
          .mutate(MutationOptions(document: mutation));*/
      var result = await GraphQLService.makeGraphMRequest(MutationOptions( document: mutation));
      //var result = await graphqlClient.query(QueryOptions(document: gql(mutation)));
      //It can have exception or data
      log(result.data.toString());
      //json.encode(result.data);
      hidePLoader();
      if (result.data == null && result.exception != null) {
        //No Data Received from Server;
        GraphQLService.parseError(result.exception, "Remove Group Member Mutation");
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

  Future<bool> mutationGoalMemberBackup(String tempId) async{
    print("Member Remove Mutation is $tempId");

    var mutation =
    gql('''mutation MyMutation {
  setBackup(goalId: "$goalId", userId: "$tempId") {
    id
    mentor
    backup
  }
}
''');
    showLoader();
    try {
      /*var result = await GraphQLService.tempClient
          .mutate(MutationOptions(document: mutation));*/
      var result = await GraphQLService.makeGraphMRequest(MutationOptions( document: mutation));
      //var result = await graphqlClient.query(QueryOptions(document: gql(mutation)));
      //It can have exception or data
      log(result.data.toString());
      //json.encode(result.data);
      hidePLoader();
      if (result.data == null && result.exception != null) {
        //No Data Received from Server;
        GraphQLService.parseError(result.exception, "Backup Group Member Mutation");
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

  Future<bool> mutationGoalMemberMentor(String memberID, String mentorID) async{
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

    showLoader();
    try {
      /*var result = await GraphQLService.tempClient
          .mutate(MutationOptions(document: mutation));*/
      var result = await GraphQLService.makeGraphMRequest(MutationOptions( document: mutation));
      //var result = await graphqlClient.query(QueryOptions(document: gql(mutation)));
      //It can have exception or data
      log(result.data.toString());
      //json.encode(result.data);
      hidePLoader();
      if (result.data == null && result.exception != null) {
        //No Data Received from Server;
        GraphQLService.parseError(result.exception, "Mentor Group Member Mutation");
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

}
