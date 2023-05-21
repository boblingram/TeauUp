import 'package:flutter/material.dart';

class OptionTile extends StatelessWidget {
  final String title;
  final double tileHeight;
  final Widget trailingWidget;
  final FontWeight fontWeight;
  final double leftPadding;
  final double rightPadding;
  final Function onTap;
  final String subTitle;

  final double bottomPadding;

  const OptionTile({
    super.key,
    required this.title,
    required this.onTap,
    required this.trailingWidget,
    this.fontWeight = FontWeight.w400,
    this.leftPadding = 20,
    this.tileHeight = 50,
    this.rightPadding = 20,
    this.subTitle = '',
    this.bottomPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        height: tileHeight,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.05),
                blurRadius: 8.0,
                offset: Offset(0.0, 1),
              ),
            ],
            borderRadius: BorderRadius.circular(4)),
        padding: EdgeInsets.only(
          left: leftPadding,
          right: rightPadding,
          bottom: bottomPadding,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: fontWeight,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                trailingWidget,
              ],
              //contentPadding: EdgeInsets.zero,
            ),
            SizedBox(
              height: subTitle.isEmpty ? 0 : 5,
            ),
            subTitle.isEmpty
                ? const SizedBox()
                : Row(
                    children: [
                       Icon(
                        Icons.check_circle,
                        color: Colors.green.shade800,
                        size: 15,
                      ),
                      const SizedBox(width: 4,),
                      Text(
                        subTitle,
                        style:  TextStyle(
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.w400,
                            fontSize: 12),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
