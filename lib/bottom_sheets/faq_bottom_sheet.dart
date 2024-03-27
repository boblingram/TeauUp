import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_Images.dart';
import '../utils/app_strings.dart';

class FaqBottomSheet {
  Future<void> faqBottomSheet({
    required BuildContext context,
  }) async {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black,
        isScrollControlled: true,
        isDismissible: true,
        elevation: 15,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0)),
              color: Colors.white,
            ),
            child: FractionallySizedBox(
              heightFactor: 0.9,
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Image(
                                image: AssetImage(AppImages.cancelIcon),
                                height: 15,
                                width: 15,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Container(
                              margin: const EdgeInsets.only(right: 25),
                              child: Text(
                                "Frequently Asked Questions",
                                style: GoogleFonts.roboto(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: AppStrings.questionFAQ.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return ExpansionTile(
                              iconColor: Colors.black,
                              collapsedIconColor: Colors.black,
                              tilePadding: const EdgeInsets.symmetric(horizontal: 20),
                              childrenPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              title: Text(
                                "${index+1}. ${AppStrings.questionFAQ.elementAt(index)}",
                                style: GoogleFonts.roboto(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              children: [
                                Text(
                                  AppStrings.answersFAQ.elementAt(index),
                                  style: GoogleFonts.roboto(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            );
                          }))
                ],
              ),
            ),
          );
        });
  }
}
