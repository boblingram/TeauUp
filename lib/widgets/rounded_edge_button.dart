import 'package:flutter/material.dart';

class RoundedEdgeButton extends StatelessWidget {
  final double height;
  final Color backgroundColor;
  final String text;
  final Color textColor;
  final FontWeight textFontWeight;
  final double textFontSize;
  final Function onPressed;
  final double buttonRadius;
  final double leftMargin;
  final double rightMargin;
  final double topMargin;
  final double bottomMargin;
  final BuildContext context;
  final double buttonElevation;
  final Color borderColor;

  const RoundedEdgeButton(
      {super.key,
      this.height = 48,
      required this.backgroundColor,
      required this.text,
      this.textColor = Colors.white,
      this.textFontWeight = FontWeight.bold,
      this.textFontSize = 18,
      required this.onPressed,
      this.buttonRadius = 4,
      this.leftMargin = 14,
      this.rightMargin = 14,
      this.topMargin = 0,
      this.bottomMargin = 0,
      this.buttonElevation = 0,
      this.borderColor = Colors.transparent,
      required this.context})
      : assert(
          text != null,
          'A non-null String must be provided to a Text widget.',
        );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onPressed();
      },
      child: Container(
        width: double.infinity,
        height: height,
        margin: EdgeInsets.only(
            left: leftMargin,
            right: rightMargin,
            top: topMargin,
            bottom: bottomMargin),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          color: backgroundColor,
          borderRadius: BorderRadius.circular(buttonRadius),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
                fontSize: textFontSize,
                fontStyle: FontStyle.normal),
          ),
        ),
      ),
    );
  }
}
