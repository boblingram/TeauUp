import 'package:flutter/material.dart';

class Edittext extends StatelessWidget {
  final String hintText;
  final BuildContext context;
  final IconData? leadingIcon;
  final Icon? trailingIcon;
  final double radius;
  final TextEditingController textEditingController;
  final bool isObscure;
  final double leftMargin;
  final double rightMargin;
  final double topMargin;
  final Color backgroundColor;
  final double bottomMargin;
  final Color hintColor;
  final Color iconColor;
  final Color textColor;

  const Edittext(
      {super.key,
      required this.hintText,
      this.leadingIcon,
      required this.context,
      this.backgroundColor = Colors.white,
      this.hintColor = Colors.white,
      this.trailingIcon,
      this.iconColor = Colors.white,
      this.textColor = Colors.white,
      this.radius = 15,
      required this.textEditingController,
      this.isObscure = false,
      this.leftMargin = 0,
      this.rightMargin = 0,
      this.topMargin = 0,
      this.bottomMargin = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
      ),
      margin: EdgeInsets.only(
          left: leftMargin,
          right: rightMargin,
          bottom: bottomMargin,
          top: topMargin),
      child: TextField(
        style: TextStyle(color: textColor),
        maxLines: 1,
        textAlignVertical: TextAlignVertical.center,
        controller: textEditingController,
        cursorColor: Colors.white.withOpacity(0.1),
        obscureText: isObscure,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            leadingIcon,
            color: iconColor,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: hintColor,
          ),
        ),
      ),
    );
  }
}
