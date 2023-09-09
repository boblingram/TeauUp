import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:teamup/controllers/VEGoalController.dart';
import 'package:teamup/models/IndividualGoalMemberModel.dart';
import 'package:teamup/models/IndividualNotificationModel.dart';
import 'package:teamup/models/SuccessGoalMemberModel.dart';
import 'package:teamup/utils/Enums.dart';
import 'package:teamup/utils/GraphQLService.dart';

import '../models/IndividualGoalActivityModel.dart';
import '../utils/Constants.dart';
import '../widgets/EditGoalActivityView.dart';

class GoalController extends GetxController {
  var userId = "1";

  ///Notification Controller
  var notificationList = <IndividualNotificationModel>[];

  var currentTime = DateTime.now();

  void fetchNotificationData() async {
    String query = '''query MyQuery {
  toUserNotifications(userId: "$userId") {
    id
    msg 
    status
    type
    createdDt
  }
}
''';

    var result = await GraphQLService.tempClient
        .query(QueryOptions(document: gql(query)));
    log(result.data.toString());
    //json.encode(result.data);
    if (result.data == null && result.exception != null) {
      //No Data Received from Server;
      GraphQLService.parseError(result.exception, "Fetch Notification List");
      return;
    }

    try {
      NotificationDataModel notificationDataModel =
          NotificationDataModel.fromJson(result.data!);
      print(
          "Length of List is ${notificationDataModel.notificationDataList.length}");
      notificationList.clear();
      notificationList = notificationDataModel.notificationDataList;
      notificationList.sort((a, b) => a.createdDt.compareTo(b.createdDt));
      update();
    } catch (onError, stackTrace) {
      print("Error while parsing Notification Data Model $onError");
    }
  }

  void notificationMutationQuery(
      NotificationMutationEnum tempEnum, String notificationId, int rowIndex) async {
    print("Notification Mutation is ${tempEnum}");
    String mutation = '';
    if (tempEnum == NotificationMutationEnum.MarkasRead) {
      mutation = '''mutation MyMutation {
  completeTask(taskId: "$notificationId") {
    id
    name
    status
    time
    date
    activityId
  }
}
''';
    } else if (tempEnum == NotificationMutationEnum.Delete) {
      mutation = '''mutation MyMutation {
  skipTask(taskId: "$notificationId") {
    id
    name
    status
    time
    date
    activityId
  }
}
''';
    }

    showLoader();
    var result = await GraphQLService.tempClient
        .mutate(MutationOptions(document: gql(mutation)));
    log(result.toString());
    hidePLoader();
    if (!GraphQLService.shouldContinueFurther(
        "Mutate Notification ${tempEnum}", result)) {
      showErrorWOTitle("Failed to update notification status");
      return;
    }

    switch(tempEnum){
      case NotificationMutationEnum.Delete:
        notificationList.removeAt(rowIndex);
        update();
        break;
      case NotificationMutationEnum.MarkasRead:
        notificationList.elementAt(rowIndex).status = "read";
        update();
        break;
    }

  }

  ///Describe Goal
  var newGoalName = "";
  var newGoalDescription = "";
  var newSelectedGoalType = "";

  var tempGoalId = "73403221-09b6-400e-b214-8f4beb09b2b9";

  Future<bool> updateNameAndDescription(
      String name, String description, String selectedGoalType) async {
    newGoalName = name;
    newGoalDescription = description;
    newSelectedGoalType = selectedGoalType;

    var result = await createGoalMutation(selectedGoalType, name, description);
    return result;
  }

