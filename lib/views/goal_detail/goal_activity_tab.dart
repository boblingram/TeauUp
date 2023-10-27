import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';
import 'package:teamup/controllers/VEGoalController.dart';
import 'package:teamup/utils/GoalIconandColorStatic.dart';
import 'package:teamup/widgets/ErrorListWidget.dart';

import '../../utils/app_colors.dart';

class GoalActivityTabPage extends StatelessWidget {
  final bool isEditingEnabled;
  final String localGoalType;
  GoalActivityTabPage({Key? key, required this.isEditingEnabled, required this.localGoalType,}) : super(key: key);

  VEGoalController veGoalController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: isEditingEnabled ? Container(
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
            veGoalController.endGoalIsPressed();
          },
          child: Center(
            child: Text(
              "End and Archive Goal",
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                color: AppColors.black,
                fontWeight: FontWeight.w400,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ) : null,
      body: Container(
        color: Colors.white,
        child: GetBuilder<VEGoalController>(
          builder: (veGoalController){
            return veGoalController.selectedGoalActivityList.isNotEmpty ? RefreshIndicator(
              onRefresh: ()async{
                veGoalController.refreshGoalActivityList();
              },
              child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 2.h,horizontal: 0),
                  itemCount: veGoalController.selectedGoalActivityList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    var item = veGoalController.selectedGoalActivityList.elementAt(index);
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
                                    "${index+1}. ${veGoalController.convertStringToNotNull(item.name)}",
                                    style: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  ),
                                  isEditingEnabled ? InkWell(
                                    onTap: (){
                                      veGoalController.editGoalActivitySheet(item,index,selectedColor: HexColor(GoalIconandColorStatic.getColorName(localGoalType)));
                                    },
                                    child: Text(
                                      "Edit",
                                      style: GoogleFonts.openSans(
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ) : Container(),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: getActivityDetails(Icons.calendar_month, veGoalController.convertFrequencyToAppropriate(item.freq)),
                                  ),
                                  Flexible(
                                    flex: 2,
                                    child:
                                    getActivityDetails(Icons.lock_clock, veGoalController.convertTimeToAppropriate(item.time)),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: getActivityDetails(
                                        Icons.timelapse_outlined, veGoalController.convertDurationToAppropriate(item.duration)),
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
                                    style: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    veGoalController.convertEndDateToAppropriate(item.endDt),
                                    style: GoogleFonts.openSans(
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
                              veGoalController.showReminderDate(item.reminder) ? const Text.rich(
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
                              ) : Container(),
                            ],
                          ),
                        ),
                        SizedBox(height: 4.h,),
                      ],
                    );
                  }),
            ) : ErrorListWidget(text: "Goal Activity List is Empty");
          },
        ),
      ),
    );
  }

  Widget getActivityDetails(IconData icon, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Icon(
            icon,
            color: Colors.grey,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: GoogleFonts.openSans(color: Colors.black, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
