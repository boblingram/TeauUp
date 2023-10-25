import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:teamup/mixins/baseClass.dart';
import 'package:teamup/utils/GoalIconandColorStatic.dart';
import 'package:teamup/utils/app_colors.dart';
import 'package:teamup/utils/app_integers.dart';

import '../../../bottom_sheets/date_picker.dart';
import '../../../controllers/GoalController.dart';
import '../../../models/IndividualGoalActivityModel.dart';
import '../../../widgets/edittext_with_hint.dart';
import '../../../widgets/rounded_edge_button.dart';

import '../../../widgets/CreateGoalMetaDataView.dart';
import '../invite_to_goal_page.dart';

class CreateGoalActivities extends StatefulWidget {
  final String selectedGoal;

  const CreateGoalActivities({super.key, required this.selectedGoal});

  @override
  State<CreateGoalActivities> createState() => _CreateGoalActivitiesState();
}

class _CreateGoalActivitiesState extends State<CreateGoalActivities>
    with BaseClass {
  final GoalController activityGC = Get.put(GoalController());
  final TextEditingController controller = TextEditingController();
  String selectedDate = "";

  Color selectionColor = Colors.red;
  Color unSelectedColor = Colors.grey.shade300;
  String hexSelectedColorString = "#FF0000";
  final FocusNode _focusNode = FocusNode();

  Widget _myRadioButton(
      {required String title,
      required int value,
      required Function onChanged}) {
    return RadioListTile(
      activeColor: selectionColor,
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
  void initState() {
    selectionColor =
        HexColor(GoalIconandColorStatic.getColorName(widget.selectedGoal));
    unSelectedColor = HexColor(AppColors.nonActivitySelectedBGColor);
    hexSelectedColorString = GoalIconandColorStatic.getColorName(widget.selectedGoal);
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  bool _isTapInsideTextField(Offset tapPosition) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    return renderBox.paintBounds.contains(tapPosition);
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
                    CreateGoalMetaDataView(
                      onPressed: () {
                        activityGC.closeGoalActivity();
                      },
                      sliderText: "3/4",
                      sliderValue: 80,
                      sliderColor: HexColor(AppColors.sliderColor),
                      goalMetaTitle: "Create goal Activities",
                      containerBackgroundColor:
                          GoalIconandColorStatic.getColorName(
                              widget.selectedGoal),
                      goalMetaDescription:
                          "List the unique set of activities that need\nto be completed to achieve your goal.",
                    ),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Configure Activities",
                            style: GoogleFonts.openSans(
                              color:
                                  HexColor(AppColors.staticActivityTextColor),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: activityGC
                                  .successfullyCreatedActivityList.length,
                              itemBuilder: (BuildContext context, int index) {
                                var item = activityGC
                                    .successfullyCreatedActivityList
                                    .elementAt(index);
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Activity ${index + 1}",
                                          style: GoogleFonts.openSans(
                                            color: HexColor(AppColors
                                                .staticActivityTextColor),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            activityGC.editGoalActivitySheet(
                                                item, index,selectedColor: selectionColor);
                                          },
                                          child: Text(
                                            "Edit",
                                            style: GoogleFonts.openSans(
                                              color: selectionColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      height: 40,
                                      width: double.infinity,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          item.name ?? "",
                                          style: GoogleFonts.openSans(
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
                              }),
                          Text(
                            "Activity Name",
                            style: GoogleFonts.openSans(
                              color:
                                  HexColor(AppColors.staticActivityTextColor),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
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
                                focusNode: _focusNode,
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
                            style: GoogleFonts.openSans(
                              color:
                                  HexColor(AppColors.staticActivityTextColor),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ...activityGC.frequencies.map((e) {
                                return InkWell(
                                  onTap: () {
                                    _focusNode.unfocus();
                                    activityGC
                                        .updateFrequencySelection(e["index"]);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 3),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: e["isSelected"]
                                            ? selectionColor
                                            : unSelectedColor,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Text(
                                      e["name"],
                                      style: GoogleFonts.openSans(
                                          color: e["isSelected"]
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  ),
                                );
                              })
                            ],
                          ),
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
                                      style: GoogleFonts.openSans(
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
                                      style: GoogleFonts.openSans(
                                        color: Colors.grey.shade400,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border:
                                              Border.all(color: Colors.grey)),
                                      child: TableCalendar(
                                        calendarStyle: CalendarStyle(
                                            selectedDecoration: BoxDecoration(
                                                color: selectionColor,
                                                shape: BoxShape.circle)),
                                        firstDay: DateTime.utc(2010, 10, 16),
                                        lastDay: DateTime.utc(2030, 3, 14),
                                        focusedDay: activityGC
                                            .selectedCalendarFocusedDay,
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
                                          return activityGC.selectedDays
                                              .contains(day);
                                        },
                                        onDaySelected: activityGC.onDaySelected,
                                      ),
                                    )
                                  ],
                                )
                              : Container(),
                          SizedBox(
                            height: 0.5.h,
                          ),
                          Text(
                            "When",
                            style: GoogleFonts.openSans(
                              color:
                                  HexColor(AppColors.staticActivityTextColor),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Column(
                            children: [
                              _myRadioButton(
                                  title: "Any time of the day",
                                  value: 0,
                                  onChanged: (newValue) {
                                    _focusNode.unfocus();
                                    activityGC.updateRadioGroupValue(newValue);
                                    /*setState(() {
                                        _groupValue = newValue;
                                      });*/
                                  }),
                              SizedBox(
                                height: 45,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: _myRadioButton(
                                        title: "Specific time",
                                        value: 1,
                                        onChanged: (newValue) {
                                          _focusNode.unfocus();
                                          activityGC
                                              .updateRadioGroupValue(newValue);
                                        },
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: unSelectedColor,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Center(
                                            child: DropdownButton<String>(
                                              icon: const SizedBox(),
                                              hint: Center(
                                                  child: Text(
                                                "3:00",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.openSans(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
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
                                                    style: GoogleFonts.openSans(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  )),
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                _focusNode.unfocus();
                                                activityGC
                                                    .updateDropDownTime(value!);
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: unSelectedColor,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          height: 40,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  _focusNode.unfocus();
                                                  activityGC.updateAmPM(false);
                                                },
                                                child: Container(
                                                  height: 30,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                      color: activityGC
                                                              .isPmSelected
                                                          ? unSelectedColor
                                                          : Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child: Center(
                                                    child: Text(
                                                      "AM",
                                                      style: GoogleFonts.openSans(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  _focusNode.unfocus();
                                                  activityGC.updateAmPM(true);
                                                },
                                                child: Container(
                                                  height: 30,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                      color: activityGC
                                                              .isPmSelected
                                                          ? Colors.white
                                                          : unSelectedColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child: Center(
                                                    child: Text(
                                                      "PM",
                                                      style: GoogleFonts.openSans(
                                                          color: Colors.black),
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
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Obx(() {
                            return activityGC.selectedFrequencyIndex.value ==
                                        1 ||
                                    activityGC.selectedFrequencyIndex.value == 2
                                ? Container()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Duration",
                                        style: GoogleFonts.openSans(
                                          color: HexColor(AppColors
                                              .staticActivityTextColor),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ...activityGC.dailyFrequencyDuration
                                              .map((e) {
                                            return Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  _focusNode.unfocus();
                                                  activityGC
                                                      .updateDailyFrequencyDuration(
                                                          e["index"]);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 3),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                                  decoration: BoxDecoration(
                                                      color: e["isSelected"]
                                                          ? selectionColor
                                                          : unSelectedColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  child: Text(
                                                    e["name"],
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.openSans(
                                                        color: e["isSelected"]
                                                            ? Colors.white
                                                            : Colors.black),
                                                  ),
                                                ),
                                              ),
                                            );
                                          })
                                        ],
                                      ),
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
                                      "Set End Date (Optional)",
                                      style: GoogleFonts.openSans(
                                        color: Colors.grey.shade700,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        _focusNode.unfocus();
                                        CupertinoDatePickerBottomSheet()
                                            .cupertinoDatePicker(context,
                                                (selectedDate) {
                                          popToPreviousScreen(context: context);
                                          print("end Date is ${selectedDate}");
                                          activityGC.updateSelectedEndDate(
                                              selectedDate);
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: Text(
                                              activityGC.getSelectedDate.isEmpty
                                                  ? "No end date"
                                                  : activityGC.getSelectedDate,
                                              style: GoogleFonts.openSans(
                                                  color: Colors.grey),
                                            )),
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
                            style: GoogleFonts.openSans(
                              color:
                                  HexColor(AppColors.staticActivityTextColor),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: activityGC.isReminderToggleOn
                                  ? Text.rich(
                                TextSpan(
                                  style: GoogleFonts.openSans(
                                    color: Colors.grey.shade700,
                                    fontSize: 10.5.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  children: [
                                    TextSpan(text: 'Remind me '),
                                    TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          // Handle the tap action here
                                          _focusNode.unfocus();
                                          CupertinoTimePickerBottomSheet()
                                              .cupertinoTimePicker(context,
                                                  (selectedTime) {
                                                popToPreviousScreen(
                                                    context: context);
                                                // Split the custom time string into hours, minutes, and seconds
                                                activityGC.updateReminderTime(
                                                    selectedTime);
                                              });
                                        },
                                      text: activityGC.reminderTime,
                                    ),
                                    TextSpan(text: ' before that task starts'),
                                  ],
                                ),
                              )
                                  : Text(
                                "Do not remind me",
                                style: GoogleFonts.openSans(
                                  color: Colors.grey.shade700,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),flex: 7,),
                              Expanded(
                                flex: 1,
                                child: FlutterSwitch(
                                  height: 25,
                                  width: 50,
                                  activeColor: selectionColor,
                                  value: activityGC.isReminderToggleOn,
                                  onToggle: (value) {
                                    activityGC.changeToggleState();
                                    if (value) {
                                      CupertinoTimePickerBottomSheet()
                                          .cupertinoTimePicker(context,
                                              (selectedTime) {
                                        popToPreviousScreen(context: context);
                                        // Split the custom time string into hours, minutes, and seconds
                                        activityGC
                                            .updateReminderTime(selectedTime);
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          InkWell(
                            onTap: () async {
                              _focusNode.unfocus();
                              if (activityGC.activityNameController.text
                                  .trim()
                                  .isEmpty) {
                                showError(
                                    title: "Empty",
                                    message: "Please add activity name");
                                return;
                              }
                              activityGC.updateActivityName(activityGC
                                  .activityNameController.text
                                  .trim());
                              var response =
                                  await activityGC.validationOfAddActivity(selectedColor: selectionColor);
                              if (!response) {
                                showError(
                                    title: "Error",
                                    message: activityGC.errorText);
                                return;
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
                                    style: GoogleFonts.openSans(
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
                              backgroundColor: selectionColor,
                              text: "Next",
                              leftMargin: 0,
                              buttonRadius: 10,
                              rightMargin: 0,
                              topMargin: 15,
                              bottomMargin: 20,
                              onPressed: () async {
                                _focusNode.unfocus();
                                if(activityGC.successfullyCreatedActivityList.isNotEmpty){
                                  pushToNextScreen(
                                      context: context,
                                      destination: InviteToGoalPage(selectedGoal: widget.selectedGoal,));
                                  return;
                                }
                                if (activityGC.activityNameController.text
                                    .trim()
                                    .isEmpty) {
                                  showError(
                                      title: "Empty",
                                      message: "Please add activity name");
                                  return;
                                }
                                activityGC.updateActivityName(activityGC
                                    .activityNameController.text
                                    .trim());
                                var response =
                                    await activityGC.validationOfAddActivity(selectedColor: selectionColor);
                                if (!response) {
                                  showError(
                                      title: "Error",
                                      message: activityGC.errorText);
                                  return;
                                }
                                pushToNextScreen(
                                    context: context,
                                    destination: InviteToGoalPage(selectedGoal: widget.selectedGoal,));
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
                style: GoogleFonts.openSans(
                  color: Colors.grey.shade700,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ...activityGC.selectWeeklyDays.map((e) {
                    return InkWell(
                      onTap: () {
                        _focusNode.unfocus();
                        activityGC.updateWeeklyDays(e["index"]);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                            color: e["isSelected"]
                                ? selectionColor
                                : unSelectedColor,
                            borderRadius: BorderRadius.circular(15)),
                        child: Text(
                          e["name"],
                          style: GoogleFonts.openSans(
                              color: e["isSelected"]
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    );
                  })
                ],
              ),
            ],
          )
        : Container();
  }
}
//Code for End Month
/*
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
                                                    //icon: const SizedBox(),
                                                    hint: Center(
                                                        child: Text(
                                                      "January",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: GoogleFonts.openSans(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    )),
                                                    value: activityGC
                                                        .selectedMonth,
                                                    items: activityGC.months
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
                                                      style: GoogleFonts.openSans(
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
 */
