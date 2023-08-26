//Provides the Images Wrapped with circular Boundary
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';

import '../Constants.dart';

class CircularContainer extends StatelessWidget {
  const CircularContainer(
      {Key? key,
        required this.imagePath,
        this.iconData,
        this.iconColor,
        this.padding,
        this.iconSize,
        this.isBreakfast,this.filledColor,this.outlineColor})
      : super(key: key);

  final String imagePath;
  final IconData? iconData;
  final Color? iconColor;
  final double? iconSize;
  final EdgeInsets? padding;
  final bool? isBreakfast;
  final Color? filledColor;
  final Color? outlineColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: padding ?? EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: filledColor ?? HexColor(Constants.PRIMARYCOLOR), shape: BoxShape.circle,
        border: Border.all(color: outlineColor ?? HexColor(Constants.PRIMARYCOLOR))),
        child: imagePath.isEmpty
            ? Icon(
          iconData,
          color: iconColor ?? HexColor(Constants.PRIMARYCOLOR),
          size: iconSize ?? 10.sp,
        )
            : Padding(
          padding: isBreakfast != null
              ? (isBreakfast!
              ? EdgeInsets.fromLTRB(0, 0, 0, 8)
              : EdgeInsets.zero)
              : EdgeInsets.zero,
          child: Image.asset(imagePath),
        ));
  }
}