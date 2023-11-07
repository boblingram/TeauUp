import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';

import '../utils/app_colors.dart';

class CreateGoalMetaDataView extends StatelessWidget {
  final Function onPressed;
  final String goalMetaTitle;
  final String goalMetaDescription;
  final double sliderValue;
  final String sliderText;
  final Color sliderColor;
  final bool showWelcome;
  final String welcomeName;
  final bool showBack;
  final String? containerBackgroundColor;

  const CreateGoalMetaDataView(
      {super.key,
      this.showBack = true,
      required this.onPressed,
      required this.goalMetaTitle,
      required this.goalMetaDescription,
      this.sliderValue = 0,
      this.sliderText = "",
      this.sliderColor = Colors.black,
      this.showWelcome = false,
      this.welcomeName = "", this.containerBackgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: HexColor(containerBackgroundColor ?? AppColors.describeGoalColor),
      padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 3.h,
          ),
          showBack
              ? InkWell(
                  onTap: () {
                    onPressed();
                  },
                  child: Container(
                    height: 5.w,
                    width: 5.w,
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                )
              : Container(),
          showWelcome
              ? WelcomeView(welcomeName: welcomeName)
              : SizedBox(
                  height: 11.h,
                ),
          SliderWidget(
            sliderValue: sliderValue,
            sliderText: sliderText,
            sliderColor: sliderColor,
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            goalMetaTitle,
            style: GoogleFonts.openSans(
              color: Colors.white.withOpacity(0.6),
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,

            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            goalMetaDescription,
            style: GoogleFonts.openSans(
                color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.w400, fontSize: 11.sp,letterSpacing: 0.2,height: 1.35),
          ),
        ],
      ),
    );
  }
}

class WelcomeView extends StatelessWidget {
  final String welcomeName;

  const WelcomeView({super.key, required this.welcomeName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 11.h,
        ),
        Text(
          "Welcome $welcomeName!",
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 18.sp,
            letterSpacing: 1,
            wordSpacing: 2,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}

class SliderWidget extends StatelessWidget {
  final String sliderText;
  final double sliderValue;
  final Color sliderColor;

  const SliderWidget(
      {super.key,
      required this.sliderText,
      required this.sliderValue,
      required this.sliderColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sliderText,
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
              width: sliderValue,
              height: 5,
              decoration: BoxDecoration(
                color: sliderColor.withOpacity(0.6),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
