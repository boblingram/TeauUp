import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:teamup/controllers/GoalActivityController.dart';
import 'package:teamup/controllers/VEGoalController.dart';
import 'package:teamup/mixins/baseClass.dart';
import 'package:teamup/models/IndividualGoalActivityModel.dart';
import 'package:teamup/utils/app_colors.dart';
import 'package:teamup/widgets/edittext_with_hint.dart';
import 'package:teamup/widgets/rounded_edge_button.dart';

import '../bottom_sheets/date_picker.dart';

class EditGoalActivityView extends StatefulWidget {
  final IndividualGoalActivityModel activityModel;

  const EditGoalActivityView(
      {super.key, required this.activityModel});

  @override
  State<EditGoalActivityView> createState() => _EditGoalNDViewState();
}

class _EditGoalNDViewState extends State<EditGoalActivityView> with BaseClass {

  VEGoalController veGoalController = Get.find();
  GoalActivityController goalActivityController = Get.put(GoalActivityController());

  @override
  void initState() {
    super.initState();
    goalActivityController.updateModelFromReceived(widget.activityModel);
  }


  @override
  void dispose() {
    super.dispose();
  }

  Widget _myRadioButton(
      {required String title,
        required int value,
        required Function onChanged}) {
    return RadioListTile(
      activeColor: Colors.grey.shade700,
      value: value,
      contentPadding: EdgeInsets.zero,
      groupValue: goalActivityController.radioGroupValue.value,
      onChanged: (val) {
        onChanged(val);
      },
      title: Text(title),
    );
  }

  Widget getSelectedDays(BuildContext context) {
    return goalActivityController.selectedFrequencyIndex.value == 1
        ? Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 15,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ...goalActivityController.selectWeeklyDays.map((e) {
              return InkWell(
                onTap: () {
                  goalActivityController.updateWeeklyDays(e["index"]);
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
        ),
      ],
    )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GoalActivityController>(
        builder: (activityGC) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(Icons.cancel,color: HexColor(AppColors.customIconBG),size: 20.sp,), onPressed: () { Get.back();},
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 3.w, vertical: 2.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            activityGC.activityNameTEC,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ...activityGC.frequencies.map((e) {
                            return InkWell(
                              onTap: () {
                                activityGC
                                    .updateFrequencySelection(e["index"]);
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
                      ),
                      Obx(() {
                        return getSelectedDays(context);
                      }),
                      SizedBox(
                        height: 1.h,
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
                          Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(8),
                                border:
                                Border.all(color: Colors.grey)),
                            child: TableCalendar(
                              calendarStyle: CalendarStyle(
                                  selectedDecoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle)),
                              firstDay: DateTime.utc(2010, 10, 16),
                              lastDay: DateTime.utc(2030, 3, 14),
                              focusedDay: activityGC
                                  .selectedCalendarFocusedDay,
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
                        height: 1.h,
                      ),
                      Text(
                        "When",
                        style: GoogleFonts.roboto(
                          color: Colors.grey.shade900,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Column(
                        children: [
                          _myRadioButton(
                              title: "Any time of the day",
                              value: 0,
                              onChanged: (newValue) {
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
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                          BorderRadius.circular(5)),
                                      child: Center(
                                        child: DropdownButton<String>(
                                          icon: const SizedBox(),
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
                                                      fontWeight:
                                                      FontWeight.w500,
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
                                      width: 10,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                          BorderRadius.circular(5)),
                                      height: 40,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              activityGC.updateAmPM(false);
                                            },
                                            child: Container(
                                              height: 30,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                  color: activityGC
                                                      .isPmSelected
                                                      ? Colors.grey.shade300
                                                      : Colors.white,
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      5)),
                                              child: Center(
                                                child: Text(
                                                  "AM",
                                                  style: GoogleFonts.roboto(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              activityGC.updateAmPM(true);
                                            },
                                            child: Container(
                                              height: 30,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                  color: activityGC
                                                      .isPmSelected
                                                      ? Colors.white
                                                      : Colors
                                                      .grey.shade300,
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      5)),
                                              child: Center(
                                                child: Text(
                                                  "PM",
                                                  style: GoogleFonts.roboto(
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
                              style: GoogleFonts.roboto(
                                color: Colors.grey.shade700,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
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
                                                ? Colors.red
                                                : Colors
                                                .grey.shade300,
                                            borderRadius:
                                            BorderRadius.circular(
                                                15)),
                                        child: Text(
                                          e["name"],
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.roboto(
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
                            style: GoogleFonts.roboto(
                              color: Colors.grey.shade700,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
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
                                        activityGC.getSelectedEndDate.isEmpty
                                            ? "No end date"
                                            : activityGC.getSelectedEndDate,
                                        style: GoogleFonts.roboto(
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
                        style: GoogleFonts.roboto(
                          color: Colors.grey.shade700,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
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
                              InkWell(
                                onTap: () {
                                  CupertinoTimePickerBottomSheet()
                                      .cupertinoTimePicker(context,
                                          (selectedTime) {
                                        popToPreviousScreen(context: context);
                                        // Split the custom time string into hours, minutes, and seconds
                                        activityGC
                                            .updateReminderTime(selectedTime);
                                      });
                                },
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius:
                                        BorderRadius.circular(5)),
                                    child: Center(
                                        child:
                                        Text(activityGC.reminderTime))),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                          FlutterSwitch(
                            height: 25,
                            width: 50,
                            activeColor: Colors.red,
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
                        ],
                      ),
                      const Divider(),
                      RoundedEdgeButton(
                          backgroundColor: Colors.red,
                          text: "Update",
                          leftMargin: 0,
                          buttonRadius: 10,
                          rightMargin: 0,
                          topMargin: 15,
                          bottomMargin: 20,
                          onPressed: () async {
                            var validationStarted = await goalActivityController.validationOfAddActivity();
                            if(!validationStarted){
                              showError(title: "Error", message: "${goalActivityController.errorText}");
                              return;
                            }
                            Get.back(result: goalActivityController.initialActivityModel);
                          },
                          context: context)
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
