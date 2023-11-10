import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import 'ProgressBarWidget.dart';

class ListErrorWidget extends StatelessWidget {
  final String text;
  const ListErrorWidget({super.key, required this.text, });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(text, style: GoogleFonts.openSans(
          color: Colors.black.withOpacity(0.6),
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),));
  }
}


class ListLoadingWidget extends StatelessWidget {
  const ListLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ProgressBarWidget(text: "Please Wait",);
  }
}