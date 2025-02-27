import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:teamup/utils/app_colors.dart';

class ProgressBarWidget extends StatelessWidget {
  final String? text;
  final String? progressColor;
  final bool isExpanded;
  const ProgressBarWidget({Key? key, this.text, this.progressColor, this.isExpanded = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        width: Get.width * 0.8,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: HexColor(progressColor ?? AppColors.progressBarC),
              ),
              this.text != null ? SizedBox(width: 28) : Container(),
              this.text != null ? isExpanded ? Expanded(child: Text("${this.text}")): Text("${this.text}")  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}