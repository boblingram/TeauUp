import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teamup/mixins/baseClass.dart';

import '../describe_goal/describe_goal_page.dart';

class SetGoalPage extends StatelessWidget with BaseClass {
  SetGoalPage({Key? key}) : super(key: key);
  final List<String> goalList = [
    "Wellness",
    "Yoga",
    "Study",
    "Cycling",
    "Running",
    "Walking",
    "Gym",
    "Introspection",
    "Custom"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: const Color(0xff718D95),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome Saradhi!",
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 22,
                    letterSpacing: 1,
                    wordSpacing: 2,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "1/4",
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    wordSpacing: 2,
                  ),
                ),
                const SizedBox(height: 5),
                Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    Container(
                      width: 30,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  "Set a Goal",
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Choose a goal from a list below to\nstart. You can create your own goal if\nyou are not able to find one in the list\nbelow.",
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              itemCount: goalList.length,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    pushToNextScreen(
                      context: context,
                      destination: DescribeGoalPage(
                        selectedGoal: goalList.elementAt(index),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: goalList.elementAt(index) == "Custom"
                              ? Colors.grey
                              : Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: goalList.elementAt(index) == "Custom"
                            ? const Icon(
                                Icons.add,
                                size: 30,
                                color: Colors.white,
                              )
                            : Container(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        goalList.elementAt(index),
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
