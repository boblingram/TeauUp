import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/IndividualGoalActivityModel.dart';
import '../utils/APIService.dart';
import '../utils/Constants.dart';
import '../utils/app_strings.dart';

class GoalActivityController extends GetxController {
  var initialActivityModel = IndividualGoalActivityModel();

  TextEditingController activityNameTEC = TextEditingController();

  List<Map<String, dynamic>> frequencies = [
    {"name": "Daily", "isSelected": false, "index": 0},
    {"name": "Weekly", "isSelected": false, "index": 1},
    {"name": "Monthly", "isSelected": false, "index": 2},
    {"name": "Custom Days", "isSelected": false, "index": 3}
  ];

  List<Map<String, dynamic>> dailyFrequencyDuration = [
    {"name": "5 min", "isSelected": false, "index": 0},
    {"name": "15 min", "isSelected": false, "index": 1},
    {"name": "30 min", "isSelected": false, "index": 2},
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


  var selectedFrequencyIndex = 0.obs;

  //Calendar Days Selection
  Set<DateTime> selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  String _selectedEndDate = "";
  DateTime? selectedCalendarDay = DateTime.now();
  DateTime selectedCalendarFocusedDay = DateTime.now();

  String selectedDaysText = "";


  //Weekly Selection
  var selectedWeeklyListIndex = <int>[];

  //Radio Group Value
  /*
  0 - AnyTime of Day - ""
  1 - When - ISO String
   */
  RxInt radioGroupValue = 0.obs;


  @override
  void onInit() {
    print("Goal Activity Controller Created");
    //Initialize on basis of variables received till now.
    super.onInit();
  }

  @override
  void dispose() {
    activityNameTEC.dispose();
    super.dispose();
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

  ///Radio Group
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

  void updateReminderTime(String selectedTime, {bool isEReminderTime = false}) {
    DateTime dateTime = DateTime.now();
    if (isEReminderTime) {
      dateTime = DateTime.tryParse(selectedTime) ?? dateTime;
    } else {
      List<String> timeParts = selectedTime.split(':');
      int hours = int.parse(timeParts[0]);
      int minutes = int.parse(timeParts[1]);
      int seconds = int.parse(timeParts[2].split('.')[0]);

      // Create a DateTime object with the custom time
      dateTime = DateTime(0, 1, 1, hours, minutes, seconds);
      initialActivityModel.reminder = dateTime.toIso8601String();
    }
    reminderTime = DateFormat("hh: mm a").format(dateTime);
    isReminderToggleOn = true;
    update();
  }

  bool isPmSelected = true;

  void updateAmPM(bool val) {
    isPmSelected = val;
    update();
  }

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

  List<String> get getTimeList => activityTimeList;

  String get getSelectedEndDate => _selectedEndDate;

  void updateSelectedEndDate(String date, {bool isEEndDate = false}) {
    if (isEEndDate) {
      DateTime tempDate = DateTime.tryParse(date) ?? DateTime.now();
      _selectedEndDate = DateFormat('yyyy-MM-dd').format(tempDate);
    } else {
      _selectedEndDate = date;
      initialActivityModel.endDt = DateTime.parse(date).toIso8601String();
    }

    update();
  }

  void updateModelFromReceived(IndividualGoalActivityModel activityModel) {
    initialActivityModel.id = activityModel.id;
    initialActivityModel.name = activityModel.name;
    initialActivityModel.weekDay = activityModel.weekDay;
    initialActivityModel.monthDay = activityModel.monthDay;
    initialActivityModel.customDay = activityModel.customDay;
    initialActivityModel.reminder = activityModel.reminder;
    initialActivityModel.duration = activityModel.duration;
    initialActivityModel.time = activityModel.time;
    initialActivityModel.freq = activityModel.freq;
    initialActivityModel.endDt = activityModel.endDt;
    initialActivityModel.instrFile = activityModel.instrFile;

    //Name
    activityNameTEC.text = initialActivityModel.name;

    if (initialActivityModel.freq == null || initialActivityModel.freq
        .toString()
        .isEmpty) {
      //Mark as Daily with duration 30;
      updateFrequencySelection(0);
      updateDailyFrequencyDuration(2);
    } else {
      switch (initialActivityModel.freq.toString().toLowerCase()) {
        case "daily":
          updateFrequencySelection(0);
          break;
        case "monthly":
          updateFrequencySelection(2);
          print("Edit Activity is ${initialActivityModel.monthDay}");
          DateTime tempInstance = DateTime.now();
          try {
            selectedDays = (initialActivityModel.monthDay as List).map((e) {
              int day = int.tryParse(e) ?? 1;
              return DateTime.utc(tempInstance.year,tempInstance.month,day);
            }).toSet();
            print("Edit Activity is Months are  ${selectedDays}");
          } catch (OnError, stacktrace) {
            print(
                "Failed Converting to Selected Months $OnError, stackTrace is $stacktrace");
          }
          break;
        case "weekly":
          updateFrequencySelection(1);
          try {
            for (var item in initialActivityModel.weekDay) {
              var convertedToInt = int.tryParse(item) ?? 0;
              updateWeeklyDays(convertedToInt);
            }
          } catch (onError, Stacktrace) {
            print(
                "Failed Updating Weekly Index $onError, StackTrace is $Stacktrace");
          }
          break;
        case "custom":
          updateFrequencySelection(3);
          print("Custom Activity is ${initialActivityModel.customDay}");
          try {
            selectedDays =
                (initialActivityModel.customDay as List).map((e) => DateTime
                    .tryParse(e) ?? DateTime.now()).toSet();
            print("Edit Activity is Custom are  ${selectedDays}");
          } catch (OnError, stacktrace) {
            print(
                "Failed Converting to Selected Days $OnError, stackTrace is $stacktrace");
          }

          break;
        default:
        //Mark as Daily with duration 30;
          updateFrequencySelection(0);
          updateDailyFrequencyDuration(2);
      }
    }

    //Duration
    if (initialActivityModel.duration == null || initialActivityModel.duration
        .toString()
        .isEmpty) {
      updateDailyFrequencyDuration(2);
    } else {
      switch (initialActivityModel.duration) {
        case "5":
          updateDailyFrequencyDuration(0);
          break;
        case "15":
          updateDailyFrequencyDuration(1);
          break;
        case "45":
          updateDailyFrequencyDuration(3);
          break;
        case "60":
          updateDailyFrequencyDuration(4);
          break;
        case "30":
        default:
          updateDailyFrequencyDuration(2);
      }
    }

    //End Date
    if (initialActivityModel.endDt == null || initialActivityModel.endDt
        .toString()
        .isEmpty) {
      _selectedEndDate = "";
    } else {
      updateSelectedEndDate(
          initialActivityModel.endDt.toString(), isEEndDate: true);
    }

    //Time
    if (initialActivityModel.time == null || initialActivityModel.time
        .toString()
        .isEmpty) {
      updateRadioGroupValue(0);
    } else {
      updateRadioGroupValue(1);
      DateTime time = DateTime.tryParse(initialActivityModel.time.toString()) ??
          DateTime.now();
      //True - > PM & false -> Am
      print("Minute is ${time.minute == 0 ? "00" : time.minute}");
      if (time.hour < 12) {
        updateAmPM(false);
        updateDropDownTime(
            "${time.hour}:${time.minute == 0 ? "00" : time.minute}");
      } else {
        updateAmPM(true);

        var updatedTime = time.hour - 12;
        updateDropDownTime(
            "$updatedTime:${time.minute == 0 ? "00" : time.minute}");
      }
    }

    //Reminder
    if (initialActivityModel.reminder == null || initialActivityModel.reminder
        .toString()
        .isEmpty) {
      reminderTime = "";
      isReminderToggleOn = false;
    } else {
      updateReminderTime(initialActivityModel.reminder, isEReminderTime: true);
    }

    //instructions
    //THis is a comma Separated String
    print("Instructions received are ${initialActivityModel.instrFile.toString().isEmpty}");
    if(initialActivityModel.instrFile.toString().isNotEmpty){
      try{
        selectedFileList = initialActivityModel.instrFile.split(',').map((item) => item.trim()).toList();
      }catch(onError, stacktrace){
        print("Failed to split the file into , separated $onError, Stacktrace is $stacktrace");
        selectedFileList = [];
      }
    }else{
      selectedFileList = [];
    }
    update();
  }


  String errorText = "Please try again!";

  Future<bool> validationOfAddActivity() async {
    initialActivityModel.name = activityNameTEC.text.trim();
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
    editTheInstructionSection();

    print("Initial Activity Generated is ${initialActivityModel.toString()}");

    if (!shouldContinue) {
      return false;
    } else {
      errorText = "";
    }

    return true;
  }

  void editTheInstructionSection(){
    if(selectedFileList.isNotEmpty){
      initialActivityModel.instrFile = selectedFileList.join(",");
    }else{
      initialActivityModel.instrFile = "";
    }
  }


  //Instructions.
  var selectedFileList = [];
  final _apiService = APIService();

  void selectAndUploadFile() async {
    var userId = GetStorage().read(AppStrings.localClientIdValue) ??
        AppStrings.defaultUserId;
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      //print("File Name is ${result.files.first.name} && ${DateTime.now().millisecond} && ${DateTime.now().millisecondsSinceEpoch}");
      var fileName = "${userId}__${DateTime.now().millisecondsSinceEpoch}__${result.files.first.name}";
      var extension = result.files.first.extension ?? "jpg";
      try{
        showPLoader();
        Dio.Response data = await _apiService
            .uploadMediaDataServer("${Constants.STORAGEURL}$fileName", result.files.first.path!,extension);
        print("Response is ${data.statusCode}");
        print("Response is ${data.statusMessage}");
        hidePLoader();
        if(data.statusCode!=null && data.statusCode == 200){
          selectedFileList.add(fileName);
          update();
        }
      }catch(onError, stackTrace){
        hidePLoader();
        print("While Uploading file error occured $onError");
        print("Stack trace is $stackTrace");
        //_apiService.handleDioError(onError);
      }
    } else {
      // User canceled the picker
    }
  }

  void removeFileFromList(int position) {
    selectedFileList.removeAt(position);
    update();
  }
}