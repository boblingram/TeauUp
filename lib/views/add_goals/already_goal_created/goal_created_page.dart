import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:teamup/mixins/baseClass.dart';
import 'package:teamup/views/home_base/home_base_page.dart';

import '../../../utils/app_colors.dart';

class GoalCreatedPage extends StatelessWidget with BaseClass{
  const GoalCreatedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: InkWell(
        onTap: (){
          pushReplaceAndClearStack(context: context, destination: HomeBasePage());
        },
        child: Container(
          height: 45,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              "Home",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                color: AppColors.white,
                fontWeight: FontWeight.w400,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            "assets/lottie_files/success.json",
          ),
          Text(
            "Group Created",
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              color: AppColors.black,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Creating and setting goals is great\nbut achieving them can be much\nharder. We'll help you get there",
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              color: AppColors.darkGrey,
              fontWeight: FontWeight.w400,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
