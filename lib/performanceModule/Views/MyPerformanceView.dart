import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamup/utils/app_Images.dart';
import '../Controllers/PerformanceController.dart';
import 'package:sizer/sizer.dart';

import 'AccessoryViews/MyPerformanceWidgets/BadgeWidget.dart';
import 'AccessoryViews/MyPerformanceWidgets/CompareGoalWidget.dart';
import 'AccessoryViews/MyPerformanceWidgets/EarnedWidget.dart';
import 'AccessoryViews/MyPerformanceWidgets/StreakWidget.dart';
import 'AccessoryViews/MyPerformanceWidgets/TopMyPerformanceWidget.dart';

class SeparatorSection extends StatelessWidget {
  const SeparatorSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 2.h,
    );
  }
}

class MyPerformanceView extends StatefulWidget {
  const MyPerformanceView({Key? key}) : super(key: key);

  @override
  State<MyPerformanceView> createState() => _MyPerformanceViewState();
}

class _MyPerformanceViewState extends State<MyPerformanceView> {
  final PerformanceController performanceController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 8),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ///Top Widget
            TopMyPerformanceWidget(),
            SeparatorSection(),

            ///Streak
            Row(
              children: [
                Text(
                  "Streak",
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: 8,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "All Goals",
                    style:
                    TextStyle(fontSize: 12.sp),
                  ),
                ),
                /*Obx(() => DropdownButton(
                      value:
                          performanceController.dropStreakSelectedValue.value,
                      items: performanceController.dropStreakDownList,
                      onChanged: (value) {
                        performanceController.dropStreakSelectedValue.value =
                            value ?? 1;
                      },
                      underline: Container(
                        height: 0,
                        color: Colors.transparent,
                      ),
                    ))*/
              ],
            ),
            SeparatorSection(),
            StreakWidget(),
            SeparatorSection(),

            ///Compare Goals
            Row(
              children: [
                Text(
                  "Compare Goals",
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SeparatorSection(),
            CompareGoalWidget(),
            SeparatorSection(),

            ///Compare Activities
            /*Row(
              children: [
                Text(
                  "Compare Activities",
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SeparatorSection(),
            Image.asset(
              AppImages.compareActivitiesImage,
              width: 100.w,
            ),
            SeparatorSection(),*/

            ///Earned
            Row(
              children: [
                Text(
                  "Earned XP:",
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(margin:EdgeInsets.symmetric(vertical: 8),child: Text("All goals",style: TextStyle(fontSize: 12.sp),)),
                /*Obx(() => DropdownButton(
                    value: performanceController.dropEarnedSelectedValue.value,
                    items: performanceController.dropEarnedDownList,
                    onChanged: (value) {
                      performanceController.dropEarnedSelectedValue.value =
                          value ?? 1;
                    }))*/
              ],
            ),
            SeparatorSection(),
            EarnedWidget(),
            SeparatorSection(),

            ///Badges
            Row(
              children: [
                Text(
                  "Badges",
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SeparatorSection(),
            BadgeWidget(),
          ],
        ),
      ),
    );
  }
}
