import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hackathon/constants/themes.dart';
import 'package:flutter_puzzle_hackathon/widgets/responsive.dart';

class StartPlayingPainter extends CustomPainter {
  final BuildContext context;
  final String text;
  static const double iconSize=20;
  const StartPlayingPainter(this.context,this.text);

  @override
  void paint(Canvas canvas, Size size) {
    const pointMode = ui.PointMode.polygon;
    final textStyle = TextStyle(
      fontFamily: 'Raleway',
      fontSize: Responsive.size(context, mobile: 17, tablet: 30, desktop: 15),
      color: const Color(0xc2ffffff),
    );
    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    const xCenter = 0.0;
    final yCenter = (size.height-textPainter.height) / 2;
    final textOffset = Offset(xCenter, yCenter);
    textPainter.paint(canvas, textOffset);

    const icon = Icons.arrow_forward;
    TextPainter iconPainter = TextPainter(textDirection: TextDirection.ltr);
    iconPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        color: Themes.primaryColor,
        fontSize: iconSize,
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
      ),
    );
    iconPainter.layout();
    iconPainter.paint(canvas, Offset(size.width-iconSize, (size.height-iconPainter.height)/2));
    final points = [
      Offset(textPainter.width+10, size.height/2),
      Offset(size.width-(iconPainter.width/2), size.height/2),
    ];
    final paint = Paint()
      ..color = Themes.primaryColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawPoints(pointMode, points, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}