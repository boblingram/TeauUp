import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../Constants.dart';
import '../../../Controllers/PerformanceController.dart';

class BadgeWidget extends StatelessWidget {
  final PerformanceController performanceController = Get.find();

  BadgeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Badges Earned"),
        SizedBox(height: 1.3.h,),
        SizedBadgedList(badgeList: performanceController.badgesEarnedList),
        SizedBox(height: 1.7.h,),
        Text("Badges Left"),
        SizedBox(height: 1.3.h,),
        SizedBadgedList(badgeList: performanceController.badgesLeftList),
      ],
    );
  }
}

class SizedBadgedList extends StatelessWidget {
  final List badgeList;
  const SizedBadgedList({Key? key, required this.badgeList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: badgeList.isEmpty ? 0 : 10.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: badgeList.length,
        itemBuilder: (BuildContext context, int index) {
          var item = badgeList.elementAt(index);
          return Container(
            width: 10.h,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Image.network(item.icon,
                    errorBuilder: (context,object,stackTrace){
                      print("Image Error ");
                      return Image.network(IMAGEURL);
                    },),
                ),
                Text(item.name),
              ],
            ),
          );
        },
      ),
    );
  }
}
