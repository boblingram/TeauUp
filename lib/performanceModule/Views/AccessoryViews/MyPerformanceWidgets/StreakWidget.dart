import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;
import '../../../Controllers/PerformanceController.dart';
import '../../../DaysSpeedoMeter.dart';
import '../../../Utilities/Extensions.dart';

class StreakWidget extends StatelessWidget {
  final PerformanceController performanceController = Get.find();
  StreakWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(()=>Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300] ?? Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 150,
                  height: 150,
                  color: Colors.grey[100],
                  //Testing value = 50, totalValue = 128
                  child: CustomPaint(
                    //startAngle, sweepAngle, value, totalValue, strokeCircleW, basicTextS, innerBTextS, innerSTextS
                    painter: DaySpeedoMeter(
                        math.pi * 0.75, math.pi * 1.55,performanceController.days.value,performanceController.totalDay.value,5,13.sp,16.sp,12.sp
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20,),
              Column(
                children: [
                  StreakPerformanceWidget(icon: Icons.flash_on, topText: "${performanceController.currentStreak.value} Days", bottomText: "Current Streak"),
                  Container(
                    height: 2,
                    width: 22.w,
                    color: Colors.grey[300],
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  ),
                  StreakPerformanceWidget(icon: Icons.flash_on, topText: "${performanceController.longestStreak.value} Days", bottomText: "Longest Streak")
                ],
              )
            ],
          ),
          Container(
            height: 1,
            color: Colors.grey[300],
            margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
          ),
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            7,
                (index) => Expanded(
              child: StreakDayWidget(dayValueStatus: performanceController.sevenDayStatus.value.elementAt(index),value: index+1,))
            ),
          ),
          SizedBox(height: 1.h,),
          Text("Last 7 Days")
        ],
      ),
    ));
  }
}

class StreakDayWidget extends StatelessWidget {
  final String dayValueStatus;
  final int value;
  const StreakDayWidget({Key? key, required this.dayValueStatus, required this.value}) : super(key: key);

  Widget getTopCircleIcon(String value){
    switch(value){
      case "done":
        return Icon(Icons.check_circle,color: Colors.red);
      case "notdone":
        return Icon(Icons.incomplete_circle,color: Colors.deepOrangeAccent,);
      default:
        return Icon(Icons.circle_outlined);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        getTopCircleIcon(dayValueStatus),
        Text(value.toDay1Name())
      ],
    );
  }
}


class StreakPerformanceWidget extends StatelessWidget {
  final IconData icon;
  final String topText;
  final String bottomText;
  const StreakPerformanceWidget({Key? key, required this.icon, required this.topText, required this.bottomText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon,color: Colors.red,),
              SizedBox(height: 5,),
              Text(topText,style: TextStyle(fontSize: 15.sp),),
            ],),
          Text(bottomText,style: TextStyle(fontSize: 12.sp),)
        ],
      ),
    );
  }
}