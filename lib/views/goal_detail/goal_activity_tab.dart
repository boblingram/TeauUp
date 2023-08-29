import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:teamup/controllers/GoalDetailController.dart';

import '../../utils/app_colors.dart';

class GoalActivityTabPage extends StatelessWidget {
  GoalActivityTabPage({Key? key}) : super(key: key);

  GoalDetailController goalDetailController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:  Container(
        height: 5.h,
        width: double.infinity,
        margin:  EdgeInsets.fromLTRB(5.w,2.w,5.w,3.h),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: (){
            goalDetailController.endGoalIsPressed();
          },
          child: Center(
            child: Text(
              "End Goal",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                color: AppColors.black,
                fontWeight: FontWeight.w400,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 2.h,horizontal: 0),
          itemCount: 5,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${index+1}. Calculus - Solve 5 Different equations",
                            style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              goalDetailController.editGoalActivitySheet("");
                            },
                            child: Text(
                              "Edit",
                              style: GoogleFonts.roboto(
                                color: AppColors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 2,
                            child: getActivityDetails(Icons.calendar_month, "Daily"),
                          ),
                          Flexible(
                            flex: 2,
                            child:
                                getActivityDetails(Icons.lock_clock, "9:00 - 9:30"),
                          ),
                          Flexible(
                            flex: 1,
                            child: getActivityDetails(
                                Icons.timelapse_outlined, "30 min"),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Text(
                            "End date: ",
                            style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "30/07/2023",
                            style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: 'Set to remind '),
                            TextSpan(
                              text: '10 min ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: 'before that task starts'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.h,),
              ],
            );
          }),
    );
  }

  Widget getActivityDetails(IconData icon, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.grey,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          title,
          style: GoogleFonts.roboto(color: Colors.black, fontSize: 12),
        ),
      ],
    );
  }
}
