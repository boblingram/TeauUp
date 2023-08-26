import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:teamup/controllers/activity_frequency_controller.dart';
import 'package:teamup/mixins/baseClass.dart';
import 'package:teamup/utils/app_colors.dart';

import '../../../bottom_sheets/date_picker.dart';
import '../../../controllers/goalController.dart';
import '../../../widgets/edittext_with_hint.dart';
import '../../../widgets/rounded_edge_button.dart';

import '../invite_to_goal/invite_to_goal_page.dart';

class CreateGoalActivities extends StatelessWidget with BaseClass {
  CreateGoalActivities({Key? key}) : super(key: key);

  final GoalsController goalsController = Get.put(GoalsController());
  final GoalController activityController = Get.put(GoalController());
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
      groupValue: goalsController.radioGroupValue.value,
      onChanged: (val) {
        onChanged(val);
      },
      title: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    goalsController.resetData();
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<GoalsController>(
            init: goalsController,
            builder: (val) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      color: HexColor(AppColors.describeGoalColor),
                      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 1.5.h,),
                          InkWell(
                            onTap: () {
                              popToPreviousScreen(context: context);
                            },
                            child: Container(
                              height: 5.w,
                              width: 5.w,
                              child: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 11.h,),
                          Text(
                            "3/4",
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              wordSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Stack(
                            children: [
                              Container(
                                width: 120,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              Container(
                                width: 90,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h,),
                          Text(
                            "Create goal Activities",
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "List the unique set of activities that need\nto be completed to achieve your goal.",
                            style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
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
                              init: activityController,
                              builder: (snapshot) {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: activityController
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
                                                activityController
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
                                    activityController.activityNameController,
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
                          GetBuilder<GoalsController>(
                              init: goalsController,
                              builder: (value) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ...goalsController.frequencies.map((e) {
                                      return InkWell(
                                        onTap: () {
                                          goalsController
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
                          goalsController.selectedFrequencyIndex == 2 ||
                                  goalsController.selectedFrequencyIndex == 3
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
                                      "Selected dates: 4 & 5 of every month",
                                      style: GoogleFonts.roboto(
                                        color: Colors.grey.shade400,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    GetBuilder<GoalsController>(
                                        init: goalsController,
                                        builder: (val) {
                                          return Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    color: Colors.grey)),
                                            child: TableCalendar(
                                              firstDay:
                                                  DateTime.utc(2010, 10, 16),
                                              lastDay:
                                                  DateTime.utc(2030, 3, 14),
                                              focusedDay: DateTime.now(),
                                              selectedDayPredicate: (day) {
                                                return isSameDay(
                                                    goalsController
                                                        .selectedCalendarDay,
                                                    day);
                                              },
                                              onDaySelected:
                                                  (selectedDay, focusedDay) {
                                                goalsController.updateCalendarDays(
                                                    goalsController
                                                        .selectedCalendarDay!,
                                                    goalsController
                                                        .selectedCalendarFocusedDay);
                                              },
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
                          GetBuilder<GoalsController>(
                              init: goalsController,
                              builder: (snapshot) {
                                return Column(
                                  children: [
                                    _myRadioButton(
                                        title: "Any time of the day",
                                        value: 0,
                                        onChanged: (newValue) {
                                          goalsController
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
                                                goalsController
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
                                                    value: goalsController
                                                        .selectedDropDownTime,
                                                    items: goalsController
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
                                                      goalsController
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
                                                        goalsController
                                                            .updateAmPM(false);
                                                      },
                                                      child: Container(
                                                        height: 30,
                                                        width: 40,
                                                        decoration: BoxDecoration(
                                                            color: goalsController
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
                                                        goalsController
                                                            .updateAmPM(true);
                                                      },
                                                      child: Container(
                                                        height: 30,
                                                        width: 40,
                                                        decoration: BoxDecoration(
                                                            color: goalsController
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
                            return goalsController
                                            .selectedFrequencyIndex.value ==
                                        1 ||
                                    goalsController
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
                                      GetBuilder<GoalsController>(
                                          init: goalsController,
                                          builder: (value) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ...goalsController
                                                    .dailyFrequencyDuration
                                                    .map((e) {
                                                  return InkWell(
                                                    onTap: () {
                                                      goalsController
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
                          goalsController.selectedFrequencyIndex == 3
                              ? Container()
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      goalsController.selectedFrequencyIndex ==
                                              0
                                          ? "Set End Date (Optional)"
                                          : goalsController
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
                                    goalsController.selectedFrequencyIndex == 2
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
                                                    value: goalsController
                                                        .selectedMonth,
                                                    items: goalsController
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
                                                      goalsController
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
                                                    value: goalsController
                                                        .selectedYears,
                                                    items: goalsController.years
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
                                                      goalsController
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
                                                goalsController
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
                                                            GoalsController>(
                                                        init: goalsController,
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
                            return goalsController
                                            .selectedFrequencyIndex.value ==
                                        1 ||
                                    goalsController
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
                                            value: goalsController
                                                .selectedDropDownTime,
                                            items: goalsController.getTimeList
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
                                              goalsController
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
                                      GetBuilder<GoalsController>(
                                          init: goalsController,
                                          builder: (value) {
                                            return FlutterSwitch(
                                              height: 25,
                                              width: 50,
                                              activeColor: Colors.red,
                                              value: value.isReminderToggleOn,
                                              onToggle: (value) {
                                                goalsController
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
                                      GetBuilder<GoalsController>(
                                          init: goalsController,
                                          builder: (value) {
                                            return FlutterSwitch(
                                              height: 28,
                                              width: 60,
                                              activeColor: Colors.red,
                                              value: value.isReminderToggleOn,
                                              onToggle: (value) {
                                                goalsController
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
                              if (activityController.activityNameController.text
                                  .trim()
                                  .isNotEmpty) {
                                activityController.addActivityName(
                                    activityController
                                        .activityNameController.text
                                        .trim());
                                activityController.activityNameController.text =
                                    "";
                                goalsController.resetData();
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
    return goalsController.selectedFrequencyIndex.value == 1
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
              GetBuilder<GoalsController>(
                  init: goalsController,
                  builder: (value) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ...goalsController.selectWeeklyDays.map((e) {
                          return InkWell(
                            onTap: () {
                              goalsController.updateWeeklyDays(e["index"]);
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
