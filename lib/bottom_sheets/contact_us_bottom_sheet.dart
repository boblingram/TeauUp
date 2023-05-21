import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_Images.dart';
import '../utils/app_strings.dart';
import '../widgets/rounded_edge_button.dart';

class ContactUsBottomSheet {
  Future<void> contactUsBottomSheet({
    required BuildContext context,
  }) async {
    List<String> locations = [
      'Goals/Credit Edit',
      'Lorem Ipsum 1',
      'Lorem Ipsum 2',
      'Lorem Ipsum 3'
    ];
    String selectedLocation = 'Goals/Credit Edit';
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24.0),
                          topRight: Radius.circular(24.0)),
                      color: Colors.grey.shade200,
                    ),
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
                                "Contact Us",
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
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      "Category",
                      style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    //alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 45,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: DropdownButton(
                      hint: const Text('Goals/Credit Edit'),
                      // Not necessary for Option 1
                      value: selectedLocation,
                      underline: const SizedBox(),
                      isExpanded: true,
                      onChanged: (newValue) {
                        if (newValue != 'Goals/Credit Edit') {
                          /* setState(() {
                            _selectedCountry = newValue.toString();
                          });*/
                        }
                      },
                      items: locations.map((location) {
                        return DropdownMenuItem(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      "Help description",
                      style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 25, right: 25, top: 5, bottom: 0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.05),
                          blurRadius: 8.0,
                          offset: Offset(0.0, 1),
                        ),
                      ],
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const TextField(
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      keyboardType: TextInputType.multiline,
                      maxLines: 10,
                      textInputAction: TextInputAction.done,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(top: 10, bottom: 10,left: 10,right: 10),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const Spacer(),
                  RoundedEdgeButton(
                    backgroundColor: Colors.pink,
                    text: "Send",
                    bottomMargin: 100,
                    buttonRadius: 10,
                    onPressed: () {},
                    context: context,
                  )
                ],
              ),
            ),
          );
        });
  }
}