  Future<bool> createGoalMutation(
      String status, String goalName, String goalDescription) async {
    print("Mutation is Initiated");

    String currentDate = DateTime.now().toIso8601String();

    //May be UserIP has been changed to GoalMemberIP
    //May be ActivityIP has been changed to String
    String mutation = """
mutation MyMutation(\$activities: [String] = [], \$members: [GoalMemberIP] = []) {
  postGoal(goal: {activities: \$activities, backup: "", collabType: "", createdBy: "$userId", createdDt: "${currentDate}", desc: "${goalDescription.trim()}", endDate: "", members: \$members, mentor: "", modifiedBy: "$userId", modifiedDt: "${currentDate}", name: "${goalName.trim()}", status: "ACTIVE", type: "$status"}) {
    id
    activities
    backup
    collabType
    createdBy
    createdDt
    desc
    endDate
    members {
      mentorId
    }
    mentor
    modifiedBy
    modifiedDt
    name
    status
    type
  }
}

""";

    showLoader();
    var result = await GraphQLService.tempClient
        .mutate(MutationOptions(document: gql(mutation)));
    //var result = await graphqlClient.query(QueryOptions(document: gql(mutation)));
    //It can have exception or data
    log(result.data.toString());
    //json.encode(result.data);
    hidePLoader();
    if (result.data == null && result.exception != null) {
      //No Data Received from Server;
      GraphQLService.parseError(result.exception, "CreateGoalMutation");
      return false;
    }
    var localGoalId = result.data?["postGoal"]["id"];
    if(localGoalId == null){
      print("There is Error in parsing Goal ID");
      return false;
    }
    tempGoalId = localGoalId ?? "";
    reloadGoalHomeList();
    return true;
  }

  void reloadGoalHomeList() {
    try {
      VEGoalController tempController = Get.find();
      GraphQLService.tempClient.resetStore(refetchQueries: false);
      tempController.getAEGoal();
    } catch (onError) {
      print("Failed to reload Goal List $onError");
    }
  }

  ///Describe Activity
  var goalActivityList = <IndividualGoalActivityModel>[];
  var initialActivityModel = IndividualGoalActivityModel();

  //Activity Controller
  TextEditingController activityNameController =
      TextEditingController(text: "");
  List<IndividualGoalActivityModel> successfullyCreatedActivityList = [];

  void updateActivityName(String activityName) {
    initialActivityModel.name = activityName;
  }

  @override
  void onInit() {
    super.onInit();
    initializeActivityModel();
  }

  void resetData() {
    isReminderToggleOn = false;
    updateDailyFrequencyDuration(2);
    updateFrequencySelection(0);
    //Update When Part of Code
    updateRadioGroupValue(0);
    //updateMonthDropDown("January");
    selectedWeeklyListIndex.clear();
    selectedMonthlyListIndex.clear();
    selectedDays.clear();
    activityNameController.clear();
    _selectedDate = "";
    selectedDaysText = "";
    for (var item in selectWeeklyDays){
      item["isSelected"] = false;
    }
  }

  final List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  String selectedMonth = "January";

  void updateMonthDropDown(String month) {
    selectedMonth = month;
    update();
  }

  final List<String> years = [
    "2021",
    "2022",
    "2023",
    "2024",
    "2025",
    "2026",
    "2027",
    "2028",
    "2029",
    "2031",
    "2032",
    "2033",
    "2034",
    "2035",
    "2036",
    "2037",
    "2038",
    "2039",
    "2040",
    "2041",
    "2042",
  ];
  String selectedYears = "2021";

  String selectedDaysText = "";

  void updateYearDropDown(String month) {
    selectedYears = month;
    update();
  }

  List<String> get getTimeList => activityTimeList;

  String _selectedDate = "";
  DateTime? selectedCalendarDay = DateTime.now();
  DateTime selectedCalendarFocusedDay = DateTime.now();

