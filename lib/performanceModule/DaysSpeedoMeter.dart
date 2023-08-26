import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:math' as math;

import 'package:sizer/sizer.dart';

class DaySpeedoMeter extends CustomPainter{
  final double startAngle;
  final double sweepAngle;
  final double value;
  final double totalValue;
  final double strokeCircleW;
  final double basicTextS;
  final double innerBTextS;
  final double innerSTextS;

  DaySpeedoMeter(this.startAngle, this.sweepAngle, this.value, this.totalValue, this.strokeCircleW, this.basicTextS, this.innerBTextS, this.innerSTextS);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.5;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paint1 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeCircleW
      ..strokeCap = StrokeCap.round
      ..color = Colors.red;

    final paint2 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeCircleW
      ..strokeCap = StrokeCap.round
      ..color = Colors.grey[400] ?? Colors.grey;

    // Single Color
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint2);

    final sweepRadian1 = (sweepAngle * value / totalValue);
    //final sweepRadian2 = (sweepAngle * (totalValue - value) / totalValue);

    //final rect1 = Rect.fromCircle(center: center, radius: radius - paint1.strokeWidth / 2);
    final rect1 = Rect.fromCircle(center: center, radius: radius);
    //final rect2 = Rect.fromCircle(center: center, radius: radius - paint2.strokeWidth / 2);

    canvas.drawArc(rect1, startAngle, sweepRadian1, false, paint1);
    //canvas.drawArc(rect2, startAngle + sweepRadian1, sweepRadian2, false, paint2);

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    final textStyle = TextStyle(
      color: Colors.red,
      fontSize: basicTextS,
      fontWeight: FontWeight.bold
    );

    final angle = startAngle + sweepAngle / 2;
    final x1 = center.dx + math.cos(startAngle) * radius * 0.75;
    final y1 = center.dy + math.sin(startAngle) * radius;
    final x2 = center.dx + math.cos(startAngle + sweepAngle) * radius * 0.75;
    final y2 = center.dy + math.sin(startAngle + sweepAngle) * radius;

    final daysText = TextSpan(text: "Days", style: textStyle);
    final daysTextPainter = TextPainter(
      text: daysText,
      textDirection: TextDirection.ltr,
    );
    daysTextPainter.layout();

    final centerLine = Offset((x1 + x2) / 2, (y1 + y2) / 2);
    final offset = Offset(centerLine.dx - daysTextPainter.width / 2,
        centerLine.dy - daysTextPainter.height / 2);

    daysTextPainter.paint(canvas, offset);

    /*// Show value/totalValue text in the center of the arc
    final valueText = TextSpan(text: "${value.toInt()}/${totalValue.toInt()}", style: textStyle);
    final valueTextPainter = TextPainter(
      text: valueText,
      textDirection: TextDirection.ltr,
    );
    valueTextPainter.layout();

    final valueOffset = Offset(center.dx - valueTextPainter.width / 2, center.dy - valueTextPainter.height / 2);

    valueTextPainter.paint(canvas, valueOffset);*/


    final textStyle1 = TextStyle(
      color: Colors.black,
      fontSize: innerBTextS,
      fontWeight: FontWeight.bold
    );

    final textStyle2 = TextStyle(
      color: Colors.black,
      fontSize: innerSTextS,
    );
    // Show value/totalValue text in the center of the arc
    final valueText = TextSpan(
      children: [
        TextSpan(text: " ${value.toInt()}", style: textStyle1,),
        TextSpan(text: "\n/${totalValue.toInt()}", style: textStyle2),
      ],
    );
    final valueTextPainter = TextPainter(
      text: valueText,
      textDirection: TextDirection.ltr,
    );
    valueTextPainter.layout();

    final valueOffset = Offset(center.dx - valueTextPainter.width / 2, center.dy - valueTextPainter.height / 2);

    valueTextPainter.paint(canvas, valueOffset);


  }

  @override
  bool shouldRepaint(DaySpeedoMeter oldDelegate) {
  return false;
    /*return oldDelegate.startAngle != startAngle ||
        oldDelegate.sweepAngle != sweepAngle;*/
  }
}