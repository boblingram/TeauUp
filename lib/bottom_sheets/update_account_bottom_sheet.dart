import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teamup/controllers/settings_profile/settings_profile_controller.dart';
import 'package:teamup/mixins/baseClass.dart';
import 'package:teamup/widgets/edittext_with_hint.dart';
import 'package:teamup/widgets/rounded_edge_button.dart';

class UpdateAccountBottomSheet with BaseClass {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  SettingsProfileController settingsProfileController =
      Get.put(SettingsProfileController());

  Future<void> accountBottomSheet({
    required BuildContext context,
  }) async {
    nameController.text = settingsProfileController.getName;
    emailController.text = settingsProfileController.getEmail;
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black,
        isScrollControlled: true,
        isDismissible: true,
        elevation: 15,
        builder: (context) {
          return GetBuilder<SettingsProfileController>(
              init: settingsProfileController,
              builder: (value) {
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
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Update account",
                          style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              EditTextWithHint(
                                hintText: "Name",
                                context: context,
                                textEditingController: nameController,
                                inputAction: TextInputAction.done,
                                inputType: TextInputType.text,
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              EditTextWithHint(
                                hintText: "Email",
                                context: context,
                                textEditingController: emailController,
                                inputAction: TextInputAction.done,
                                inputType: TextInputType.emailAddress,
                              )
                            ],
                          ),
                        ),
                        RoundedEdgeButton(
                            backgroundColor: Colors.pink,
                            text: "Update Details",
                            bottomMargin: 100,
                            buttonRadius: 10,
                            onPressed: () {
                              if (nameController.text.isEmpty) {
                                showError(
                                    title: "Name",
                                    message: "Name cannot be empty");
                              } else if (emailController.text.isEmpty) {
                                showError(
                                    title: "Email",
                                    message: "Email cannot be empty");
                              } else {
                                removeFocusFromEditText(context: context);
                                value.updateUserData(
                                    nameController.text, emailController.text);
                                popToPreviousScreen(context: context);
                              }
                            },
                            context: context)
                      ],
                    ),
                  ),
                );
              });
        });
  }
}
