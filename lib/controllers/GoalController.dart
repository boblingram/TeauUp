import 'dart:collection';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:teamup/models/IndividualNotificationModel.dart';
import 'package:teamup/utils/Enums.dart';
import 'package:teamup/utils/GraphQLService.dart';

import '../utils/Constants.dart';

class GoalController extends GetxController {

  var userId = "1";
  ///Notification Controller
  var notificationList = <IndividualNotificationModel>[].obs;

  var currentTime = DateTime.now();

  void fetchNotificationData()async{
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

    var result = await GraphQLService.tempClient.query(QueryOptions(document: gql(query)));
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
      print("Length of List is ${notificationDataModel.notificationDataList.length}");
      notificationList.clear();
      notificationList.value = notificationDataModel.notificationDataList;
      notificationList.sort((a, b) => a.createdDt.compareTo(b.createdDt));
    } catch (onError, stackTrace) {
      print("Error while parsing Notification Data Model $onError");
    }
  }

  void notificationMutationQuery(NotificationMutationEnum tempEnum, String notificationId) async{
    print("Notification Mutation is ${tempEnum}");
    String mutation = '';
    if(tempEnum == NotificationMutationEnum.MarkasRead){
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
    }else if(tempEnum == NotificationMutationEnum.Delete){
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
    var result = await GraphQLService.tempClient.mutate(MutationOptions(document: gql(mutation)));
    log(result.toString());
    hidePLoader();
    if (!GraphQLService.shouldContinueFurther("Mutate Notification ${tempEnum}", result)) {
      showError("Failed to update notification status");
      return;
    }
    //TODO Update UI
  }


  ///Describe Goal
  var newGoalName = "";
  var newGoalDescription = "";
  var newSelectedGoalType = "";

  void updateNameAndDescription(String name, String description, String selectedGoalType) {
    newGoalName = name;
    newGoalDescription = description;
    newSelectedGoalType = selectedGoalType;
  }


  ///Describe Activity
  //Activity Controller
  TextEditingController activityNameController = TextEditingController(text: "");
  List<String> _activityName = [];

  void addActivityName(String activityName){
    _activityName.add(activityName);
  }

  List<String> get getActivityNames => _activityName;

  @override
  void onInit() {
    super.onInit();
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

  final List<String> _timeList = [
    "1:00",
    "1:30",
    "2:00",
    "2:30",
    "3:00",
    "3:30",
    "4:00",
    "4:30",
    "5:00",
    "5:30",
    "6:00",
    "6:30",
    "7:00",
    "7:30",
    "8:00",
    "8:30",
    "9:00",
    "9:30",
    "10:00",
    "10:30",
    "11:00",
    "11:30",
    "12:00",
    "12:30",
  ];

  List<String> get getTimeList => _timeList;

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

  void updateTextStrings(){
    if(selectedDays.isNotEmpty){
      if(selectedFrequencyIndex == 2){
        selectedDaysText = "Selected dates: ${formatMonthToString()} of every month";
      }else if(selectedFrequencyIndex == 3){
        selectedDaysText = "Selected dates: ${formatCustomDatesToString()}";
      }
    }else{
      selectedDaysText = "";
    }
  }

  String formatMonthToString(){
    Set<String> days = {};

    for (DateTime date in selectedDays) {
      String day = date.day.toString();
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
      case 1: return "Jan";
      case 2: return "Feb";
      case 3: return "Mar";
      case 4: return "Apr";
      case 5: return "May";
      case 6: return "Jun";
      case 7: return "Jul";
      case 8: return "Aug";
      case 9: return "Sep";
      case 10: return "Oct";
      case 11: return "Nov";
      case 12: return "Dec";
      default: return "";
    }
  }

  void updateCalendarDays(DateTime current, DateTime focused) {
    print("Calendar Date is Updated");
    selectedCalendarDay = current;
    selectedCalendarFocusedDay = focused;
    update();
  }

  void updateSelectedDate(String date) {
    _selectedDate = date;
    update();
  }

  String get getSelectedDate => _selectedDate;

  void resetData() {
    isReminderToggleOn = false;
    updateDailyFrequencyDuration(2);
    selectedFrequencyIndex.value = 0;
    updateSelection(0);
    updateWeeklyDays(0);
    updateMonthDropDown("January");
  }

  bool isReminderToggleOn = false;

  void changeToggleState() {
    if (isReminderToggleOn) {
      isReminderToggleOn = false;
    } else {
      isReminderToggleOn = true;
    }
    update();
  }

  var selectedFrequencyIndex = 0.obs;

  RxInt radioGroupValue = 10.obs;

  void updateRadioGroupValue(int val) {
    radioGroupValue.value = val;
    update();
  }

  String selectedDropDownTime = "3:00";

  void updateDropDownTime(String time) {
    selectedDropDownTime = time;
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
    {"name": "S", "isSelected": true, "index": 0},
    {"name": "M", "isSelected": false, "index": 1},
    {"name": "T", "isSelected": false, "index": 2},
    {"name": "W", "isSelected": false, "index": 3},
    {"name": "T", "isSelected": false, "index": 4},
    {"name": "F", "isSelected": false, "index": 5},
    {"name": "S", "isSelected": false, "index": 6}
  ];

  void updateDailyFrequencyDuration(int selectedIndex) {
    for (int i = 0; i < dailyFrequencyDuration.length; i++) {
      if (dailyFrequencyDuration.elementAt(i)["index"] == selectedIndex) {
        dailyFrequencyDuration.elementAt(i)["isSelected"] = true;
      } else {
        dailyFrequencyDuration.elementAt(i)["isSelected"] = false;
      }
      update();
    }
  }

  void updateWeeklyDays(int selectedIndex) {
    for (int i = 0; i < selectWeeklyDays.length; i++) {
      if (selectWeeklyDays.elementAt(i)["index"] == selectedIndex) {
        selectWeeklyDays.elementAt(i)["isSelected"] = true;
      } else {
        selectWeeklyDays.elementAt(i)["isSelected"] = false;
      }
      update();
    }
  }

  void updateSelection(int selectedIndex) {
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

      updateTextStrings();

      update();
    }
  }
}
