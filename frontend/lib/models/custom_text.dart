import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CustomText extends StatelessWidget {
  final String data;
  final String fontFamily;
  final Color color;
  final FontStyle fontStyle;
  final textAlign;
  final int maxLines;
  final double fontSize;
  final double minFontSize;
  final double maxFontSize;

  const CustomText({
    super.key,
    required this.data,
    required this.fontSize,
    this.fontFamily = 'Boxtoon',
    this.color = Colors.black,
    this.fontStyle = FontStyle.italic,
    this.textAlign = TextAlign.start,
    this.maxLines = 1,
    this.minFontSize = 12,
    this.maxFontSize = 28,
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      data,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        color: color,
        fontStyle: fontStyle,
      ),
      maxLines: maxLines,
      minFontSize: minFontSize,
      maxFontSize: maxFontSize,
      overflow: TextOverflow.clip,
      textAlign: TextAlign.center,
    );
  }
}

class CustomTextRow extends StatelessWidget {
  final String partOne;
  final String partTwo;
  final TextStyle defaultStyleOne;
  final TextStyle defaultStyleTwo;
  final double minFontSize;
  final double maxFontSize;
  final TextAlign textAlign;
  final bool wrapWords;
  final TextOverflow overflow;
  final int maxLines;

  const CustomTextRow({
    super.key,
    required this.partOne,
    required this.partTwo,
    this.defaultStyleOne = const TextStyle(color: Colors.black, fontSize: 24, fontStyle: FontStyle.italic, fontFamily: 'Boxtoon'),
    this.defaultStyleTwo = const TextStyle(color: Colors.red, fontSize: 24, fontStyle: FontStyle.italic, fontFamily: 'Boxtoon'),
    this.minFontSize = 10,
    this.maxFontSize = 24,
    this.textAlign = TextAlign.start,
    this.wrapWords = false,
    this.overflow = TextOverflow.visible,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: RichText(
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        text: TextSpan(
          style: TextStyle(fontSize: maxFontSize),
          children: [
            TextSpan(
              text: partOne,
              style: defaultStyleOne.copyWith(fontSize: maxFontSize),
            ),
            TextSpan(
              text: partTwo,
              style: defaultStyleTwo.copyWith(fontSize: maxFontSize),
            ),
          ],
        ),
      ),
    );
  }
}