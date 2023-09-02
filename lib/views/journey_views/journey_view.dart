import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';
import 'package:teamup/utils/Enums.dart';
import 'package:teamup/utils/app_strings.dart';

import '../../utils/app_colors.dart';

class Journey_View extends StatefulWidget {
  const Journey_View({super.key});

  @override
  State<Journey_View> createState() => _Journey_ViewState();
}

class _Journey_ViewState extends State<Journey_View> {
  @override
  Widget build(BuildContext context) {
    return Container(child: ListView.builder(itemBuilder: (context, index) {
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
    }));
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
  final bool showAbove;
  final String showAboveText;
  final JourneyStatus journeyStatus;

  const IndividualJourneyItemWidget(
      {super.key,
      this.showButtons = false,
      this.showDate = false,
      this.dateText = "",
      this.weekDayText = "",
      this.nameText = "",
      this.descText = "",
      this.timeText = "",
      this.journeyStatus = JourneyStatus.Success,
      this.showAbove = false,
      this.showAboveText = ""});

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
          Icons.timelapse,
          color: Colors.red,
        );
      case JourneyStatus.Success:
      default:
        return Icon(
          Icons.check_circle_outlined,
          color: Colors.green,
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
          showAbove ? Column(
            children: [
              Row(
                children: [
                  Expanded(flex: 2,child: Container()),
                  Expanded(
                    flex: 18,
                    child: Wrap(
                      children: [Container(
                        padding: EdgeInsets.symmetric(vertical: 2,horizontal: 5),

                        decoration: BoxDecoration(
                            color: Colors.red,
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Text(
                          showAboveText,style: TextStyle(color: Colors.white),
                        ),
                      )],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(flex: 2,child: Container()),
                  Expanded(
                    flex: 9,
                    child: Wrap(

                        children: [Container(
                          width: 2,
                          height: 20,
                          margin: EdgeInsets.symmetric(vertical: 3),
                          color: Colors.grey.shade300,
                        )]),
                  ),
                ],
              ),

            ],
          ) : Container(),
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
                          children: [Text(dateText), Text(weekDayText)],
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
                              padding:
                                  EdgeInsets.symmetric(horizontal: 2, vertical: 2),
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
                      SizedBox(
                        height: 0.5.h,
                      ),
                      showButtons
                          ? Row(
                              children: [
                                CustomButton(
                                  text: AppStrings.defaultMarkasComplete,
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
                                  textStyle:
                                      TextStyle(fontSize: 12, color: Colors.red),
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
  final String text;
  final EdgeInsets? paddingButton;
  final BoxDecoration? boxDecoration;
  final TextStyle? textStyle;

  CustomButton(
      {super.key,
      this.paddingButton,
      this.text = AppStrings.defaultMarkasComplete,
      this.boxDecoration,
      this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          paddingButton ?? EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: boxDecoration ??
          BoxDecoration(
            border: Border.all(color: Colors.green),
            borderRadius: BorderRadius.circular(3),
          ),
      child: Text(
        text,
        style: textStyle ?? TextStyle(fontSize: 12, color: Colors.green),
      ),
    );
  }
}
