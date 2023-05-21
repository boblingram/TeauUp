import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teamup/mixins/baseClass.dart';
import 'package:teamup/utils/app_colors.dart';

import '../../../widgets/rounded_edge_button.dart';
import '../already_goal_created/goal_created_page.dart';

class ConfirmAndCreateGoalPage extends StatelessWidget with BaseClass{
  const ConfirmAndCreateGoalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.goalAppBarColor,
        centerTitle: true,
        title: Text(
          "Confirm & Create",
          style: GoogleFonts.roboto(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: const BoxDecoration(
                                color: AppColors.goalAppBarColor,
                                shape: BoxShape.circle),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Study",
                                  style: GoogleFonts.roboto(
                                    color: AppColors.darkGrey,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Practice Maths",
                                  style: GoogleFonts.roboto(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "Edit",
                            style: GoogleFonts.roboto(
                              color: AppColors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "This goal will help us to focus on solving maths problems. The topics that will be taken over time would be \"Arithmetic, Number System, and Number theory, Algebra, Geometry, and Calculus\" ",
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Activities",
                            style: GoogleFonts.roboto(
                              color: AppColors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "Edit",
                            style: GoogleFonts.roboto(
                              color: AppColors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Calculus - Solve 5 Different equations",
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 2,
                            child: getActivityDetails(
                                Icons.calendar_month, "Daily"),
                          ),
                          Flexible(
                            flex: 2,
                            child: getActivityDetails(
                                Icons.lock_clock, "9:00 - 9:30"),
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
                      Row(
                        children: [
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
                          const SizedBox(
                            width: 5,
                          ),
                          FlutterSwitch(
                            height: 25,
                            width: 50,
                            activeColor: Colors.red,
                            value: true,
                            onToggle: (bool val) {},
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Geometry - Study Euclidean geometry",
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            flex: 2,
                            child: getActivityDetails(
                                Icons.calendar_month, "Weekly: Mon"),
                          ),
                          Flexible(
                            flex: 2,
                            child: getActivityDetails(
                                Icons.lock_clock, "Anytime of day"),
                          ),
                          Flexible(
                            flex: 1,
                            child: getActivityDetails(
                                Icons.timelapse_outlined, "45 min"),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
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
                            "No end date set",
                            style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "Remind me at ",
                            style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          Container(
                            height: 30,
                            padding: const EdgeInsets.only(left: 5),
                            decoration:
                                BoxDecoration(color: Colors.grey.shade200),
                            child: Center(
                              child: Row(
                                children: [
                                  Text(
                                    "8:00 AM",
                                    style: GoogleFonts.roboto(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 0,
                                  ),
                                  const Icon(Icons.arrow_drop_down)
                                ],
                              ),
                            ),
                          ),
                          Text(
                            " in the morning",
                            style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          FlutterSwitch(
                            height: 25,
                            width: 50,
                            activeColor: Colors.red,
                            value: false,
                            onToggle: (bool val) {},
                          ),
                        ],
                      ),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Group Goal",
                          style: GoogleFonts.roboto(
                            color: AppColors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "Edit",
                          style: GoogleFonts.roboto(
                            color: AppColors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Invited members",
                      style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    getInvitedMembers(),
                    getInvitedMembers(),
                    getInvitedMembers(),
                    getInvitedMembers(),
                    getInvitedMembers(),
                    getInvitedMembers(),
                  ],
                ),
              ),
              RoundedEdgeButton(
                  backgroundColor: Colors.red,
                  text: "Invite & Create Goal",
                  leftMargin: 00,
                  buttonRadius: 10,
                  topMargin: 20,
                  rightMargin: 00,
                  bottomMargin: 20,
                  onPressed: () {
                      pushToNextScreen(context: context, destination: GoalCreatedPage());
                  },
                  context: context)
            ],
          ),
        ),
      ),
    );
  }

  Widget getInvitedMembers() {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 25,
            width: 25,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey),
            ),
            child: const Center(child: Icon(Icons.person)),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tarun",
                style: GoogleFonts.roboto(color: Colors.black, fontSize: 12),
              ),
              Text(
                "Mentored by Saradhi",
                style: GoogleFonts.roboto(color: Colors.black, fontSize: 12),
              ),
            ],
          )
        ],
      ),
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
