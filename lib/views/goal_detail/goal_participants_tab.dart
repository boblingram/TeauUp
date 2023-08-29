import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/app_colors.dart';

class GoalParticipantsTabPage extends StatelessWidget {
  const GoalParticipantsTabPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Participants: 6",
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  color: AppColors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade400),
              ),
              margin: const EdgeInsets.only(bottom: 5),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: ListView.builder(
                  itemCount: 7,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return index==6?addMoreWidget():getInvitedMembers(index);
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget addMoreWidget(){
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.add_circle,color: Colors.black,),
          const SizedBox(width: 10,),
          Text(
            "Add more participants",
            style: GoogleFonts.roboto(
                color: Colors.black,
                fontSize:  14 ,
                fontWeight:
                FontWeight.w600 ),
          ),
        ],
      ),
    );
  }

  Widget getInvitedMembers(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  index == 0 ? "Saradhi (You)" : "Tarun",
                  style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: index == 0 ? 16 : 12,
                      fontWeight:
                          index == 0 ? FontWeight.w700 : FontWeight.w400),
                ),
                Text(
                  index == 0
                      ? "Your mentor is Tanvi - You are mentoring Tarun,Srikar, Tanvi, and Rishab"
                      : "Mentored by Saradhi",
                  style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: index == 0 ? 14 : 12,
                      fontWeight:
                          index == 0 ? FontWeight.w600 : FontWeight.w400),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down_sharp,
            color: Colors.grey,
            size: 20,
          )
        ],
      ),
    );
  }
}
