import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:teamup/mixins/baseClass.dart';
import 'package:teamup/utils/app_colors.dart';

import '../../../bottom_sheets/date_picker.dart';
import '../../../controllers/GoalController.dart';
import '../../../widgets/edittext_with_hint.dart';
import '../../../widgets/rounded_edge_button.dart';

import '../../../widgets/CreateGoalMetaDataView.dart';
import '../invite_to_goal_page.dart';


class CreateGoalActivities extends StatefulWidget {
  const CreateGoalActivities({super.key});

  @override
  State<CreateGoalActivities> createState() => _CreateGoalActivitiesState();
}

class _CreateGoalActivitiesState extends State<CreateGoalActivities> with BaseClass{

  final GoalController activityGC = Get.put(GoalController());
  final TextEditingController controller = TextEditingController();
  String selectedDate = "";

  Widget _myRadioButton(
      {required String title,
        required int value,
        required Function onChanged}) {
    return RadioListTile(
      activeColor: Colors.grey.shade700,
      value: value,
      contentPadding: EdgeInsets.zero,
      groupValue: activityGC.radioGroupValue.value,
      onChanged: (val) {
        onChanged(val);
      },
      title: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    activityGC.resetData();
    return Scaffold(
      body: Container(
        child: GetBuilder<GoalController>(
            init: activityGC,
            builder: (val) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    CreateGoalMetaDataView(onPressed: (){
                      popToPreviousScreen(context: context);
                    },
                      sliderText: "3/4",
                      sliderValue: 80,
                      sliderColor: HexColor(AppColors.sliderColor),
                      goalMetaTitle: "Create goal Activities",
                      goalMetaDescription: "List the unique set of activities that need\nto be completed to achieve your goal.",),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Configure Activities",
                            style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 2.h,),
                          GetBuilder<GoalController>(
                              init: activityGC,
                              builder: (snapshot) {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics:
                                    const NeverScrollableScrollPhysics(),
                                    itemCount: activityGC
                                        .getActivityNames.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Activity ${index + 1}",
                                                style: GoogleFonts.roboto(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Text(
                                                "Edit",
                                                style: GoogleFonts.roboto(
                                                  color: Colors.red,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            padding:
                                            const EdgeInsets.only(left: 10),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                              BorderRadius.circular(5),
                                            ),
                                            height: 40,
                                            width: double.infinity,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                activityGC
                                                    .getActivityNames
                                                    .elementAt(index),
                                                style: GoogleFonts.roboto(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                        ],
                                      );
                                    });
                              }),
                          Text(
                            "Activity Name",
                            style: GoogleFonts.roboto(
                              color: Colors.grey.shade900,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5)),
                            child: EditTextWithHint(
                                hintText: "Enter activity Name",
                                context: context,
                                leftMargin: 0,
                                rightMargin: 0,
                                textEditingController:
                                activityGC.activityNameController,
                                inputAction: TextInputAction.done,
                                inputType: TextInputType.text),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ///Frequency
                          Text(
                            "Frequency",
                            style: GoogleFonts.roboto(
                              color: Colors.grey.shade900,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GetBuilder<GoalController>(
                              init: activityGC,
                              builder: (value) {
                                return Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ...activityGC.frequencies.map((e) {
                                      return InkWell(
                                        onTap: () {
                                          activityGC
                                              .updateSelection(e["index"]);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: 3),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: e["isSelected"]
                                                  ? Colors.red
                                                  : Colors.grey.shade300,
                                              borderRadius:
                                              BorderRadius.circular(15)),
                                          child: Text(
                                            e["name"],
                                            style: GoogleFonts.roboto(
                                                color: e["isSelected"]
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                        ),
                                      );
                                    })
                                  ],
                                );
                              }),
                          Obx(() {
                            return getSelectedDays(context);
                          }),
                          SizedBox(
                            height: 2.h,
                          ),
                          activityGC.selectedFrequencyIndex == 2 ||
                              activityGC.selectedFrequencyIndex == 3
                              ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Select dates",
                                style: GoogleFonts.roboto(
                                  color: Colors.grey.shade700,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                activityGC.selectedDaysText,
                                style: GoogleFonts.roboto(
                                  color: Colors.grey.shade400,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              GetBuilder<GoalController>(
                                  init: activityGC,
                                  builder: (val) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                          border: Border.all(
                                              color: Colors.grey)),
                                      child: TableCalendar(
                                        calendarStyle: CalendarStyle(selectedDecoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
                                        firstDay:
                                        DateTime.utc(2010, 10, 16),
                                        lastDay:
                                        DateTime.utc(2030, 3, 14),
                                        focusedDay: activityGC.selectedCalendarFocusedDay,
                                        /*onDaySelected:
                                            (selectedDay, focusedDay) {
                                          goalsController.updateCalendarDays(
                                              selectedDay,focusedDay);
                                        },
                                        selectedDayPredicate: (day) {
                                          return isSameDay(
                                              goalsController
                                                  .selectedCalendarDay,
                                              day);
                                        },*/
                                        selectedDayPredicate: (day) {
                                          // Use values from Set to mark multiple days as selected
                                          return activityGC.selectedDays.contains(day);
                                        },
                                        onDaySelected: activityGC.onDaySelected,

                                      ),
                                    );
                                  }),
                            ],
                          )
                              : Container(),
                          SizedBox(
                            height: 2.h,
                          ),
                          Text(
                            "When",
                            style: GoogleFonts.roboto(
                              color: Colors.grey.shade900,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          GetBuilder<GoalController>(
                              init: activityGC,
                              builder: (snapshot) {
                                return Column(
                                  children: [
                                    _myRadioButton(
                                        title: "Any time of the day",
                                        value: 0,
                                        onChanged: (newValue) {
                                          activityGC
                                              .updateRadioGroupValue(newValue);
                                          /*setState(() {
                                        _groupValue = newValue;
                                      });*/
                                        }),
                                    SizedBox(
                                      height: 45,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: _myRadioButton(
                                              title: "Specific time",
                                              value: 1,
                                              onChanged: (newValue) {
                                                activityGC
                                                    .updateRadioGroupValue(
                                                    newValue);
                                              },
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey.shade300,
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        5)),
                                                child: Center(
                                                  child: DropdownButton<String>(
                                                    icon: const SizedBox(),
                                                    hint: Center(
                                                        child: Text(
                                                          "3:00",
                                                          textAlign:
                                                          TextAlign.center,
                                                          style: GoogleFonts.roboto(
                                                            color: Colors.black,
                                                            fontWeight:
                                                            FontWeight.w500,
                                                          ),
                                                        )),
                                                    value: activityGC
                                                        .selectedDropDownTime,
                                                    items: activityGC
                                                        .getTimeList
                                                        .map((String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Center(
                                                            child: Text(
                                                              value,
                                                              textAlign:
                                                              TextAlign.center,
                                                              style: GoogleFonts
                                                                  .roboto(
                                                                color: Colors.black,
                                                                fontWeight:
                                                                FontWeight.w500,
                                                              ),
                                                            )),
                                                      );
                                                    }).toList(),
                                                    onChanged: (value) {
                                                      activityGC
                                                          .updateDropDownTime(
                                                          value!);
                                                    },
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey.shade300,
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        5)),
                                                height: 40,
                                                padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        activityGC
                                                            .updateAmPM(false);
                                                      },
                                                      child: Container(
                                                        height: 30,
                                                        width: 40,
                                                        decoration: BoxDecoration(
                                                            color: activityGC
                                                                .isPmSelected
                                                                ? Colors.grey
                                                                .shade300
                                                                : Colors.white,
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                5)),
                                                        child: Center(
                                                          child: Text(
                                                            "AM",
                                                            style: GoogleFonts
                                                                .roboto(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        activityGC
                                                            .updateAmPM(true);
                                                      },
                                                      child: Container(
                                                        height: 30,
                                                        width: 40,
                                                        decoration: BoxDecoration(
                                                            color: activityGC
                                                                .isPmSelected
                                                                ? Colors.white
                                                                : Colors.grey
                                                                .shade300,
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                5)),
                                                        child: Center(
                                                          child: Text(
                                                            "PM",
                                                            style: GoogleFonts
                                                                .roboto(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }),
                          const SizedBox(
                            height: 15,
                          ),
                          Obx(() {
                            return activityGC
                                .selectedFrequencyIndex.value ==
                                1 ||
                                activityGC
                                    .selectedFrequencyIndex.value ==
                                    2
                                ? Container()
                                : Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Duration",
                                  style: GoogleFonts.roboto(
                                    color: Colors.grey.shade700,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                GetBuilder<GoalController>(
                                    init: activityGC,
                                    builder: (value) {
                                      return Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ...activityGC
                                              .dailyFrequencyDuration
                                              .map((e) {
                                            return InkWell(
                                              onTap: () {
                                                activityGC
                                                    .updateDailyFrequencyDuration(
                                                    e["index"]);
                                              },
                                              child: Container(
                                                margin: EdgeInsets.symmetric(horizontal: 3),
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: 12,
                                                    vertical: 5),
                                                decoration: BoxDecoration(
                                                    color: e["isSelected"]
                                                        ? Colors.red
                                                        : Colors.grey
                                                        .shade300,
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        15)),
                                                child: Text(
                                                  e["name"],
                                                  style: GoogleFonts.roboto(
                                                      color:
                                                      e["isSelected"]
                                                          ? Colors
                                                          .white
                                                          : Colors
                                                          .black),
                                                ),
                                              ),
                                            );
                                          })
                                        ],
                                      );
                                    }),
                              ],
                            );
                          }),
                          const SizedBox(
                            height: 20,
                          ),
                          activityGC.selectedFrequencyIndex == 3
                              ? Container()
                              : Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                activityGC.selectedFrequencyIndex ==
                                    0
                                    ? "Set End Date (Optional)"
                                    : activityGC
                                    .selectedFrequencyIndex ==
                                    2
                                    ? "Set End Month"
                                    : "Set End Date",
                                style: GoogleFonts.roboto(
                                  color: Colors.grey.shade700,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              activityGC.selectedFrequencyIndex == 2
                                  ? Row(
                                children: [
                                  Container(
                                    padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius:
                                        BorderRadius.circular(
                                            5)),
                                    child: Center(
                                      child: DropdownButton<String>(
                                        //icon: const SizedBox(),
                                        hint: Center(
                                            child: Text(
                                              "January",
                                              textAlign:
                                              TextAlign.center,
                                              style: GoogleFonts.roboto(
                                                color: Colors.black,
                                                fontWeight:
                                                FontWeight.w500,
                                              ),
                                            )),
                                        value: activityGC
                                            .selectedMonth,
                                        items: activityGC
                                            .months
                                            .map((String value) {
                                          return DropdownMenuItem<
                                              String>(
                                            value: value,
                                            child: Center(
                                                child: Text(
                                                  value,
                                                  textAlign:
                                                  TextAlign.center,
                                                  style: GoogleFonts
                                                      .roboto(
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                  ),
                                                )),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          activityGC
                                              .updateMonthDropDown(
                                              value!);
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius:
                                        BorderRadius.circular(
                                            5)),
                                    child: Center(
                                      child: DropdownButton<String>(
                                        // icon: const SizedBox(),
                                        hint: Center(
                                            child: Text(
                                              "2021",
                                              textAlign:
                                              TextAlign.center,
                                              style: GoogleFonts.roboto(
                                                color: Colors.black,
                                                fontWeight:
                                                FontWeight.w500,
                                              ),
                                            )),
                                        value: activityGC
                                            .selectedYears,
                                        items: activityGC.years
                                            .map((String value) {
                                          return DropdownMenuItem<
                                              String>(
                                            value: value,
                                            child: Center(
                                                child: Text(
                                                  value,
                                                  textAlign:
                                                  TextAlign.center,
                                                  style: GoogleFonts
                                                      .roboto(
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                  ),
                                                )),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          activityGC
                                              .updateYearDropDown(
                                              value!);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              )
                                  : InkWell(
                                onTap: () async {
                                  CupertinoDatePickerBottomSheet()
                                      .cupertinoDatePicker(context,
                                          (selectedDate) {
                                        popToPreviousScreen(
                                            context: context);
                                        activityGC
                                            .updateSelectedDate(
                                            selectedDate);
                                      });
                                },
                                child: Container(
                                  height: 40,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey),
                                    borderRadius:
                                    BorderRadius.circular(5),
                                  ),
                                  padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GetBuilder<
                                            GoalController>(
                                            init: activityGC,
                                            builder: (snap) {
                                              return Text(
                                                snap.getSelectedDate
                                                    .isEmpty
                                                    ? "No end date"
                                                    : snap
                                                    .getSelectedDate,
                                                style: GoogleFonts
                                                    .roboto(
                                                    color: Colors
                                                        .grey),
                                              );
                                            }),
                                      ),
                                      const Icon(
                                        Icons.calendar_month,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Reminder",
                            style: GoogleFonts.roboto(
                              color: Colors.grey.shade700,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Obx(() {
                            return activityGC
                                .selectedFrequencyIndex.value ==
                                1 ||
                                activityGC
                                    .selectedFrequencyIndex.value ==
                                    2
                                ? Row(
                              children: [
                                Text(
                                  "Remind me at",
                                  style: GoogleFonts.roboto(
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius:
                                      BorderRadius.circular(5)),
                                  child: Center(
                                    child: DropdownButton<String>(
                                      //    icon: const SizedBox(),
                                      hint: Center(
                                          child: Text(
                                            "3:00",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.roboto(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )),
                                      value: activityGC
                                          .selectedDropDownTime,
                                      items: activityGC.getTimeList
                                          .map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Center(
                                              child: Text(
                                                value,
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.roboto(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              )),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        activityGC
                                            .updateDropDownTime(value!);
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "In the morning",
                                  style: GoogleFonts.roboto(
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                GetBuilder<GoalController>(
                                    init: activityGC,
                                    builder: (value) {
                                      return FlutterSwitch(
                                        height: 25,
                                        width: 50,
                                        activeColor: Colors.red,
                                        value: value.isReminderToggleOn,
                                        onToggle: (value) {
                                          activityGC
                                              .changeToggleState();
                                        },
                                      );
                                    }),
                              ],
                            )
                                : Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Remind me 10 minutes before that task starts",
                                    style: GoogleFonts.roboto(
                                      color: Colors.grey.shade700,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                GetBuilder<GoalController>(
                                    init: activityGC,
                                    builder: (value) {
                                      return FlutterSwitch(
                                        height: 28,
                                        width: 60,
                                        activeColor: Colors.red,
                                        value: value.isReminderToggleOn,
                                        onToggle: (value) {
                                          activityGC
                                              .changeToggleState();
                                        },
                                      );
                                    }),
                              ],
                            );
                          }),
                          const Divider(),
                          InkWell(
                            onTap: () {
                              if (activityGC.activityNameController.text
                                  .trim()
                                  .isNotEmpty) {
                                activityGC.addActivityName(
                                    activityGC
                                        .activityNameController.text
                                        .trim());
                                activityGC.activityNameController.text =
                                "";
                                activityGC.resetData();
                              }
                              else{
                                showError(title: "Empty", message: "Please add activity name");
                              }
                            },
                            child: Container(
                              height: 40,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.add_circle,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Add another activity",
                                    style: GoogleFonts.roboto(
                                      color: Colors.grey.shade500,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          RoundedEdgeButton(
                              backgroundColor: Colors.red,
                              text: "Next",
                              leftMargin: 0,
                              buttonRadius: 10,
                              rightMargin: 0,
                              topMargin: 15,
                              bottomMargin: 20,
                              onPressed: () {
                                pushToNextScreen(
                                    context: context,
                                    destination: const InviteToGoalPage());
                              },
                              context: context)
                        ],
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }

  Widget getSelectedDays(BuildContext context) {
    return activityGC.selectedFrequencyIndex.value == 1
        ? Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 30,
        ),
        Text(
          "Select days",
          style: GoogleFonts.roboto(
            color: Colors.grey.shade700,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        GetBuilder<GoalController>(
            init: activityGC,
            builder: (value) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ...activityGC.selectWeeklyDays.map((e) {
                    return InkWell(
                      onTap: () {
                        activityGC.updateWeeklyDays(e["index"]);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                            color: e["isSelected"]
                                ? Colors.red
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(15)),
                        child: Text(
                          e["name"],
                          style: GoogleFonts.roboto(
                              color: e["isSelected"]
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    );
                  })
                ],
              );
            }),
      ],
    )
        : Container();
  }
}
