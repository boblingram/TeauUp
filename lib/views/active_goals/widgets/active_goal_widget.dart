import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teamup/mixins/baseClass.dart';
import 'package:teamup/utils/app_Images.dart';
import 'package:teamup/utils/app_strings.dart';
import 'package:teamup/views/goal_detail/goal_detail_page.dart';

import '../../../utils/app_colors.dart';

class ActiveGoalWidget extends StatelessWidget with BaseClass {
  const ActiveGoalWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        pushToNextScreen(
          context: context,
          destination: const GoalDetailPage(),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.greyWithShade300,
            ),
            borderRadius: BorderRadius.circular(5)),
        margin: const EdgeInsets.only(bottom: 15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                        color: AppColors.green, shape: BoxShape.circle),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.practiceMaths,
                          style: GoogleFonts.roboto(
                              color: AppColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Container(
                              height: 8,
                              width: 8,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: AppColors.green),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              AppStrings.nextActivityInOneHour,
                              style: GoogleFonts.roboto(
                                  color: AppColors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(15)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Text(
                      AppStrings.view,
                      style: GoogleFonts.roboto(color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.greyWithShade300,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage(AppImages.shareIcon),
                            height: 12,
                            width: 12,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "10th Rank",
                            style: GoogleFonts.roboto(
                              color: AppColors.black,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.greyWithShade300,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage(AppImages.shareIcon),
                            height: 12,
                            width: 12,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "0 days streak",
                            style: GoogleFonts.roboto(
                                color: AppColors.black, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.greyWithShade300,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage(AppImages.shareIcon),
                            height: 12,
                            width: 12,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "143 xp points",
                            style: GoogleFonts.roboto(
                                color: AppColors.black, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.prupleWithShade300,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: Center(
                child: Text(
                  "We generate fear when we do nothing. We overcome those fears by taking actions",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    color: AppColors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
