import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:teamup/models/GoalActivityModel.dart';

class EndGoalWidget extends StatelessWidget {
  EndGoalWidget({Key? key, required this.userGoalPerInfo}) : super(key: key);

  final UserGoalPerInfo userGoalPerInfo;

  String getRequiredTime(var tempDate){
    var updatedDate = DateTime.tryParse(tempDate) ?? DateTime.now();
    return DateFormat('dd MMMM').format(updatedDate);
  }

  //TODO and Discuss EndGoalView Functionality

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${userGoalPerInfo.goalInfo.name ?? ""}",
                style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 14),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Ended on ${getRequiredTime(userGoalPerInfo.goalInfo.endDate)}",
                style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 12),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Text(
              "View",
              style: GoogleFonts.roboto(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

