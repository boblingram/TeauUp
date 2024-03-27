import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_Images.dart';

class TermsBottomSheet {
  Future<void> termsBottomSheet(
      {required BuildContext context,
      required String title,
      required String data,
      required Function onCloseClick}) async {
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
            margin: const EdgeInsets.only(top: 100),
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              onCloseClick();
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
                              title,
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
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        data,
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
