import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/PerformanceController.dart';
import 'package:sizer/sizer.dart';

class TopMyPerformanceWidget extends StatelessWidget {
  final PerformanceController performanceController = Get.find();
  TopMyPerformanceWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(()=>Row(children: [
      Expanded(child: TopPerformanceWidget(icon: Icons.flash_on, topText: performanceController.totalXP.value, bottomText: 'Total XP',)),
      Expanded(child: TopPerformanceWidget(icon: Icons.star, topText: performanceController.latestBadgeName.value, bottomText: 'Latest Badge',))
    ],));
  }
}

class TopPerformanceWidget extends StatelessWidget {
  final IconData icon;
  final String topText;
  final String bottomText;
  const TopPerformanceWidget({Key? key, required this.icon, required this.topText, required this.bottomText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300] ?? Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon,color: Colors.red,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(topText,style: TextStyle(fontSize: 15.sp),),
              SizedBox(height: 5,),
              Text(bottomText,style: TextStyle(fontSize: 12.sp),)
            ],)
        ],
      ),
    );
  }
}