import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';
import 'package:teamup/utils/Enums.dart';
import 'package:teamup/utils/app_strings.dart';
import 'package:teamup/widgets/ErrorListWidget.dart';

import '../../controllers/VEGoalController.dart';
import '../../utils/app_colors.dart';

class Journey_View extends StatefulWidget {
  final bool isGoalTab;
  final String goalId;
  final String? participantId;
  final bool showJourney;
  const Journey_View({super.key, this.isGoalTab = false, this.goalId = "", this.participantId, this.showJourney = true});

  @override
  State<Journey_View> createState() => _Journey_ViewState();
}

class _Journey_ViewState extends State<Journey_View> {
  VEGoalController veGoalController = Get.find();
  bool showJourneyDate = false;

  /*Map<String, bool> journeyDateSorted = {
    "Yesterday": false,
    "Today": false,
    "Upcoming": false
  };*/

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {postUIBuild();});
  }

  void postUIBuild(){
    if(widget.showJourney){
      veGoalController.getJourneyData(localGoalId: widget.goalId,newUserId: widget.participantId);
    }else{
      veGoalController.restrictedJourneyAccess();
    }
    //veGoalController.getFromJourneyJson(localIsJourney: widget.isGoalTab);
  }

  @override
  Widget build(BuildContext context) {
    String currentSection = "";
    DateTime? upcomingDate;
    bool hasUpcomingDateAssigned = false;

    return Container(
        child: GetBuilder<VEGoalController>(
          builder: (veGoalController){
            return veGoalController.journeyGoalList.isNotEmpty
                ? ListView.builder(
                itemCount: veGoalController.journeyGoalList.length,
                itemBuilder: (context, index) {
                  var item = veGoalController.journeyGoalList.elementAt(index);
                  DateTime newDate = DateTime.tryParse(item.date) ??
                      veGoalController.currentDateTime;
                  if (index == 0) {
                    showJourneyDate = true;
                  } else {
                    DateTime oldDate = DateTime.tryParse(veGoalController
                        .journeyGoalList
                        .elementAt(index - 1)
                        .date) ??
                        veGoalController.currentDateTime;
                    showJourneyDate =
                    !veGoalController.checkJDate(oldDate, newDate);
                  }

                  String section =
                      ""; // Initialize section for the current item.

                  if (veGoalController.checkJDate(
                      veGoalController.currentDateTime, newDate)) {
                    //This is Today
                    section = "Today";
                  } else if (newDate
                      .isAfter(veGoalController.currentDateTime)) {
                    //This is Upcoming
                    section = "Upcoming";
                    if (!hasUpcomingDateAssigned) {
                      upcomingDate = newDate;
                      hasUpcomingDateAssigned = true;
                    }
                  } else if (veGoalController.checkJDate(
                      veGoalController.currentDateTime
                          .subtract(Duration(days: 1)),
                      newDate)) {
                    //This is Yesterday
                    section = "Yesterday";
                  }

                  // Check if the section has changed, and update currentSection accordingly.
                  if (section != currentSection) {
                    currentSection = section;
                    //showJourneyDate = true;
                  } else {
                    //showJourneyDate = false;
                  }

                  // Determine if the section text should be displayed.
                  bool showSectionText = showJourneyDate && section.isNotEmpty;

                  if (showSectionText && section == "Upcoming") {
                    if (upcomingDate != null &&
                        veGoalController.checkJDate(upcomingDate!, newDate)) {
                    } else {
                      showSectionText = false;
                    }
                  }
                  /*var showSortedText = false;
      var sortedTextValue = "";
      if(newDate.isAfter(veGoalController.currentDateTime)){
        //This is Upcoming
        var tempItem = journeyDateSorted["Upcoming"] ?? false;
        if(!tempItem){
          showSortedText = true;
          sortedTextValue = "Upcoming";
          journeyDateSorted["Upcoming"] = true;
        }
      }else if(veGoalController.checkJDate(veGoalController.currentDateTime, newDate)){
        //This is Today
        var tempItem = journeyDateSorted["Today"] ?? false;
        if(!tempItem){
          showSortedText = true;
          sortedTextValue = "Today";
          journeyDateSorted["Today"] = true;
        }
      }else if(veGoalController.checkJDate(veGoalController.currentDateTime.subtract(Duration(days: 1)), newDate)){
        //This is Yesterday
        var tempItem = journeyDateSorted["Yesterday"] ?? false;
        if(!tempItem){
          showSortedText = true;
          sortedTextValue = "Yesterday";
          journeyDateSorted["Yesterday"] = true;
        }
      }*/
                  var journeyStatus = veGoalController.convertJStatusToJourney(
                      item.status, item.date);

                  return IndividualJourneyItemWidget(
                    rowIndex: index,
                    showButtons: journeyStatus != JourneyStatus.Failed &&
                        journeyStatus != JourneyStatus.Success,
                    showDate: showJourneyDate,
                    timeText:
                    veGoalController.convertJTimeToTimeText(item.time),
                    dateText:
                    veGoalController.convertJDatetoDateText(item.date),
                    weekDayText:
                    veGoalController.convertJDateToDayText(item.date),
                    nameText:
                    veGoalController.convertStringToNotNull(item.name),
                    descText:
                    veGoalController.convertStringToNotNull(item.desc),
                    journeyStatus: journeyStatus,
                    showDateSorted: showSectionText,
                    dateSortedText: section,
                    taskId: item.id.toString() ?? "",
                  );
                })
                : ErrorListWidget(text: veGoalController.journeyErrorText);
          })
    );
  }
}

