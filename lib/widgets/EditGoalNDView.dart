import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';
import 'package:teamup/controllers/VEGoalController.dart';
import 'package:teamup/utils/Constants.dart';
import 'package:teamup/utils/app_colors.dart';
import 'package:teamup/widgets/edittext_with_hint.dart';
import 'package:teamup/widgets/rounded_edge_button.dart';

class EditGoalNDView extends StatefulWidget {
  final String name;
  final String description;

  const EditGoalNDView(
      {super.key, required this.name, required this.description});

  @override
  State<EditGoalNDView> createState() => _EditGoalNDViewState();
}

class _EditGoalNDViewState extends State<EditGoalNDView> {

  late TextEditingController goalNTC;
  late TextEditingController goalDTC;

  var isNextAllowed = true.obs;

  VEGoalController veGoalController = Get.find();

  @override
  void initState() {
    goalNTC = TextEditingController(text: widget.name);
    goalDTC = TextEditingController(text: widget.description);
    super.initState();

    goalNTC.addListener(_handleTextChanged);
    goalDTC.addListener(_handleTextChanged);
  }


  @override
  void dispose() {
    goalNTC.removeListener(_handleTextChanged);
    goalDTC.removeListener(_handleTextChanged);
    goalNTC.dispose();
    goalDTC.dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    isNextAllowed.value = goalNTC.text
        .trim()
        .isNotEmpty &&
        goalDTC.text
            .trim()
            .isNotEmpty;
  }


  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      children: [
        SizedBox(height: 0.5.h),
        Align(
          alignment: Alignment.centerRight,
          child: CircleAvatar(
            radius: 12.sp,
            backgroundColor: HexColor(AppColors.customIconBG),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: IconButton(
                icon: Icon(Icons.close,color: Colors.white,size: 12.sp,), onPressed: () { Get.back();},
              ),
            ),
          ),
        ),
        Text(
          "Goal Name",
          style: GoogleFonts.roboto(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5)),
          child: EditTextWithHint(
              hintText: "Enter Goal Name",
              context: context,
              leftMargin: 0,
              rightMargin: 0,
              radius: 5,
              textEditingController:
              goalNTC,
              inputAction: TextInputAction.done,
              inputType: TextInputType.text),
        ),
        Text(
          "Goal Description",
          style: GoogleFonts.roboto(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5)),
          child: EditTextWithHint(
              hintText: "",
              maxLines: 6,
              context: context,
              leftMargin: 0,
              rightMargin: 0,
              textEditingController:
              goalDTC,
              inputAction: TextInputAction.done,
              inputType: TextInputType.text),
        ),
        const SizedBox(
          height: 15,
        ),
        Obx(()=>RoundedEdgeButton(
            backgroundColor: isNextAllowed.value
                ? Colors.red
                : Colors.grey,
            text: "Next",
            leftMargin: 0,
            rightMargin: 0,
            topMargin: 20,
            buttonRadius: 5,
            onPressed: () {
              if(!isNextAllowed.value){
                showErrorWOTitle("Please enter name and description");
                return;
              }
              veGoalController.updateGoalND(goalNTC.text.trim(),goalDTC.text.trim());
            },
            context: context))
      ],
    );
  }
}
