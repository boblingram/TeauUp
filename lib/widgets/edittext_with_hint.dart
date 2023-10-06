import 'package:flutter/material.dart';

class EditTextWithHint extends StatelessWidget {
  final String hintText;
  final double leftMargin;
  final double rightMargin;
  final double topMargin;
  final double bottomMargin;
  final TextEditingController? textEditingController;
  final BuildContext context;
  final bool isObscure;
  final IconData? trailingIcon;
  final IconData? leadingIcon;
  final double radius;
  final Color? iconColor;
  final bool isEnabled;
  final int maxLines;
  final FocusNode? focusNode;

  final TextInputAction inputAction;

  final TextInputType inputType;

  const EditTextWithHint(
      {super.key,
      required this.hintText,
      this.leftMargin = 14,
        this.maxLines =1 ,
      this.rightMargin = 14,
      this.radius = 5,
      required this.context,
      required this.inputAction,
      this.topMargin = 0,
      this.bottomMargin = 0,
      this.textEditingController,
      required this.inputType,
      this.isObscure = false,
      this.trailingIcon,
      this.leadingIcon,
      this.isEnabled = true,
      this.iconColor,
      this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: leftMargin,
          right: rightMargin,
          top: topMargin,
          bottom: bottomMargin),
      decoration: BoxDecoration(
          color: Colors.grey.shade200,
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              blurRadius: 8.0,
              offset: Offset(0.0, 1),
            ),
          ],
          borderRadius: BorderRadius.circular(radius)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: 15,
            ),
            child: TextField(
              focusNode: focusNode,
              style: const TextStyle(color: Colors.black, fontSize: 16),
              maxLines: maxLines,
              controller: textEditingController,
              enabled: isEnabled,
              keyboardType: inputType,
              textInputAction: inputAction,
              cursorColor: Colors.black.withOpacity(0.1),
              obscureText: isObscure,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 10, bottom: 10),
                border: InputBorder.none,
                labelText: hintText,
                labelStyle: TextStyle(
                  color: Colors.grey.shade400,
                ),
                suffixIcon: Icon(
                  trailingIcon,
                  color: iconColor,
                ),
                /* hintText: hintText,
                hintStyle: TextStyle(
                  color: hintColor,
                ),*/
              ),
            ),
          ),
        ],
      ),
    );
  }
}
