import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';
import 'package:teamup/controllers/VEGoalController.dart';
import 'package:teamup/models/IndividualGoalActivityModel.dart';
import 'package:teamup/utils/app_colors.dart';
import 'package:teamup/widgets/edittext_with_hint.dart';
import 'package:teamup/widgets/rounded_edge_button.dart';

class EditGoalActivityView extends StatefulWidget {
  final IndividualGoalActivityModel activityModel;

  const EditGoalActivityView(
      {super.key, required this.activityModel});

  @override
  State<EditGoalActivityView> createState() => _EditGoalNDViewState();
}

class _EditGoalNDViewState extends State<EditGoalActivityView> {

  late TextEditingController activityNC;

  var isNextAllowed = true.obs;

  VEGoalController veGoalController = Get.find();

  @override
  void initState() {
    activityNC = TextEditingController(text: widget.activityModel.name ?? "");
    super.initState();

  }


  @override
  void dispose() {
    activityNC.dispose();
    super.dispose();
  }

  var selectedFrequencyIndex = 0.obs;



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
          "Activity Name",
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
              hintText: "Enter Activity Name",
              context: context,
              leftMargin: 0,
              rightMargin: 0,
              radius: 5,
              textEditingController:
              activityNC,
              inputAction: TextInputAction.done,
              inputType: TextInputType.text),
        ),

        const SizedBox(
          height: 15,
        ),
        ///Frequency
        Text(
          "Frequency",
          style: GoogleFonts.roboto(
            color: Colors.grey.shade900,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(height: 1.h,),
        Obx(()=>RoundedEdgeButton(
            backgroundColor: isNextAllowed.value
                ? Colors.red
                : Colors.grey,
            text: "Done",
            leftMargin: 0,
            rightMargin: 0,
            topMargin: 20,
            buttonRadius: 5,
            onPressed: () {
              if(!isNextAllowed.value){
                //TODO Show Error
                return;
              }
              veGoalController.updateActivityModel(widget.activityModel);
            },
            context: context))
      ],
    );
  }
}