class IndividualJourneyItemWidget extends StatelessWidget {
  final String dateText;
  final String weekDayText;
  final String nameText;
  final String descText;
  final String timeText;
  final bool showButtons;
  final bool showDate;
  final bool showDateSorted;
  final String dateSortedText;
  final JourneyStatus journeyStatus;
  final String taskId;
  final int rowIndex;

  IndividualJourneyItemWidget(
      {super.key,
      this.showButtons = false,
      this.showDate = false,
      this.dateText = "",
      this.weekDayText = "",
      this.nameText = "",
      this.descText = "",
      this.timeText = "",
      this.journeyStatus = JourneyStatus.Success,
      this.showDateSorted = false,
      this.dateSortedText = "",
      this.taskId = "",
      required this.rowIndex});

  final VEGoalController veGoalController = Get.find();

  Widget getJourneyStatus() {
    switch (journeyStatus) {
      case JourneyStatus.Failed:
        return Container(
          width: 4.5.w,
          height: 4.5.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.red, // Border color
              width: 1.1, // Border width
            ),
          ),
          child: Center(
            child: Icon(
              Icons.close_outlined,
              color: Colors.red,
              size: 10.sp,
            ),
          ),
        );
      case JourneyStatus.Upcoming:
        return Icon(
          Icons.circle_outlined,
          color: Colors.grey,
        );
      case JourneyStatus.Success:
        return Icon(
          Icons.check_circle_outlined,
          color: Colors.green,
        );
      default:
        return Icon(
          Icons.timelapse,
          color: Colors.red,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showDateSorted
              ? Column(
                  children: [
                    Row(
                      children: [
                        Expanded(flex: 2, child: Container()),
                        Expanded(
                          flex: 18,
                          child: Wrap(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 5),
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  dateSortedText,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(flex: 2, child: Container()),
                        Expanded(
                          flex: 9,
                          child: Wrap(children: [
                            Container(
                              width: 2,
                              height: 20,
                              margin: EdgeInsets.symmetric(vertical: 3),
                              color: Colors.grey.shade300,
                            )
                          ]),
                        ),
                      ],
                    ),
                  ],
                )
              : Container(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //Date
              Expanded(
                  flex: 1,
                  child: showDate
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              dateText,
                              maxLines: 1,
                              textAlign: TextAlign.end,
                              style: TextStyle(fontSize: 10.sp),
                            ),
                            Text(
                              weekDayText,
                              maxLines: 1,
                              textAlign: TextAlign.end,
                              style: TextStyle(fontSize: 10.sp),
                            )
                          ],
                        )
                      : Container()),
              //Activity Tick with Vertical
              Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      getJourneyStatus(),
                      SizedBox(
                        height: 5,
                      ),
                      ConstrainedBox(
                          constraints:
                              BoxConstraints(minHeight: 35.0, maxHeight: 60),
                          child: Container(
                            width: 2,
                            color: Colors.grey.shade300,
                          ))
                    ],
                  )),
              //Name Description with Mark as Complete and Skip it
              Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Text(
                              nameText,
                              style: TextStyle(
                                  fontSize: 13.sp, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: HexColor(AppColors.journeyColor),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2, vertical: 2),
                              child: ClipRRect(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Icon(
                                        Icons.access_time,
                                        size: 9.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 0.5.w,
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        timeText,
                                        style: TextStyle(fontSize: 9.sp),
                                        maxLines: 1,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 0.5.h,
                      ),
                      Text(descText),
                      showButtons
                          ? Row(
                              children: [
                                CustomButton(
                                  text: AppStrings.defaultMarkasComplete,
                                  onTap: () {
                                    veGoalController.updateJourneyMutation(
                                        JourneyMutationEnum.MarkasComplete, rowIndex,
                                        taskId: taskId,);
                                  },
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                CustomButton(
                                  text: AppStrings.defaultSkipText,
                                  boxDecoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.red,
                                      ),
                                      borderRadius: BorderRadius.circular(3)),
                                  textStyle: TextStyle(
                                      fontSize: 12, color: Colors.red),
                                  onTap: () {
                                    veGoalController.updateJourneyMutation(
                                        JourneyMutationEnum.SkipIt,rowIndex,taskId: taskId);
                                  },
                                )
                              ],
                            )
                          : Container()
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final Function onTap;
  final String text;
  final EdgeInsets? paddingButton;
  final BoxDecoration? boxDecoration;
  final TextStyle? textStyle;

  CustomButton(
      {super.key,
      required this.onTap,
      this.paddingButton,
      this.text = AppStrings.defaultMarkasComplete,
      this.boxDecoration,
      this.textStyle});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        padding:
            paddingButton ?? EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: boxDecoration ??
            BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(3),
            ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: textStyle ?? TextStyle(fontSize: 12, color: Colors.green),
        ),
      ),
    );
  }
}

/*
Container(child: ListView.builder(itemBuilder: (context, index) {
      return IndividualJourneyItemWidget(
        showButtons: index % 2 != 0,
        showDate: index % 2 == 0,
        timeText: "6 - 6:15 am",
        dateText: "19 Jun",
        weekDayText: "Sun",
        nameText: "Slow Breathing Excercise",
        descText: "Meditation",
        journeyStatus: index % 2 == 0 ? JourneyStatus.Failed : JourneyStatus.Success,
        showAbove: index % 9 == 0 ,
        showAboveText: "Yesterday",
      );
    }))
 */
