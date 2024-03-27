import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teamup/bottom_sheets/contact_us_bottom_sheet.dart';
import 'package:teamup/bottom_sheets/faq_bottom_sheet.dart';
import 'package:teamup/bottom_sheets/privacy_policy_bottom_sheet.dart';
import 'package:teamup/controllers/VEGoalController.dart';
import 'package:teamup/controllers/settings_profile/settings_profile_controller.dart';
import 'package:teamup/mixins/baseClass.dart';
import 'package:teamup/utils/app_Images.dart';
import 'package:teamup/utils/app_strings.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../bottom_sheets/terms_condition_bottom_sheet.dart';
import '../../bottom_sheets/update_account_bottom_sheet.dart';
import '../../widgets/settings_option.dart';

class SettingsPage extends StatelessWidget with BaseClass {
  SettingsPage({Key? key}) : super(key: key);
  final SettingsProfileController _settingsProfileController =
      Get.put(SettingsProfileController());
  final VEGoalController veGoalController = Get.find();

  Widget _getDivider() {
    return const Divider(
      height: 0,
      thickness: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        centerTitle: false,
        leading: InkWell(
          onTap: () {
            popToPreviousScreen(context: context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        title: Text(
          "Settings",
          style: GoogleFonts.openSans(color: Colors.black),
        ),
        actions: [
          Icon(
            Icons.notifications,
            color: Colors.grey.shade900,
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                Image(
                  image: AssetImage(AppImages.userIcon),
                  height: 60,
                  width: 60,
                ),
                const SizedBox(
                  width: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      veGoalController.userName,
                      style: GoogleFonts.openSans(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    /*Text(
                      "joined 1st jul 2021  ",
                      style: GoogleFonts.openSans(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                      ),
                    ),*/
                  ],
                )
              ],
            ),
          ),
          _getDivider(),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 35, bottom: 5),
            child: Text(
              "Account",
              style: GoogleFonts.openSans(
                color: Colors.grey,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ),
          _getDivider(),
        OptionTile(
          title: "Name",
          trailingWidget: Row(
            children: [
              Text(
                veGoalController.userName,
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey,
                size: 12,
              ),
            ],
          ),
          onTap: () {
            UpdateAccountBottomSheet().accountBottomSheet(
              context: context,
            );
          },
        ),
          _getDivider(),
          /*GetBuilder<SettingsProfileController>(
              init: _settingsProfileController,
              builder: (value) {
                return OptionTile(
                  title: "Email",
                  tileHeight: value.getEmail.isEmpty ? 50 : 70,
                  subTitle: value.getEmail.isEmpty
                      ? ""
                      : "Verification link is sent on the above mentioned email address.",
                  trailingWidget: _settingsProfileController.getEmail.isEmpty
                      ? Row(
                          children: [
                            Text(
                              "Add",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.openSans(
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.orange,
                              size: 12,
                            ),
                          ],
                        )
                      : Text(
                          value.getEmail,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                            color: Colors.black,
                          ),
                        ),
                  onTap: () {
                    UpdateAccountBottomSheet().accountBottomSheet(
                      context: context,
                    );
                  },
                );
              }),*/
          _getDivider(),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 35, bottom: 5),
            child: Text(
              "Help & Support",
              style: GoogleFonts.openSans(
                color: Colors.grey,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ),
          _getDivider(),
          OptionTile(
            title: "Contact Us",
            trailingWidget: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey,
              size: 12,
            ),
            onTap: () {
              ContactUsBottomSheet().contactUsBottomSheet(
                context: context,
              );
            },
          ),
          _getDivider(),
          OptionTile(
            title: "Frequently Asked Questions",
            trailingWidget: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey,
              size: 12,
            ),
            onTap: () {
              FaqBottomSheet().faqBottomSheet(
                context: context,
              );
            },
          ),
          _getDivider(),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 35, bottom: 5),
            child: Text(
              "About our service",
              style: GoogleFonts.openSans(
                color: Colors.grey,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ),
          _getDivider(),
          OptionTile(
            title: "Terms & Conditions",
            trailingWidget: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey,
              size: 12,
            ),
            onTap: () {
              TermsBottomSheet().termsBottomSheet(
                  context: context,
                  title: "Terms & Conditions",
                  data: AppStrings.termsData,
                  onCloseClick: () {
                    popToPreviousScreen(context: context);
                  });
            },
          ),
          _getDivider(),
          OptionTile(
            title: "Privacy Policy",
            trailingWidget: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey,
              size: 12,
            ),
            onTap: () {
              PrivacyPolicyBottomSheet().privacyBottomSheet(
                  context: context,
                  title: "Privacy Policy",
                  data: AppStrings.privacyData,
                  onCloseClick: () {
                    popToPreviousScreen(context: context);
                  });
            },
          ),
          _getDivider(),
          const SizedBox(
            height: 30,
          ),
          _getDivider(),
          OptionTile(
            title: "Rate us on App Store",
            trailingWidget: Image(
              image: AssetImage(
                AppImages.shareIcon,
              ),
              color: Colors.grey,
              height: 15,
              width: 15,
            ),
            onTap: () async {
              final Uri url = Uri.parse('https://flutter.dev');
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
          _getDivider(),
          OptionTile(
            title: "Share TeamUp with friends",
            trailingWidget: Image(
              image: AssetImage(
                AppImages.shareIcon,
              ),
              color: Colors.grey,
              height: 15,
              width: 15,
            ),
            onTap: () {
              /*Share.share(
                  'Hey download Teamp Up from this link \nhttps://play.google.com/store/apps/details?id=com.orbision');*/
            },
          ),
          _getDivider(),
          const SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              "TeamUp Version\n1.0",
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
