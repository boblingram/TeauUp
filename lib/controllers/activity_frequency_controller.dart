import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoalsController extends GetxController {
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
  void updateMonthDropDown(String month){
    selectedMonth =month ;
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
  void updateYearDropDown(String month){
    selectedYears =month ;
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
  DateTime ?selectedCalendarDay =DateTime.now();
  DateTime selectedCalendarFocusedDay =DateTime.now();

  void updateCalendarDays (DateTime current , DateTime focused){
    selectedCalendarDay =current ;
    selectedCalendarFocusedDay =focused ;
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
    selectedFrequencyIndex.value=0;
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

  var selectedFrequencyIndex = 0.obs ;

  RxInt radioGroupValue = 10.obs ;

  void updateRadioGroupValue(int val){
    radioGroupValue.value =val ;
    update();
  }

  String selectedDropDownTime = "3:00";

  void updateDropDownTime(String time){
    selectedDropDownTime =time ;
    update();
  }
  bool isPmSelected = true;
  void updateAmPM(bool val){
    isPmSelected =val ;
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

      update();
    }
  }
}