  //Multiple Days Selected
  // Using a `LinkedHashSet` is recommended due to equality comparison override
  final Set<DateTime> selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    selectedCalendarFocusedDay = focusedDay;
    // Update values in a Set
    if (selectedDays.contains(selectedDay)) {
      selectedDays.remove(selectedDay);
    } else {
      selectedDays.add(selectedDay);
    }
    updateTextStrings();
    update();
  }

  void updateTextStrings() {
    if (selectedDays.isNotEmpty) {
      if (selectedFrequencyIndex == 2) {
        selectedDaysText =
            "Selected dates: ${formatMonthToString()} of every month";
      } else if (selectedFrequencyIndex == 3) {
        selectedDaysText = "Selected dates: ${formatCustomDatesToString()}";
      }
    } else {
      selectedDaysText = "";
    }
  }

  Set<int> selectedMonthlyListIndex = {};

  String formatMonthToString() {
    Set<String> days = {};

    selectedMonthlyListIndex.clear();
    for (DateTime date in selectedDays) {
      String day = date.day.toString();
      selectedMonthlyListIndex.add(date.day);
      days.add("$day");
    }

    return days.join(",");
  }

  String formatCustomDatesToString() {
    List<String> formattedDates = [];

    for (DateTime date in selectedDays) {
      String month = getMonthAbbreviation(date.month);
      String day = date.day.toString();

      formattedDates.add("$month $day");
    }

    return formattedDates.join(', ');
  }

  String getMonthAbbreviation(int month) {
    switch (month) {
      case 1:
        return "Jan";
      case 2:
        return "Feb";
      case 3:
        return "Mar";
      case 4:
        return "Apr";
      case 5:
        return "May";
      case 6:
        return "Jun";
      case 7:
        return "Jul";
      case 8:
        return "Aug";
      case 9:
        return "Sep";
      case 10:
        return "Oct";
      case 11:
        return "Nov";
      case 12:
        return "Dec";
      default:
        return "";
    }
  }

  void updateCalendarDays(DateTime current, DateTime focused) {
    print("Calendar Date is Updated");
    selectedCalendarDay = current;
    selectedCalendarFocusedDay = focused;
    update();
  }

  void updateSelectedEndDate(String date) {
    _selectedDate = date;
    initialActivityModel.endDt = DateTime.parse(date).toIso8601String();
    update();
  }

  String get getSelectedDate => _selectedDate;

  bool isReminderToggleOn = false;

  void changeToggleState() {
    if (isReminderToggleOn) {
      isReminderToggleOn = false;
      initialActivityModel.reminder = "";
    } else {
      isReminderToggleOn = true;
    }
    update();
  }

  /*
  * 0 - Daily
  * 1 - Weekly
  * 2 - Monthly
  * 3 - CustomDays
  * */
  var selectedFrequencyIndex = 0.obs;

  /*
  0 - AnyTime of Day - ""
  1 - When - ISO String
   */
  RxInt radioGroupValue = 0.obs;

  void updateRadioGroupValue(int val) {
    radioGroupValue.value = val;
    if (val == 0) {
      initialActivityModel.time = "";
    }
    update();
  }

  String selectedDropDownTime = "3:00";

  void updateDropDownTime(String time) {
    selectedDropDownTime = time;
    update();
  }

  String reminderTime = "";

  void updateReminderTime(String selectedTime) {
    List<String> timeParts = selectedTime.split(':');
    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);
    int seconds = int.parse(timeParts[2].split('.')[0]);

    // Create a DateTime object with the custom time
    DateTime dateTime = DateTime(0, 1, 1, hours, minutes, seconds);
    initialActivityModel.reminder = dateTime.toIso8601String();
    reminderTime = DateFormat("hh: mm a").format(dateTime);
    isReminderToggleOn = true;
    update();
  }

  bool isPmSelected = true;

  void updateAmPM(bool val) {
    isPmSelected = val;
    update();
  }

  List<Map<String, dynamic>> frequencies = [
    {"name": "Daily", "isSelected": true, "index": 0},
    {"name": "Weekly", "isSelected": false, "index": 1},
    {"name": "Monthly", "isSelected": false, "index": 2},
    {"name": "Custom Days", "isSelected": false, "index": 3}
  ];

  List<Map<String, dynamic>> dailyFrequencyDuration = [
    {"name": "5 min", "isSelected": false, "index": 0},
    {"name": "15 min", "isSelected": false, "index": 1},
    {"name": "30 min", "isSelected": true, "index": 2},
    {"name": "45 min", "isSelected": false, "index": 3},
    {"name": "1 hr", "isSelected": false, "index": 4}
  ];

  List<Map<String, dynamic>> selectWeeklyDays = [
    {"name": "S", "isSelected": false, "index": 0},
    {"name": "M", "isSelected": false, "index": 1},
    {"name": "T", "isSelected": false, "index": 2},
    {"name": "W", "isSelected": false, "index": 3},
    {"name": "T", "isSelected": false, "index": 4},
    {"name": "F", "isSelected": false, "index": 5},
    {"name": "S", "isSelected": false, "index": 6}
  ];

  var selectedWeeklyListIndex = <int>[];

  void updateDailyFrequencyDuration(int selectedIndex) {
    for (int i = 0; i < dailyFrequencyDuration.length; i++) {
      if (dailyFrequencyDuration.elementAt(i)["index"] == selectedIndex) {
        dailyFrequencyDuration.elementAt(i)["isSelected"] = true;
      } else {
        dailyFrequencyDuration.elementAt(i)["isSelected"] = false;
      }
      switch (selectedIndex) {
        case 0:
          initialActivityModel.duration = "5";
          break;
        case 1:
          initialActivityModel.duration = "15";
          break;
        case 2:
          initialActivityModel.duration = "30";
          break;
        case 3:
          initialActivityModel.duration = "45";
          break;
        case 4:
          initialActivityModel.duration = "60";
          break;
        default:
          initialActivityModel.duration = "30";
          break;
      }
      update();
    }
  }

  void updateWeeklyDays(int selectedIndex) {
    for (int i = 0; i < selectWeeklyDays.length; i++) {
      if (selectWeeklyDays.elementAt(i)["index"] == selectedIndex) {
        selectWeeklyDays.elementAt(i)["isSelected"] =
            !selectWeeklyDays.elementAt(i)["isSelected"];
      }
      /* else {
        selectWeeklyDays.elementAt(i)["isSelected"] = false;
      }*/
      update();
    }

    if (selectedWeeklyListIndex.contains(selectedIndex)) {
      selectedWeeklyListIndex.remove(selectedIndex);
    } else {
      selectedWeeklyListIndex.add(selectedIndex);
    }

    print("Weekly Index is $selectedWeeklyListIndex");
  }

  void updateFrequencySelection(int selectedIndex) {
    for (int i = 0; i < frequencies.length; i++) {
      if (frequencies.elementAt(i)["index"] == selectedIndex) {
        frequencies.elementAt(i)["isSelected"] = true;
        selectedFrequencyIndex.value = i;
        if (kDebugMode) {
          print(selectedFrequencyIndex);
        }
      } else {
        frequencies.elementAt(i)["isSelected"] = false;
      }

      switch (selectedIndex) {
        case 0:
          initialActivityModel.freq = "Daily";
          break;
        case 1:
          initialActivityModel.freq = "Weekly";
          break;
        case 2:
          initialActivityModel.freq = "Monthly";
          break;
        case 3:
          initialActivityModel.freq = "Custom";
          break;
        default:
          initialActivityModel.freq = "Daily";
          break;
      }
      updateTextStrings();

      update();
    }
  }

  String errorText = "Please try again!";

  Future<bool> validationOfAddActivity() async {
    bool shouldContinue = true;
    if (isReminderToggleOn &&
        (initialActivityModel.reminder == null ||
            initialActivityModel.reminder.toString().isEmpty)) {
      print("Error Reminder value is not there");
      errorText = "Please select reminder time";
      shouldContinue = false;
    }
    if (!isReminderToggleOn) {
      initialActivityModel.reminder = "";
    }

    if (initialActivityModel.name == null ||
        initialActivityModel.name.toString().trim().isEmpty) {
      errorText = "Please enter name";
      shouldContinue = false;
    }

    switch (initialActivityModel.freq.toString().toLowerCase()) {
      case "custom":
        if (selectedDays.isEmpty) {
          print("Error Custom List Empty");
          errorText = "Please select days";
          shouldContinue = false;
        }
        initialActivityModel.customDay = selectedDays
            .map((DateTime number) => number.toIso8601String())
            .toList();
        initialActivityModel.monthDay = [];
        initialActivityModel.weekDay = [];
        break;
      case "monthly":
        if (selectedMonthlyListIndex.isEmpty) {
          print("Error Montly List Empty");
          errorText = "Please select days of month";
          shouldContinue = false;
        }
        initialActivityModel.customDay = [];
        initialActivityModel.monthDay =
            selectedMonthlyListIndex.map((int number) => "$number").toList();
        initialActivityModel.weekDay = [];
        break;
      case "weekly":
        if (selectedWeeklyListIndex.isEmpty) {
          print("Error Weekly List Empty ${selectedWeeklyListIndex}");
          errorText = "Please select week";
          shouldContinue = false;
        }
        initialActivityModel.customDay = [];
        initialActivityModel.monthDay = [];
        initialActivityModel.weekDay =
            selectedWeeklyListIndex.map((int number) => "$number").toList();
        break;
      case "daily":
      default:
        initialActivityModel.customDay = [];
        initialActivityModel.monthDay = [];
        initialActivityModel.weekDay = [];
        break;
    }

    if (radioGroupValue.value == 1) {
      //Convert Value into time and Add into time parameter
      print("DropTime is ${selectedDropDownTime}");
      List<String> timeParts = selectedDropDownTime.split(':');
      int hours =
          isPmSelected ? int.parse(timeParts[0]) + 12 : int.parse(timeParts[0]);
      int minutes = int.parse(timeParts[1]);
      if (hours == 24) {
        hours = 0;
      }
      // Create a DateTime object with the custom time
      DateTime dateTime = DateTime(0, 1, 1, hours, minutes);
      initialActivityModel.time = dateTime.toIso8601String();
    }

    print("Initial Activity Generated is ${initialActivityModel.toString()}");

    if (!shouldContinue) {
      return false;
    } else {
      errorText = "";
    }

    return await initiateCreateActivityMutation();
  }

  Future<bool> initiateCreateActivityMutation() async {
    String mutation =
        '''mutation MyMutation( \$customDay: [String] = ${json.encode(initialActivityModel.customDay)}, \$monthDay: [String] = ${json.encode(initialActivityModel.monthDay)}, \$weekDay: [String] = ${json.encode(initialActivityModel.weekDay)}) {
  addGoalActivity(activity: {customDay: \$customDay, desc: "${initialActivityModel.desc}", 
  duration: "${initialActivityModel.duration.toString()}", endDt: "${initialActivityModel.endDt}", 
  freq: "${initialActivityModel.freq}", monthDay: \$monthDay, 
  name: "${initialActivityModel.name}", reminder: "${initialActivityModel.reminder}", 
  time: "${initialActivityModel.time}", weekDay: \$weekDay}, goalId: "$tempGoalId") {
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
  postNotification(notice: {frm: "1", to: "1", msg: "A new activity ${initialActivityModel.name} has been assigned to your goal $newGoalName", status: "NEW", type: "New activity added"}) {
    createdDt
    id
    msg
    status
    type
  }

}
''';

    print("Mutation called is $mutation");

    showLoader();
    var result = await GraphQLService.tempClient
        .mutate(MutationOptions(document: gql(mutation)));
    //var result = await graphqlClient.query(QueryOptions(document: gql(mutation)));
    //It can have exception or data
    log(result.data.toString());
    //json.encode(result.data);
    hidePLoader();
    if (result.data == null && result.exception != null) {
      //No Data Received from Server;
      GraphQLService.parseError(result.exception, "CreateGoalActivityMutation");
      return false;
    }
    showSuccess("Activity created Successfully");
    IndividualGoalActivityModel tempNewModel = IndividualGoalActivityModel();
    tempNewModel.id = result.data?["addGoalActivity"]["id"];
    tempNewModel.name = result.data?["addGoalActivity"]["name"];
    tempNewModel.duration = result.data?["addGoalActivity"]["duration"];
    tempNewModel.reminder = result.data?["addGoalActivity"]["reminder"];
    tempNewModel.monthDay = result.data?["addGoalActivity"]["monthDay"];
    tempNewModel.weekDay = result.data?["addGoalActivity"]["weekDay"];
    tempNewModel.customDay = result.data?["addGoalActivity"]["customDay"];
    tempNewModel.time = result.data?["addGoalActivity"]["time"];
    tempNewModel.desc = result.data?["addGoalActivity"]["desc"];
    tempNewModel.endDt = result.data?["addGoalActivity"]["endDt"];
    tempNewModel.freq = result.data?["addGoalActivity"]["freq"];
    print("Activity ID is ${tempNewModel.toString()}");
    successfullyCreatedActivityList.add(tempNewModel);
    resetData();
    initializeActivityModel();
    update();
    return true;
  }

  void editGoalActivitySheet(IndividualGoalActivityModel activityModel, int selectedIndex) async {
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
              ));
        });

    print("Initiated Edited Activity is ${result.toString()}");
    if(result == null){
      return;
    }
    try{
      var errorResponse = await mutateActivityCreated(result as IndividualGoalActivityModel);
      if(errorResponse != null){
        showErrorWOTitle(errorResponse);
        return;
      }
      successfullyCreatedActivityList[selectedIndex] = result;
      update();
      showSuccess("Activity Edited Successfully");
    }catch(onError, Stacktrace){
      print("Failed to Edit Activity this is response $onError Error Stack Trace $Stacktrace");
    }
  }

  Future<String?> mutateActivityCreated(IndividualGoalActivityModel tempModel) async{
    String mutation = '''mutation MyMutation( \$customDay: [String] = ${json.encode(tempModel.customDay)}, \$monthDay: [String] = ${json.encode(tempModel.monthDay)}, \$weekDay: [String] = ${json.encode(tempModel.weekDay)}) {
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
}''';

    showLoader();
    var result = await GraphQLService.tempClient
        .mutate(MutationOptions(document: gql(mutation)));
    //var result = await graphqlClient.query(QueryOptions(document: gql(mutation)));
    //It can have exception or data
    log(result.data.toString());
    //json.encode(result.data);
    //Hide Progress Bar
    hidePLoader();
    if (!GraphQLService.shouldContinueFurther("EditGoalActivityData", result)) {
      return "Failed to Edit Goal Activity";
    }
    return null;
  }


  void initializeActivityModel() {
    initialActivityModel.customDay = [];
    initialActivityModel.desc = "";
    initialActivityModel.endDt = "";
    initialActivityModel.freq = "Daily";
    initialActivityModel.duration = "30";
    initialActivityModel.monthDay = [];
    initialActivityModel.weekDay = [];
    initialActivityModel.reminder = "";
    initialActivityModel.time = "";
    initialActivityModel.id = null;
  }

  void closeGoalActivity() {
    resetCreateGoalAndActivity(
        GoalCreatedSuccessPageEnum.GoalCreateActivityPage);
  }

  ///Member Mutation
  //Member Mutation
  Future<bool> createIndividualMemberMutation(Contact contact) async {
    String mutation = '''mutation MyMutation {
  udpateCollabType(goalId: "$tempGoalId", type: "INDIVIDUAL") {
    id
    collabType
    desc
    name
  }
  addGoalMentor(goalId: "$tempGoalId", user: {createdBy: "$userId", createdDt: "${currentTime.toIso8601String()}", fullname: "${contact.displayName}", modifiedBy: "$userId", modifiedDt: "${currentTime.toIso8601String()}", ph: "${contact.phones?[0].value ?? ""}", deviceId: ""}) {
    deviceId
    fullname
    createdBy
    createdDt
    id
    modifiedBy
    modifiedDt
    ph
  }
}
''';

    print("Individual Mutation is $mutation");

    showLoader();
    var result = await GraphQLService.tempClient
        .mutate(MutationOptions(document: gql(mutation)));
    //var result = await graphqlClient.query(QueryOptions(document: gql(mutation)));
    //It can have exception or data
    log(result.data.toString());
    //json.encode(result.data);
    hidePLoader();
    if (result.data == null && result.exception != null) {
      //No Data Received from Server;
      GraphQLService.parseError(result.exception, "Create Individual Mutation");
      return false;
    }

    return true;
  }

  Future<List<IndividualGoalMemberModel>?> createGroupGoalMemberMutation(List<Contact?> contact) async {
    /*List groupList = contact.map((e) => jsonEncode('''{createdBy: $userId, createdDt: ${currentTime.toIso8601String()}, deviceId: "", fullname: ${e?.displayName ?? ""}, modifiedBy: $userId, modifiedDt: ${currentTime.toIso8601String()}, ph: ${e?.phones?[0].value ?? ""}''')).toList();
    String mutation = '''mutation MyMutation {addGoalMembers(goalId: "$tempGoalId", goalMembers: $groupList) {
    createdBy
    fullname
    deviceId
    id
    modifiedBy
    modifiedDt
    ph
  }

 udpateCollabType(goalId: "1", type: "GROUP") {
    id
    collabType
    desc
    name
  }

}
''';*/

    List<IndividualGoalMemberModel> groupMembers = contact
        .map((e) => IndividualGoalMemberModel(
              createdBy: userId,
              createdDt: currentTime.toIso8601String(),
              deviceId: "",
              fullname: e?.displayName ?? "",
              modifiedBy: userId,
              modifiedDt: currentTime.toIso8601String(),
              ph: e?.phones?[0].value ?? "",
            ))
        .toList();
    String mutation =
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
''';

    /*String mutation = '''mutation MyMutation {addGoalMembers(goalId: "73403221-09b6-400e-b214-8f4beb09b2b9", goalMembers: [{createdBy:"1",createdDt:"2023-09-06T16:51:33.887491",deviceId:"",fullname:"David Taylor",modifiedBy:"1",modifiedDt:"2023-09-06T16:51:33.887491",ph:"555-610-6679"},
    {createdBy:"1",createdDt:"2023-09-06T16:51:33.887491",deviceId:"",fullname:"Hank M. Zakroff",modifiedBy:"1",modifiedDt:"2023-09-06T16:51:33.887491",ph:"(555) 766-4823"},
    {createdBy:"1",createdDt:"2023-09-06T16:51:33.887491",deviceId:"",fullname:"Daniel Higgins Jr.",modifiedBy:"1",modifiedDt:"2023-09-06T16:51:33.887491",ph:"555-478-7672"}]) {
    createdBy
    fullname
    deviceId
    id
    modifiedBy
    modifiedDt
    ph
  }

 udpateCollabType(goalId: "1", type: "GROUP") {
    id
    collabType
    desc
    name
  }

}''';*/

    print("Group Mutation is $mutation");
    showLoader();
    try {
      var result = await GraphQLService.tempClient
          .mutate(MutationOptions(document: gql(mutation),variables: {
        'goalId': tempGoalId, // Set the value for \$goalId
        'goalMembers': groupMembers.map((member) => member.toJson()).toList(), // Set the value for \$goalMembers
      }));
      //var result = await graphqlClient.query(QueryOptions(document: gql(mutation)));
      //It can have exception or data
      log(result.data.toString());
      //json.encode(result.data);
      hidePLoader();
      if (result.data == null && result.exception != null) {
        //No Data Received from Server;
        GraphQLService.parseError(result.exception, "Create Group Mutation");
        return null;
      }
      SuccessGoalMemberModel successGoalMemberModel = SuccessGoalMemberModel.fromJson(result.data!);
      return successGoalMemberModel.goalMemberList;
    } catch (onError, stacktrace) {
      print("Group Mutation Error is $onError");
      print("Failed at $stacktrace");
      hidePLoader();
      return null;
    }
  }

  void resetCreateGoalAndActivity(GoalCreatedSuccessPageEnum tempEnum) {
    resetData();
    tempGoalId = "";
    successfullyCreatedActivityList = [];

    switch (tempEnum) {
      case GoalCreatedSuccessPageEnum.GoalSuccessPage:
        Get.close(5);
        break;
      case GoalCreatedSuccessPageEnum.GoalCreateActivityPage:
        Get.close(3);
        break;
    }
  }

  Future<bool> mutationGoalMemberRemove(String memberID) async{
    print("Member Remove Mutation is $memberID");

    String mutation =
    '''mutation MyMutation {
  removeGoalMember(goalId: "$tempGoalId", userId: "$memberID") {
    activities
    id
  }
}
''';
    showLoader();
    try {
      var result = await GraphQLService.tempClient
          .mutate(MutationOptions(document: gql(mutation)));
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
    } catch (onError, stacktrace) {
      print("Remove Group Member Mutation is $onError");
      print("Failed at $stacktrace");
      hidePLoader();
      return false;
    }
    return true;
  }

  Future<bool> mutationGoalMemberBackup(String tempId) async{
    print("Member Remove Mutation is $tempId");

    String mutation =
    '''mutation MyMutation {
  setBackup(goalId: "$tempGoalId", userId: "$tempId") {
    id
    mentor
    backup
  }
}
''';
    showLoader();
    try {
      var result = await GraphQLService.tempClient
          .mutate(MutationOptions(document: gql(mutation)));
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

  void mutationNotificationServer(String? value) async{
    print("Member FCM Update is $value");

    String mutation =
    '''mutation MyMutation {
  putUser(id: "1", deviceId: "$value", fullname: "nefn1", ph: "newph") {
    deviceId
    fullname
    id
    ph
  }
}

''';
    try {
      var result = await GraphQLService.tempClient
          .mutate(MutationOptions(document: gql(mutation)));
      //var result = await graphqlClient.query(QueryOptions(document: gql(mutation)));
      //It can have exception or data
      log(result.data.toString());
      //json.encode(result.data);
      if (result.data == null && result.exception != null) {
        //No Data Received from Server;
        GraphQLService.parseError(result.exception, "Notification FCM Update Mutation");
      }
    } catch (onError, stacktrace) {
      print("Notification FCM Update is $onError");
      print("Failed at $stacktrace");
    }
  }
}
